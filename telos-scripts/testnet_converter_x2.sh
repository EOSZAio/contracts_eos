#!/usr/bin/env bash
#=================================================================================#
# Config Constants

clear

# BNT  0.410124 20000.00000000
# TLOS 0.086637 94676.4085
# ZAR  0.687    11939.56
# KSH  0.0097   845616.49


# ./test_converter_x2.sh btc 00000000 EBTC
# Converter code : " btc
# Token symbol   : " EBTC
# Presision      : " 00000000

CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'

API="--url https://basho.telos.caleos.io"

echo
echo -e "${CYAN}------------------------PREPARE PARAMETERS-----------------------${NC}"
read -p "Converter 1 code  : " CONVERTER_CODE1
read -p "Token 1 symbol    : " SYMBOL1
read -p "Presision 1       : " PRESISION1

read -p "Converter 2 code  : " CONVERTER_CODE2
read -p "Token 2 symbol    : " SYMBOL2
read -p "Presision 2       : " PRESISION2

TOKEN=stablecoin.z
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS

CONVERTER1="${CONVERTER_CODE1}.tbn"
RELAY1="${CONVERTER_CODE1}relay.tbn"

CONVERTER2="${CONVERTER_CODE2}.tbn"
RELAY2="${CONVERTER_CODE2}relay.tbn"

echo
read -p "${SYMBOL1} amount      : " TOKEN_AMOUNT1
read -p "${SYMBOL2} amount      : " TOKEN_AMOUNT2

echo
echo "Token         : ${TOKEN}"
echo "Symbol 1      : ${SYMBOL1}"
echo "Presision 1   : ${PRESISION1}"
echo "Converter 1   : ${CONVERTER1}"

echo "Symbol 2      : ${SYMBOL2}"
echo "Presision 2   : ${PRESISION2}"
echo "Converter 2   : ${CONVERTER2}"

echo
read -p "Continue?"

# CHANGE PATH
EOSIO_CONTRACTS_ROOT=~/eosio.contracts/build/contracts
MY_CONTRACTS_BUILD=~/bancor/contracts/eos

echo
echo -e "${CYAN}----------------------------${SYMBOL1}=>${SYMBOL2}-----------------------------${NC}"
#cleos $API get account $NETWORK
#cleos $API get account $CONVERTER1
#cleos $API get account $CONVERTER2
#cleos $API get account admin.tbn
cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT1}' '${SYMBOL1}'","1,'${CONVERTER1}' TLOS '${CONVERTER2}' '${SYMBOL2}',0.0,admin.tbn"]' -p admin.tbn@active

echo
echo -e "${CYAN}----------------------------${SYMBOL2}=>${SYMBOL1}-----------------------------${NC}"
cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT2}' '${SYMBOL2}'","1,'${CONVERTER2}' TLOS '${CONVERTER1}' '${SYMBOL1}',0.0,admin.tbn"]' -p admin.tbn@active

#echo
#sleep 1
#echo -e "${CYAN}----------------------------${SYMBOL}=>TLOS-----------------------------${NC}"
#cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT2}' '${SYMBOL2}'","1,'${CONVERTER2}' TLOS '${CONVERTER1}' '${SYMBOL1}' '${CONVERTER1}' TLOS,0.0,admin.tbn"]' -p admin.tbn@active

echo
echo -e "${GREEN}--> Done${NC}"
