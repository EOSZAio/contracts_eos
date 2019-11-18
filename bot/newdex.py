#!/usr/bin/env python3

import json
import subprocess
import sys
import requests
import time

# Newdex API https://github.com/newdex/api-docs/blob/master/api/REST_api_reference.md
# https://api.newdex.io/v1/depth?symbol=telosdacdrop-tlosdac-tlos
URL = "https://api.newdex.io/v1/depth"

API = "http://api.telos.africa"
#API = "https://telosapi.eosmetal.io"

CONFIG="tlosdac.json"
#CONFIG="qbe.json"
#CONFIG="rev.json"

ACCOUNT="bot.tbn"
TLOS_CONTRACT="eosio.token"
TLOS_SYMBOL="TLOS"

NEWDEX_FEE=0.002
#MAX_TRADE=10.0

def run(args):
    if subprocess.call(args, shell=True):
        sys.exit(1)

def get_output(args):
    proc = subprocess.Popen(args, shell=True, stdout=subprocess.PIPE)
    return proc.communicate()[0].decode('utf-8')

def get_currency_balance(account, contract, symbol):
    balance = get_output('cleos --url ' + API + ' get currency balance ' + contract + ' ' + account + ' ' + symbol).split()
    if len(balance) == 0:
        balance = ['0.0',symbol]
    return balance

def get_bancor_result(da, a, b, fee):
    res = da * b / (a + da)
    return (1 - fee) * res

def get_market(s):
    query_parameters = {'symbol':s}
    r = requests.get(url = URL, params = query_parameters)
    data = r.json()
    return data

print('\n==============================\n')
# {'market': 'telosdacdrop-tlosdac-tlos', 'converter': 'dac.tbn', 'contract': 'telosdacdrop', 'symbol': 'TLOSDAC'}
if len(sys.argv) > 1:
    CONFIG=sys.argv[1]

# Config set from file
with open(CONFIG) as json_file:
    data = json.load(json_file)
    MARKET=data['market']
    CONVERTER=data['converter']
    OTHER_CONTRACT=data['contract']
    OTHER_SYMBOL=data['symbol']
    MAX_TRADE=data['maxtrade']
    print("Configuration file : ",CONFIG)
    print("Configuration      : ",data)

# Newdex market
market = get_market(MARKET)

# Bancor
tlos_liquidity = get_currency_balance(CONVERTER, TLOS_CONTRACT, TLOS_SYMBOL)
other_liquidity = get_currency_balance(CONVERTER, OTHER_CONTRACT, OTHER_SYMBOL)
bancor_price = float(tlos_liquidity[0])/float(other_liquidity[0])
price_units = TLOS_SYMBOL + '/' + OTHER_SYMBOL
max_trade = MAX_TRADE / bancor_price

print('\n==============================\n')
print(TLOS_SYMBOL + ' liquidity depth    : ' + tlos_liquidity[0] + ' ' + TLOS_SYMBOL)
print(OTHER_SYMBOL + ' liquidity depth     : ' + other_liquidity[0] + ' ' + OTHER_SYMBOL)
print('Bancor price            :', format(bancor_price, '.4f') + ' ' + price_units)
print('Max trade               :', format(max_trade, '.4f') + ' ' + OTHER_SYMBOL)

