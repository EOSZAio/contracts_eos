#!/usr/bin/env bash
#=================================================================================#
# Config Constants

clear

# BNT  0.410124 20000.00000000
# TLOS 0.086637 94676.4085
# ZAR  0.687    11939.56
# KSH  0.0097   845616.49


# ./set_converter.sh btc 21000000 00000000 EBTC
# Converter code : " btc
# Token symbol   : " EBTC
# Max supply     : " 21000000
# Presision      : " 00000000

CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo
echo -e "${CYAN}------------------------PREPARE PARAMETERS-----------------------${NC}"
read -p "Converter code (${1})  : " CONVERTER_CODE
read -p "Token symbol (${4})   : " SYMBOL
read -p "Max supply (${2}) : " MAX_SUPPLY
read -p "Presision (${3})  : " PRESISION
read -p "Fee (0)           : " FEE

echo
echo "Liquidity"
read -p "TLOS              : " TLOS_LIQUIDITY
read -p "${SYMBOL}              : " TOKEN_LIQUIDITY
read -p "Smart tokens      : " SMART_LIQUIDITY

echo
read -p "Command (cleos)   : " COMMAND

echo
TOKEN=stablecoin.z
NRTWORK="network.tbn"
CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"
ISSUER="${CONVERTER_CODE}tknissuer"
NETWORK_TOKEN=TLOS
SMART_TOKEN=${NETWORK_TOKEN}$(echo $CONVERTER_CODE | tr '[a-z]' '[A-Z]')

echo "Token       : ${TOKEN}"
echo "Symbol      : ${SYMBOL}"
echo "Max supply  : ${MAX_SUPPLY}"
echo "Presision   : ${PRESISION}"
echo "Converter   : ${CONVERTER}"
echo "Relay       : ${RELAY}"
echo "Issuer      : ${ISSUER}"
echo "Smart token : ${SMART_TOKEN}"

echo
echo "TLOS liquidity : ${TLOS_LIQUIDITY}"
echo "${SYMBOL} liquidity : ${TOKEN_LIQUIDITY}"
echo "${SMART_TOKEN} liquidity : ${SMART_LIQUIDITY}"

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
cleos wallet create --to-console

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

# EOSIO system-related keys
echo
echo -e "${CYAN}---------------------------SYSTEM KEYS---------------------------${NC}"
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
echo
echo -e "${CYAN}---------------------------BANCOR KEYS---------------------------${NC}"
$COMMAND wallet import --private-key $NET_PRV
$COMMAND wallet import --private-key $REP_PRV
$COMMAND wallet import --private-key $CON_PRV
$COMMAND wallet import --private-key $USR_PRV
echo
echo -e "${CYAN}----------------------------${2} KEYS----------------------------${NC}"
$COMMAND wallet import --private-key $STABLE_PRV

# Create bancor accounts
echo
echo -e "${CYAN}-------------------------BANCOR ACCOUNTS-------------------------${NC}"

$COMMAND system newaccount eosio $CONVERTER $CON_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 600 --transfer
$COMMAND system newaccount eosio $RELAY $CON_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 300 --transfer

$COMMAND system newaccount eosio $TOKEN $STABLE_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 300 --transfer
$COMMAND system newaccount eosio $ISSUER $STABLE_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer

echo
echo -e "${CYAN}-----------------------DEPLOYING CONTRACTS-----------------------${NC}"

$COMMAND set contract $TOKEN $MY_CONTRACTS_BUILD/Token
$COMMAND set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter
$COMMAND set contract $RELAY $MY_CONTRACTS_BUILD/Token

echo
echo -e "${CYAN}-------------------------SET PERMISSIONS-------------------------${NC}"
$COMMAND set account permission $CONVERTER active '{ "threshold": 1, "keys": [{ "key": "'${CON_PUB}'", "weight": 1 }], "accounts": [{ "permission": { "actor":"'${CONVERTER}'","permission":"eosio.code" }, "weight":1 }] }' owner -p $CONVERTER
$COMMAND set account permission $RELAY active '{ "threshold": 1, "keys": [{ "key": "'${CON_PUB}'", "weight": 1 }], "accounts": [{ "permission": { "actor":"'${RELAY}'","permission":"eosio.code" }, "weight":1 }] }' owner -p $RELAY

