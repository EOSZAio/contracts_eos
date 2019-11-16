#!/usr/bin/env python3

# import argparse
# import json
# import numpy
# import os
# import random
# import re
import subprocess
import sys
import time
import requests

URL = "https://api.coingecko.com/api/v3/simple/price"
API = "https://api.telos.africa"
PASSWORD="PW5HwwRqAM6dgEy2KwHRArxNgG28YAPAc9PXtbZncGT44re5jfNeW"
ACCOUNT="bot.tbn"
CONVERTER="zar.tbn"
NET_TKN_CONTRACT="eosio.token"
NET_TKN_SYMBOL="TLOS"
TKN_CONTRACT="stablecoin.z"
TKN_SYMBOL="EZAR"
SPREAD=3.0

def run(args):
    if subprocess.call(args, shell=True):
        sys.exit(1)

def get_output(args):
    proc = subprocess.Popen(args, shell=True, stdout=subprocess.PIPE)
    return proc.communicate()[0].decode('utf-8')

def get_price(s):
    PARAMS = {'ids':'telos','vs_currencies':s}
    r = requests.get(url = URL, params = PARAMS)
    data = r.json()
    price =  data['telos'][s]
    # Catch bad price data
    if price < 1.0 or price > 2.0:
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

price = get_price('zar')
token_liquidity = get_currency_balance(CONVERTER, TKN_CONTRACT, TKN_SYMBOL)
net_token_liquidity = get_currency_balance(CONVERTER, NET_TKN_CONTRACT, NET_TKN_SYMBOL)

# Check bot.tbn balance (natwork : TLOS, token : EZAR)
bot_net_balance = get_currency_balance('bot.tbn', NET_TKN_CONTRACT, NET_TKN_SYMBOL)
bot_token_balance = get_currency_balance('bot.tbn', TKN_CONTRACT, TKN_SYMBOL)


bancor_price = float(token_liquidity[0]) / float(net_token_liquidity[0])
price_delta = (bancor_price - price) / price * 100.0

print('CoinGecho price      : ' + str(price))
print('Bancor price         : ' + str(round(bancor_price, 4)))

print('\nPrice delta          : ' + str(round(price_delta, 2)) + '%')
print('Price delta limit    : ' + str(SPREAD/2.0) + '%\n')

print(TKN_SYMBOL + ' liquidity depth : ' + token_liquidity[0] + ' ' + token_liquidity[1])
print(NET_TKN_SYMBOL + ' liquidity depth : ' + net_token_liquidity[0] + ' ' + net_token_liquidity[1])

if price_delta > SPREAD/2.0:
    # Check bot.tbn balance
#    bot_balance = get_currency_balance('bot.tbn', NET_TKN_CONTRACT, NET_TKN_SYMBOL)
    print('\nbot.tbn balance      : ' + bot_net_balance[0] + ' ' + bot_net_balance[1])
    if  float(bot_net_balance[0]) > 5.0:
        print('\n=>> Buy ' + str(round(5.0 * bancor_price * 0.995, 2)) + ' EZAR\n')
        stop_loss = round(0.98 * bancor_price * 5.0, 6)
        x = 'cleos --url ' + API + ' push action eosio.token transfer \'["' + ACCOUNT + '","bancor.tbn","5.0000 TLOS","1,zar.tbn EZAR,' + str(stop_loss) + ',' + ACCOUNT + '"]\' -p ' + ACCOUNT + '@active'
#        print(x)
        run(x)
    else:
        print('\n=>> Insufficient funds, bot.tbn balance : ' + bot_net_balance[0] + ' ' + bot_net_balance[1])
else:
    if price_delta < -SPREAD/2.0:
        # Check bot.tbn balance
#        bot_balance = get_currency_balance('bot.tbn', TKN_CONTRACT, TKN_SYMBOL)
        print('\nbot.tbn balance      : ' + bot_token_balance[0] + ' ' + bot_token_balance[1])
        if  float(bot_token_balance[0]) > 5.0:
            print('\n=>> Sell 5.00 EZAR')
            stop_loss = round(0.98 * 5.0 / bancor_price, 6)
            x = 'cleos --url ' + API + ' push action stablecoin.z transfer \'["' + ACCOUNT + '","bancor.tbn","5.00 EZAR","1,zar.tbn TLOS,' + str(stop_loss) + ',' + ACCOUNT + '"]\' -p ' + ACCOUNT + '@active'
#            print(x)
            run(x)
        else:
            print('\n=>> Insufficient funds, bot.tbn balance : ' + bot_token_balance[0] + ' ' + bot_token_balance[1])
    else:
        print('\n=>> No action')

print('')
run('cleos wallet lock -n bancor')