if market['code'] == 200:
    # Check best bid
    print('\n============ asks ============')
    bids = market['data']['bids']
    l = len(bids)
    if l > 0:
        best_bid = bids[0]
        bid_price = best_bid[0]
        bid_quantity = best_bid[1]
        newdex_quantity = min(max_trade, bid_quantity)
        newdex_result = newdex_quantity * bid_price * (1.0 - NEWDEX_FEE)

        convert_quantity = get_bancor_result(newdex_result, float(tlos_liquidity[0]), float(other_liquidity[0]), 0.005)
        convert_price = newdex_quantity * bid_price * (1.0 - NEWDEX_FEE) / convert_quantity
        net_result = convert_quantity - newdex_quantity

        print('\nNewdex ' + OTHER_SYMBOL + '->TLOS, Bancor TLOS->' + OTHER_SYMBOL)
        print('\nNumber of bids   : ', str(l))
        print('Best bid         : ', best_bid)
        print('Price            : ', format(bid_price, '.5f') + ' ' + price_units)
        print('Quantity         : ', format(bid_quantity, '.4f') + ' ' + OTHER_SYMBOL)
        print('Newdex quantity  : ', format(newdex_quantity, '.4f') + ' ' + OTHER_SYMBOL)
        print('Newdex result    : ', format(newdex_result, '.4f') + ' ' + TLOS_SYMBOL)

        print('\nConvert quantity : ', format(convert_quantity, '.4f') + ' ' + OTHER_SYMBOL)
        print('Convert price    : ', format(convert_price, '.5f') + ' ' + price_units)

        print('\nTrade            : ' + format(newdex_quantity, '.4f') + ' ' + OTHER_SYMBOL)
        print('Receive          : ' + format(convert_quantity, '.4f') + ' ' + OTHER_SYMBOL)
        print('Net gain         : ' + format(net_result, '.4f') + ' ' + OTHER_SYMBOL)
        if net_result > 0:
            print('\n>>>>>>>> Viable trade <<<<<<<<')
            available_funds = get_currency_balance(ACCOUNT, OTHER_CONTRACT, OTHER_SYMBOL)
            balance_before_newdex = get_currency_balance(ACCOUNT, TLOS_CONTRACT, TLOS_SYMBOL)
            newdex_quantity = min(newdex_quantity, float(available_funds[0]))

            # {"type":"sell-limit","symbol":"telosdacdrop-tlosdac-tlos","price":"0.00331","channel":"API"}
            order = '{\\"type\\":\\"sell-limit\\",\\"symbol\\":\\"' + MARKET + '\\",\\"price\\":\\"' + format(bid_price, '.5f') + '\\",\\"channel\\":\\"API\\"}'
            cmd = 'cleos --url ' + API + ' push action '+OTHER_CONTRACT+' transfer \'["' + ACCOUNT + '","newdex","' \
                  + format(newdex_quantity, '.4f') + ' ' + OTHER_SYMBOL \
                  + '","' + str(order) + '"]\' -p ' + ACCOUNT + '@active'
            print(cmd)
            if newdex_quantity > 0.0:
                run(cmd)

            time.sleep(10)
            balance_after_newdex = get_currency_balance(ACCOUNT, TLOS_CONTRACT, TLOS_SYMBOL)
            bancor_quantity = float(balance_after_newdex[0]) - float(balance_before_newdex[0])

            print('Trade            : ' + format(newdex_quantity, '.4f') + ' ' + available_funds[1])
            print('Before trade     : ' + format(float(balance_before_newdex[0]), '.4f') + ' ' + balance_before_newdex[1])
            print('After trade      : ' + format(float(balance_after_newdex[0]), '.4f') + ' ' + balance_before_newdex[1])
            print('Receive          : ' + format(bancor_quantity, '.4f') + ' ' + balance_before_newdex[1])

            stop_loss = round(0.98 * get_bancor_result(bancor_quantity, float(tlos_liquidity[0]), float(other_liquidity[0]), 0.005), 6)
            cmd = 'cleos --url ' + API + ' push action ' + TLOS_CONTRACT + ' transfer \'["' + ACCOUNT + '","bancor.tbn","' \
                  + format(bancor_quantity, '.4f') + ' ' + TLOS_SYMBOL + '","1,' + CONVERTER + ' ' + available_funds[1] \
                  + ',' + str(stop_loss) + ',' + ACCOUNT + '"]\' -p ' + ACCOUNT + '@active'
            print(cmd)
            if bancor_quantity > 0.0:
                run(cmd)

        else:
            print('\n>>>>>>>>> Not viable <<<<<<<<<')

    #For logging
        p1 = format(bid_price, '.4f')
        q1 = format(convert_price, '.4f')
        r1 = format(net_result, '.4f')

    # Check best ask
    print('\n============ bids ============')
    asks = market['data']['asks']
    l = len(asks)
    if l > 0:
        best_ask = asks[l - 1]
        ask_price = best_ask[0]
        ask_quantity = best_ask[1]
        newdex_quantity = min(MAX_TRADE, ask_quantity * ask_price)
        newdex_result = newdex_quantity / ask_price * (1.0 - NEWDEX_FEE)

        convert_quantity = get_bancor_result(newdex_result, float(other_liquidity[0]), float(tlos_liquidity[0]), 0.005)
        convert_price = convert_quantity / (newdex_quantity / ask_price * (1.0 - NEWDEX_FEE))

        net_result = convert_quantity - newdex_quantity

        print('\nNewdex TLOS->' + OTHER_SYMBOL + ', Bancor ' + OTHER_SYMBOL + '->TLOS')
        print('\nNumber of asks   : ', str(l))
        print('Best ask         : ', best_ask)
        print('Price            : ', format(ask_price, '.5f') + ' ' + price_units)
        print('Quantity         : ', format(ask_quantity, '.4f') + ' ' + OTHER_SYMBOL)
        print('Newdex quantity  : ', format(newdex_quantity, '.4f') + ' ' + TLOS_SYMBOL)
        print('Newdex result    : ', format(newdex_result, '.4f') + ' ' + OTHER_SYMBOL)

        print('\nConvert quantity : ', format(convert_quantity, '.4f') + ' ' + TLOS_SYMBOL)
        print('Convert price    : ', format(convert_price, '.5f') + ' ' + price_units)

        print('\nTrade            : ' + format(newdex_quantity, '.4f') + ' ' + TLOS_SYMBOL)
        print('Receive          : ' + format(convert_quantity, '.4f') + ' ' + TLOS_SYMBOL)
        print('Net gain         : ' + format(net_result, '.4f') + ' ' + TLOS_SYMBOL)
        if net_result > 0:
            print('\n>>>>>>>> Viable trade <<<<<<<<')
            available_funds = get_currency_balance(ACCOUNT, TLOS_CONTRACT, TLOS_SYMBOL)
            balance_before_newdex = get_currency_balance(ACCOUNT, OTHER_CONTRACT, OTHER_SYMBOL)
            newdex_quantity = min(newdex_quantity, float(available_funds[0]))

            # {"type":"sell-limit","symbol":"telosdacdrop-tlosdac-tlos","price":"0.00331","channel":"API"}
            order = '{\\"type\\":\\"buy-limit\\",\\"symbol\\":\\"' + MARKET + '\\",\\"price\\":\\"' + format(ask_price, '.5f') + '\\",\\"channel\\":\\"API\\"}'
            print(order)
            cmd = 'cleos --url ' + API + ' push action ' + TLOS_CONTRACT + ' transfer \'["' + ACCOUNT + '","newdex","' \
                  + format(newdex_quantity, '.4f') + ' ' + TLOS_SYMBOL \
                  + '","' + str(order) + '"]\' -p ' + ACCOUNT + '@active'
            print(cmd)
            if newdex_quantity > 0.0:
                run(cmd)

            time.sleep(10)
            balance_after_newdex = get_currency_balance(ACCOUNT, OTHER_CONTRACT, OTHER_SYMBOL)
            bancor_quantity = float(balance_after_newdex[0]) - float(balance_before_newdex[0])

            print('Trade            : ' + format(newdex_quantity, '.4f') + ' ' + available_funds[1])
            print('Before trade     : ' + format(float(balance_before_newdex[0]), '.4f') + ' ' + balance_before_newdex[1])
            print('After trade      : ' + format(float(balance_after_newdex[0]), '.4f') + ' ' + balance_before_newdex[1])
            print('Receive          : ' + format(bancor_quantity, '.4f') + ' ' + balance_before_newdex[1])

            stop_loss = round(0.98 * get_bancor_result(bancor_quantity, float(other_liquidity[0]), float(tlos_liquidity[0]), 0.005), 6)
            cmd = 'cleos --url ' + API + ' push action ' + OTHER_CONTRACT + ' transfer \'["' + ACCOUNT + '","bancor.tbn","' \
                  + format(bancor_quantity, '.4f') + ' ' + OTHER_SYMBOL + '","1,' + CONVERTER + ' ' + available_funds[1] \
                  + ',' + str(stop_loss) + ',' + ACCOUNT + '"]\' -p ' + ACCOUNT + '@active'
            print(cmd)
            if bancor_quantity > 0.0:
                run(cmd)

        else:
            print('\n>>>>>>>>> Not viable <<<<<<<<<')

        #For logging
        p2 = format(ask_price, '.4f')
        q2 = format(convert_price, '.4f')
        r2 = format(net_result, '.4f')

else:
    print('error')

print('\n')

f = open("newdex.log", "a")
f.write(str(CONFIG)+", "+str(p1)+", "+str(q1)+", "+str(r1)+", "+str(p2)+", "+str(q2)+", "+str(r2)+"\n")
f.close()
