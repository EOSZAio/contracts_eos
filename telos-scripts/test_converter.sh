#!/usr/bin/env bash
#=================================================================================#
# Config Constants

clear

# BNT  0.410124 20000.00000000
# TLOS 0.086637 94676.4085
# ZAR  0.687    11939.56
# KSH  0.0097   845616.49

# ./test_converter.sh btc 00000000 EBTC
# Converter code : " btc
# Token symbol   : " EBTC
# Presision      : " 00000000

CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo
echo -e "${CYAN}------------------------PREPARE PARAMETERS-----------------------${NC}"
read -p "Converter code (${1})  : " CONVERTER_CODE
read -p "Token symbol (${3})   : " SYMBOL
read -p "Presision (${2})  : " PRESISIONSTR

PRESISION=${#PRESISIONSTR}

echo
TOKEN=stablecoin.z
NETWORK="bancor.tbn"
CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"
ISSUER="${CONVERTER_CODE}tknissuer"
NETWORK_TOKEN=TLOS
SMART_TOKEN=${NETWORK_TOKEN}$(echo $CONVERTER_CODE | tr '[a-z]' '[A-Z]')

echo
read -p "TLOS amount      : " TLOS_AMOUNT
read -p "${SYMBOL} amount      : " TOKEN_AMOUNT
read -p "${SMART_TOKEN} amount   : " SMART_AMOUNT

echo
read -p "Command (cleos)   : " COMMAND

echo
echo "Token       : ${TOKEN}"
echo "Symbol      : ${SYMBOL}"
echo "Presision   : ${PRESISION}"
echo "Converter   : ${CONVERTER}"
echo "Relay       : ${RELAY}"
echo "Issuer      : ${ISSUER}"
echo "Smart token : ${SMART_TOKEN}"
echo "Network     : ${NETWORK}"

echo
echo echo "Command     : ${COMMAND}"

echo
read -p "Continue?"
echo -e "${CYAN}-----------------------------------------------------------------${NC}"

# CHANGE PATH
EOSIO_CONTRACTS_ROOT=~/eosio.contracts/build/contracts
MY_CONTRACTS_BUILD=~/bancor/contracts/eos

NODEOS_HOST="127.0.0.1"
NODEOS_PROTOCOL="http"
NODEOS_PORT="8888"
NODEOS_LOCATION="${NODEOS_PROTOCOL}://${NODEOS_HOST}:${NODEOS_PORT}"

# temp keosd setup
WALLET_DIR=/tmp/temp-eosio-wallet
UNIX_SOCKET_ADDRESS=$WALLET_DIR/keosd.sock
WALLET_URL=unix://$UNIX_SOCKET_ADDRESS

function cleos() { command cleos --url=${NODEOS_LOCATION} --wallet-url=$WALLET_URL "$@"; echo $@; }
on_exit(){
  echo -e "${CYAN}cleaning up temporary keosd process & artifacts${NC}";
  kill -9 $TEMP_KEOSD_PID &> /dev/null
  rm -r $WALLET_DIR
}

trap my_trap INT
trap my_trap SIGINT

# start temp keosd
mkdir $WALLET_DIR
keosd --wallet-dir=$WALLET_DIR --unix-socket-path=$UNIX_SOCKET_ADDRESS &> /dev/null &
TEMP_KEOSD_PID=$!
sleep 1

# create temp wallet
$COMMAND wallet create --to-console

NET_PUB="EOS8HuvjfQeUS7tMdHPPrkTFMnEP7nr6oivvuJyNcvW9Sx5MxJSkZ"
NET_PRV="5JS9bTWMc52HWmMC8v58hdfePTxPV5dd5fcxq92xUzbfmafeeRo"

CON_PUB="EOS7pscBeDbJTNn5SNxxowmWwoM7hGj3jDmgxp5KTv7gR89Ny5ii3"
CON_PRV="5KgKxmnm8oh5WbHC4jmLARNFdkkgVdZ389rdxwGEiBdAJHkubBH"

REP_PUB="EOS833HgCT3egUJRDnW5k3BQGqXAEDmoYo6q1s7wWnovn6B9Mb1pd"
REP_PRV="5JFLPVygcZZdEno2WWWkf3fPriuxnvjtVpkThifYM5HwcKg6ndu"

USR_PUB="EOS8UAsFY4RacdaeuadicrkP66JQxPsbNyucmbT8Z4GjwFoytsK9u"
USR_PRV="5JKAjH9WH4XnZCEe8v5Wir7awV4YBTVa8KUSqWJbQR6QGtj4yce"

STABLE_PUB="EOS77s45YiM8xhq7MWxuTdERBDn3ntHG8DTtcdwNVR2Srhxg5SZk7"
STABLE_PRV="5HrFtXh3ycvp2rSrpJb6bHJimB14adD6WXuQW4LnXA5posqpfAG"

echo

# EOSIO system-related keys
echo -e "${CYAN}-----------------------SYSTEM KEYS-----------------------${NC}"
$COMMAND wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
$COMMAND wallet import --private-key 5JgqWJYVBcRhviWZB3TU1tN9ui6bGpQgrXVtYZtTG2d3yXrDtYX
$COMMAND wallet import --private-key 5JjjgrrdwijEUU2iifKF94yKduoqfAij4SKk6X5Q3HfgHMS4Ur6
$COMMAND wallet import --private-key 5HxJN9otYmhgCKEbsii5NWhKzVj2fFXu3kzLhuS75upN5isPWNL
$COMMAND wallet import --private-key 5JNHjmgWoHiG9YuvX2qvdnmToD2UcuqavjRW5Q6uHTDtp3KG3DS
$COMMAND wallet import --private-key 5JZkaop6wjGe9YY8cbGwitSuZt8CjRmGUeNMPHuxEDpYoVAjCFZ
$COMMAND wallet import --private-key 5Hroi8WiRg3by7ap3cmnTpUoqbAbHgz3hGnGQNBYFChswPRUt26
$COMMAND wallet import --private-key 5JbMN6pH5LLRT16HBKDhtFeKZqe7BEtLBpbBk5D7xSZZqngrV8o
$COMMAND wallet import --private-key 5JUoVWoLLV3Sj7jUKmfE8Qdt7Eo7dUd4PGZ2snZ81xqgnZzGKdC
$COMMAND wallet import --private-key 5Ju1ree2memrtnq8bdbhNwuowehZwZvEujVUxDhBqmyTYRvctaF
$COMMAND wallet import --private-key 5JsRjdLbvRKGDKpVLsKuQr57ksLf4B8bpQEVFb5D1rDiPievt88
$COMMAND wallet import --private-key 5J3JRDhf4JNhzzjEZAsQEgtVuqvsPPdZv4Tm6SjMRx1ZqToaray
$COMMAND wallet import --private-key $NET_PRV
$COMMAND wallet import --private-key $REP_PRV
$COMMAND wallet import --private-key $CON_PRV
$COMMAND wallet import --private-key $USR_PRV
$COMMAND wallet import --private-key $STABLE_PRV

echo
echo
sleep 1
echo -e "${CYAN}-----trying to sell relays with 'smart_enabled' set to true-------${NC}"
echo -e "${CYAN}----------------------should not throw (TLOS)---------------------${NC}"
echo
echo -e "${CYAN}---------------------------${SMART_TOKEN}=>TLOS---------------------------${NC}"

$COMMAND push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' TLOS,0.00000010,admin.tbn"]' -p admin.tbn@active

echo
sleep 1
echo -e "${CYAN}---------------------------'${SMART_TOKEN}'=>${SYMBOL}---------------------------${NC}"
$COMMAND push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' '${SYMBOL}',0.00000010,admin.tbn"]' -p admin.tbn@active

echo
sleep 1
echo -e "${CYAN}----------------------------TLOS=>${SYMBOL}-----------------------------${NC}"
$COMMAND push action eosio.token transfer '["admin.tbn","'${NETWORK}'","'${TLOS_AMOUNT}' TLOS","1,'${CONVERTER}' '${SYMBOL}',0.0,admin.tbn"]' -p admin.tbn@active

echo
sleep 1
echo -e "${CYAN}----------------------------${SYMBOL}=>TLOS-----------------------------${NC}"
$COMMAND push action stablecoin.z transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT}' '${SYMBOL}'","1,'${CONVERTER}' TLOS,0.0,admin.tbn"]' -p admin.tbn@active

echo

on_exit
echo -e "${GREEN}--> Done${NC}"