echo
read -p "Continue?"
echo -e "${CYAN}---------------------------ISSUE TOKENS--------------------------${NC}"
#    create and issue $SYMBOL token
$COMMAND push action $TOKEN create '["'${ISSUER}'", "'${MAX_SUPPLY}'.'${PRESISION}' '${SYMBOL}'"]' -p $TOKEN@active
$COMMAND push action $TOKEN issue  '["'${ISSUER}'", "1000000.'${PRESISION}' '${SYMBOL}'", "setup"]' -p $ISSUER@active

#    create and issue relay token - $SMART_TOKEN
$COMMAND push action $RELAY create '["'${CONVERTER}'", "250000000.00000000 '${SMART_TOKEN}'"]' -p $RELAY@active
$COMMAND push action $RELAY issue  '["'${CONVERTER}'", "'${SMART_LIQUIDITY}' '${SMART_TOKEN}'", "setup"]' -p $CONVERTER@active

echo
read -p "Continue?"
echo -e "${CYAN}--------------setup converters and transfer tokens---------------${NC}"
#    initialize the converters
$COMMAND push action $CONVERTER init '["'${RELAY}'", "0.00000000 '${SMART_TOKEN}'", 0, 1, "'${NRTWORK}'", 0, 30000, '${FEE}']' -p $CONVERTER@active

#    set reserves xxx and TLOS for bntxxx relay
$COMMAND push action $CONVERTER setreserve '["eosio.token", "0.0000 TLOS", 500000, 1]' -p $CONVERTER@active
$COMMAND push action $CONVERTER setreserve '["'${TOKEN}'", "0.'${PRESISION}' '${SYMBOL}'", 500000, 1]' -p $CONVERTER@active

echo
read -p "Continue?"
echo -e "${CYAN}-------------transfer $SYMBOL to admin.tbn and converter------------${NC}"
$COMMAND push action $TOKEN transfer '["'${ISSUER}'","admin.tbn","1000.'${PRESISION}' '${SYMBOL}'","setup"]' -p $ISSUER@active
$COMMAND push action $TOKEN transfer '["'${ISSUER}'","'${CONVERTER}'","'${TOKEN_LIQUIDITY}' '${SYMBOL}'","setup"]' -p $ISSUER@active

echo
read -p "Continue?"
echo -e "${CYAN}------------transfer TLOS to admin.tbn and converter-------------${NC}"
$COMMAND push action eosio.token transfer '["eosio","admin.tbn","200000.0000 TLOS","setup"]' -p eosio@active
$COMMAND push action eosio.token transfer '["admin.tbn","'${CONVERTER}'","'${TLOS_LIQUIDITY}' TLOS","setup"]' -p admin.tbn@active

echo
read -p "Continue?"
echo -e "${CYAN}-------------------transfer ${SMART_TOKEN} to admin.tbn------------------${NC}"
$COMMAND push action $RELAY transfer '["'${CONVERTER}'","admin.tbn","'${SMART_LIQUIDITY}' '${SMART_TOKEN}'","setup"]' -p $CONVERTER@active

echo
read -p "Continue?"
echo -e "${CYAN}----------------------Verify account token balances----------------------${NC}"
ACCOUNT=admin.tbn
echo -e "${GREEN}${ACCOUNT}${NC}"
$COMMAND get currency balance eosio.token $ACCOUNT TLOS
$COMMAND get currency balance $TOKEN $ACCOUNT $SYMBOL
$COMMAND get currency balance $RELAY $ACCOUNT $SMART_TOKEN

echo
ACCOUNT=$TOKEN
echo -e "${GREEN}${ACCOUNT}${NC}"
$COMMAND get currency balance eosio.token $ACCOUNT TLOS
$COMMAND get currency balance $TOKEN $ACCOUNT $SYMBOL
$COMMAND get currency balance $RELAY $ACCOUNT $SMART_TOKEN

echo
ACCOUNT=$RELAY
echo -e "${GREEN}${ACCOUNT}${NC}"
$COMMAND get currency balance eosio.token $ACCOUNT TLOS
$COMMAND get currency balance $TOKEN $ACCOUNT $SYMBOL
$COMMAND get currency balance $RELAY $ACCOUNT $SMART_TOKEN

echo
ACCOUNT=$CONVERTER
echo -e "${GREEN}${ACCOUNT}${NC}"
$COMMAND get currency balance eosio.token $ACCOUNT TLOS
$COMMAND get currency balance $TOKEN $ACCOUNT $SYMBOL
$COMMAND get currency balance $RELAY $ACCOUNT $SMART_TOKEN

echo
read

on_exit
echo -e "${GREEN}--> Done${NC}"
