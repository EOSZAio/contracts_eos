#!/usr/bin/env python3

# import argparse
# import json
# import numpy
# import os
# import random
# import re
import subprocess
import sys
# import time
import requests

URL = "https://api.coingecko.com/api/v3/simple/price"
API = "http://api.telos.africa"
#API = "https://telosapi.eosmetal.io"
PASSWORD="PW5HwwRqAM6dgEy2KwHRArxNgG28YAPAc9PXtbZncGT44re5jfNeW"

ACCOUNT="bot.tbn"
CONVERTER="zar.tbn"
NET_TKN_CONTRACT="eosio.token"
NET_TKN_SYMBOL="TLOS"
TKN_CONTRACT="stablecoin.z"
TKN_SYMBOL="EZAR"

# Used to account for local market premium
PREMIUM=1.0
TRADE_QUANTITY=5.0
SPREAD=3.0

def run(args):
    if subprocess.call(args, shell=True):
        sys.exit(1)

def get_output(args):
    proc = subprocess.Popen(args, shell=True, stdout=subprocess.PIPE)
    return proc.communicate()[0].decode('utf-8')

def get_price(s):
    query_parameters = {'ids':'telos','vs_currencies':s}
    r = requests.get(url = URL, params = query_parameters)
    data = r.json()
    price =  data['telos'][s]
    # Catch bad price data
    if price < 1.0 or price > 3.0:
        sys.exit(1)
    return price

def get_currency_balance(account, contract, symbol):
    balance = get_output('cleos --url ' + API + ' get currency balance ' + contract + ' ' + account + ' ' + symbol).split()
    if len(balance) == 0:
        balance[0] = '0.0'
        balance[1] = symbol
    return balance

run('cleos wallet unlock -n bancor --password ' + PASSWORD)
print('')

coingecko_price = get_price('zar')
token_liquidity = get_currency_balance(CONVERTER, TKN_CONTRACT, TKN_SYMBOL)
net_token_liquidity = get_currency_balance(CONVERTER, NET_TKN_CONTRACT, NET_TKN_SYMBOL)

# Check bot.tbn balance (natwork : TLOS, token : EZAR)
bot_net_balance = get_currency_balance('bot.tbn', NET_TKN_CONTRACT, NET_TKN_SYMBOL)
bot_token_balance = get_currency_balance('bot.tbn', TKN_CONTRACT, TKN_SYMBOL)

bancor_price = float(token_liquidity[0]) / float(net_token_liquidity[0])
price_delta = (bancor_price - coingecko_price * PREMIUM) / coingecko_price * PREMIUM * 100.0

print('CoinGecho price       : ' + format(coingecko_price, '.4f') + ' R/TLOS')
print('Bancor price          : ' + format(bancor_price, '.4f') + ' EZAR/TLOS')
print('Price premium         : ' + str(round(100.0 * (PREMIUM - 1.0), 2)) + '%')

print('\nPrice delta           : ' + format(price_delta, '.2f') + '%')
print('Price delta limit     : ' + format(SPREAD/2.0, '.2f') + '%\n')

print(TKN_SYMBOL + ' liquidity depth  : ' + token_liquidity[0] + ' ' + token_liquidity[1])
print(NET_TKN_SYMBOL + ' liquidity depth  : ' + net_token_liquidity[0] + ' ' + net_token_liquidity[1])
print('bot.tbn ' + TKN_SYMBOL + ' balance  : ' + bot_token_balance[0] + ' ' + bot_token_balance[1])
print('bot.tbn ' + NET_TKN_SYMBOL + ' balance  : ' + bot_net_balance[0] + ' ' + bot_net_balance[1])

print('\nTotal ' + TKN_SYMBOL + ' balance    : ' + format(float(token_liquidity[0]) + float(bot_token_balance[0]), '.2f') + ' ' + bot_token_balance[1])
print('Total ' + NET_TKN_SYMBOL + ' balance    : ' + format(float(net_token_liquidity[0]) + float(bot_net_balance[0]), '.4f') + ' ' + bot_net_balance[1])

if price_delta > SPREAD/2.0:
    quantity = TRADE_QUANTITY
    quantity_str = format(quantity, '.4f')
    if  float(bot_net_balance[0]) > quantity:
        print('\n=>> Buy ' + format(quantity * bancor_price * 0.995, '.4f') + ' EZAR\n')
        stop_loss = round(0.98 * bancor_price * quantity, 6)
        cmd = 'cleos --url ' + API + ' push action eosio.token transfer \'["' + ACCOUNT + '","bancor.tbn","' + quantity_str + ' TLOS","1,zar.tbn EZAR,' \
              + str(stop_loss) + ',' + ACCOUNT + '"]\' -p ' + ACCOUNT + '@active'
        run(cmd)
    else:
        print('\n=>> Insufficient funds, bot.tbn balance : ' + bot_net_balance[0] + ' ' + bot_net_balance[1] + '\n')
else:
    if price_delta < -SPREAD/2.0:
        quantity = TRADE_QUANTITY * bancor_price
        quantity_str = format(quantity, '.2f')
        if  float(bot_token_balance[0]) > quantity:
            print('\n=>> Sell ' + quantity_str + ' EZAR')
            stop_loss = round(0.98 * quantity / bancor_price, 6)
            cmd = 'cleos --url ' + API + ' push action stablecoin.z transfer \'["' + ACCOUNT + '","bancor.tbn","' + quantity_str + ' EZAR","1,zar.tbn TLOS,' \
                  + str(stop_loss) + ',' + ACCOUNT + '"]\' -p ' + ACCOUNT + '@active'
            run(cmd)
        else:
            print('\n=>> Insufficient funds, bot.tbn balance : ' + bot_token_balance[0] + ' ' + bot_token_balance[1] + '\n')
    else:
        print('\n=>> No action\n')

