#!/usr/bin/env bash

# Usage: ./test.sh

# Assumptions: nodeos already running somewhere,
# wallet created, ENV vars set for wallet name and password
# contracts already compiled (with abi's generated),
# located in their respective directories, placed into user's root home folder

# Create wallet with command:
#   cleos wallet create -n testwallet --to-console
#   [NOTE] record your password somewhere
#   Password : PW5JdKqyPfeHDUurSiXoBtrF1LdCBeNTWFpsshpw7bpkqrniZ3uqE

# Set ENV vars:
#   export WALLET="testwallet"
#   export PASSWORD="{your password here}"
#   export PASSWORD="PW5JdKqyPfeHDUurSiXoBtrF1LdCBeNTWFpsshpw7bpkqrniZ3uqE"

# In a separate terminal window, run nodeos locally with this exact command:
#   nodeos -e -p eosio --max-transaction-time=1000 --http-validate-host=false --delete-all-blocks --contracts-console --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --plugin eosio::producer_plugin --plugin eosio::http_plugin

# https://github.com/EOSIO/eos/issues/7180
# curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq

# https://local.bloks.io/?nodeUrl=127.0.0.1:8888&coreSymbol=TLOS&systemDomain=eosio

#=================================================================================#
# Config Constants

./restart.sh

clear

# BNT  0.410124 20000.00000000
# TLOS 0.086637 94676.4085
# ZAR  0.687    11939.56
# KSH  0.0097   845616.49

echo
sleep 1

CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'

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

echo

# EOSIO system-related keys
echo -e "${CYAN}-----------------------SYSTEM KEYS-----------------------${NC}"
cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
cleos wallet import --private-key 5JgqWJYVBcRhviWZB3TU1tN9ui6bGpQgrXVtYZtTG2d3yXrDtYX
cleos wallet import --private-key 5JjjgrrdwijEUU2iifKF94yKduoqfAij4SKk6X5Q3HfgHMS4Ur6
cleos wallet import --private-key 5HxJN9otYmhgCKEbsii5NWhKzVj2fFXu3kzLhuS75upN5isPWNL
cleos wallet import --private-key 5JNHjmgWoHiG9YuvX2qvdnmToD2UcuqavjRW5Q6uHTDtp3KG3DS
cleos wallet import --private-key 5JZkaop6wjGe9YY8cbGwitSuZt8CjRmGUeNMPHuxEDpYoVAjCFZ
cleos wallet import --private-key 5Hroi8WiRg3by7ap3cmnTpUoqbAbHgz3hGnGQNBYFChswPRUt26
cleos wallet import --private-key 5JbMN6pH5LLRT16HBKDhtFeKZqe7BEtLBpbBk5D7xSZZqngrV8o
cleos wallet import --private-key 5JUoVWoLLV3Sj7jUKmfE8Qdt7Eo7dUd4PGZ2snZ81xqgnZzGKdC
cleos wallet import --private-key 5Ju1ree2memrtnq8bdbhNwuowehZwZvEujVUxDhBqmyTYRvctaF
cleos wallet import --private-key 5JsRjdLbvRKGDKpVLsKuQr57ksLf4B8bpQEVFb5D1rDiPievt88

echo
sleep 1

# Create system accounts
echo -e "${CYAN}-----------------------SYSTEM ACCOUNTS-----------------------${NC}"
cleos create account eosio eosio.bpay EOS7gFoz5EB6tM2HxdV9oBjHowtFipigMVtrSZxrJV3X6Ph4jdPg3
cleos create account eosio eosio.msig EOS6QRncHGrDCPKRzPYSiWZaAw7QchdKCMLWgyjLd1s2v8tiYmb45
cleos create account eosio eosio.names EOS7ygRX6zD1sx8c55WxiQZLfoitYk2u8aHrzUxu6vfWn9a51iDJt
cleos create account eosio eosio.ram EOS5tY6zv1vXoqF36gUg5CG7GxWbajnwPtimTnq6h5iptPXwVhnLC
cleos create account eosio eosio.ramfee EOS6a7idZWj1h4PezYks61sf1RJjQJzrc8s4aUbe3YJ3xkdiXKBhF
cleos create account eosio eosio.saving EOS8ioLmKrCyy5VyZqMNdimSpPjVF2tKbT5WKhE67vbVPcsRXtj5z
cleos create account eosio eosio.stake EOS5an8bvYFHZBmiCAzAtVSiEiixbJhLY8Uy5Z7cpf3S9UoqA3bJb
cleos create account eosio eosio.token EOS7JPVyejkbQHzE9Z4HwewNzGss11GB21NPkwTX2MQFmruYFqGXm
cleos create account eosio eosio.vpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.rex EOS5tjK2jP9jAd4zUe7DG1SCFGQW95W2KbXcYxg3JSu8ERjyZ6VRf

echo
sleep 1

# Bootstrap new system contracts
echo -e "${CYAN}-----------------------SYSTEM CONTRACTS-----------------------${NC}"
cleos set contract eosio.token $EOSIO_CONTRACTS_ROOT/eosio.token/
cleos set contract eosio.msig $EOSIO_CONTRACTS_ROOT/eosio.msig/
cleos push action eosio.token create '[ "eosio", "100000000000.0000 TLOS" ]' -p eosio.token
cleos push action eosio.token create '[ "eosio", "100000000000.0000 SYS" ]' -p eosio.token
echo -e "      TLOS TOKEN CREATED"
cleos push action eosio.token issue '[ "eosio", "10000000000.0000 TLOS", "memo" ]' -p eosio
cleos push action eosio.token issue '[ "eosio", "10000000000.0000 SYS", "memo" ]' -p eosio
echo -e "      TLOS TOKEN ISSUED"
cleos set contract eosio $EOSIO_CONTRACTS_ROOT/eosio.bios/
echo -e "      BIOS SET"
cleos set contract eosio $EOSIO_CONTRACTS_ROOT/eosio.system/
echo -e "      SYSTEM SET"
cleos push action eosio setpriv '["eosio.msig", 1]' -p eosio@active
cleos push action eosio init '[0, "4,TLOS"]' -p eosio@active

echo
sleep 1

# Deploy eosio.wrap
echo -e "${CYAN}-----------------------EOSIO WRAP-----------------------${NC}"
cleos wallet import --private-key 5J3JRDhf4JNhzzjEZAsQEgtVuqvsPPdZv4Tm6SjMRx1ZqToaray
cleos system newaccount eosio eosio.wrap EOS7LpGN1Qz5AbCJmsHzhG7sWEGd9mwhTXWmrYXqxhTknY2fvHQ1A --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 50 --transfer
cleos push action eosio setpriv '["eosio.wrap", 1]' -p eosio@active
cleos set contract eosio.wrap $EOSIO_CONTRACTS_ROOT/eosio.wrap/

echo
sleep 1

# 1) Import user keys

echo -e "${CYAN}-----------------------CONTRACT / USER KEYS-----------------------${NC}"
cleos wallet import --private-key $NET_PRV
cleos wallet import --private-key $REP_PRV
cleos wallet import --private-key $CON_PRV
cleos wallet import --private-key $USR_PRV

echo
sleep 1

# 2) Create accounts

#cleos system newaccount eosio reporter1 $REP_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
#cleos system newaccount eosio reporter2 $REP_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
#cleos system newaccount eosio reporter3 $REP_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
#cleos system newaccount eosio reporter4 $REP_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer

#cleos system newaccount eosio bancorxoneos $BNT_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 500 --transfer
cleos system newaccount eosio bancor.tbn  $NET_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 200 --transfer
#cleos system newaccount eosio bntbntbntbnt $BNT_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 300 --transfer
#cleos system newaccount eosio bntxrerouter $BNT_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 100 --transfer

cleos system newaccount eosio zar.tbn      $CON_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 600 --transfer
cleos system newaccount eosio zarrelay.tbn $CON_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 300 --transfer

#cleos system newaccount eosio ksh.tbn      $CON_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 600 --transfer
#cleos system newaccount eosio kshrelay.tbn $CON_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 300 --transfer

#cleos system newaccount eosio btc.tbn      $CON_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 600 --transfer
#cleos system newaccount eosio btcrelay.tbn $CON_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 300 --transfer

cleos system newaccount eosio admin.tbn    $USR_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
#cleos system newaccount eosio bnttestuser2 $USR_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
#cleos system newaccount eosio fakeos $USR_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 200 --transfer

echo
sleep 1
echo -e "${CYAN}==================================================================${NC}"
echo -e "${CYAN}---------------------------TELOS TOKENS---------------------------${NC}"

STABLE_PUB="EOS77s45YiM8xhq7MWxuTdERBDn3ntHG8DTtcdwNVR2Srhxg5SZk7"
STABLE_PRV="5HrFtXh3ycvp2rSrpJb6bHJimB14adD6WXuQW4LnXA5posqpfAG"

cleos wallet import --private-key $STABLE_PRV

cleos system newaccount eosio stablecoin.z $STABLE_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 300 --transfer
cleos system newaccount eosio zartknissuer $STABLE_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
#cleos system newaccount eosio kshtknissuer $STABLE_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer
#cleos system newaccount eosio btctknissuer $STABLE_PUB --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 10 --transfer

echo
echo -e "${CYAN}-----------------------DEPLOYING CONTRACTS-----------------------${NC}"
#cleos set contract fakeos $EOSIO_CONTRACTS_ROOT/eosio.token/

#cleos set contract bntxrerouter $MY_CONTRACTS_BUILD/XTransferRerouter
cleos set contract bancor.tbn $MY_CONTRACTS_BUILD/BancorNetwork
#cleos set contract bancorxoneos $MY_CONTRACTS_BUILD/BancorX
cleos set contract stablecoin.z $MY_CONTRACTS_BUILD/Token

cleos set contract zar.tbn $MY_CONTRACTS_BUILD/BancorConverter
#cleos set contract ksh.tbn $MY_CONTRACTS_BUILD/BancorConverter
#cleos set contract btc.tbn $MY_CONTRACTS_BUILD/BancorConverter
cleos set contract zarrelay.tbn $MY_CONTRACTS_BUILD/Token
#cleos set contract kshrelay.tbn $MY_CONTRACTS_BUILD/Token
#cleos set contract btcrelay.tbn $MY_CONTRACTS_BUILD/Token

echo
echo -e "${CYAN}-------------------------SET PERMISSIONS-------------------------${NC}"

#cleos set account permission bntxrerouter active '{ "threshold": 1, "keys": [{ "key": "EOS8HuvjfQeUS7tMdHPPrkTFMnEP7nr6oivvuJyNcvW9Sx5MxJSkZ", "weight": 1 }], "accounts": [{ "permission": { "actor":"bntxrerouter","permission":"eosio.code" }, "weight":1 }] }' owner -p bntxrerouter
cleos set account permission bancor.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS8HuvjfQeUS7tMdHPPrkTFMnEP7nr6oivvuJyNcvW9Sx5MxJSkZ", "weight": 1 }], "accounts": [{ "permission": { "actor":"bancor.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p bancor.tbn
#cleos set account permission bancorxoneos active '{ "threshold": 1, "keys": [{ "key": "EOS8HuvjfQeUS7tMdHPPrkTFMnEP7nr6oivvuJyNcvW9Sx5MxJSkZ", "weight": 1 }], "accounts": [{ "permission": { "actor":"bancorxoneos","permission":"eosio.code" }, "weight":1 }] }' owner -p bancorxoneos
#cleos set account permission bntbntbntbnt active '{ "threshold": 1, "keys": [{ "key": "EOS8HuvjfQeUS7tMdHPPrkTFMnEP7nr6oivvuJyNcvW9Sx5MxJSkZ", "weight": 1 }], "accounts": [{ "permission": { "actor":"bntbntbntbnt","permission":"eosio.code" }, "weight":1 }] }' owner -p bntbntbntbnt

cleos set account permission zar.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS7pscBeDbJTNn5SNxxowmWwoM7hGj3jDmgxp5KTv7gR89Ny5ii3", "weight": 1 }], "accounts": [{ "permission": { "actor":"zar.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p zar.tbn
cleos set account permission zarrelay.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS7pscBeDbJTNn5SNxxowmWwoM7hGj3jDmgxp5KTv7gR89Ny5ii3", "weight": 1 }], "accounts": [{ "permission": { "actor":"zarrelay.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p zarrelay.tbn

#cleos set account permission ksh.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS7pscBeDbJTNn5SNxxowmWwoM7hGj3jDmgxp5KTv7gR89Ny5ii3", "weight": 1 }], "accounts": [{ "permission": { "actor":"ksh.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p ksh.tbn
#cleos set account permission kshrelay.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS7pscBeDbJTNn5SNxxowmWwoM7hGj3jDmgxp5KTv7gR89Ny5ii3", "weight": 1 }], "accounts": [{ "permission": { "actor":"kshrelay.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p kshrelay.tbn

#cleos set account permission btc.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS7pscBeDbJTNn5SNxxowmWwoM7hGj3jDmgxp5KTv7gR89Ny5ii3", "weight": 1 }], "accounts": [{ "permission": { "actor":"btc.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p btc.tbn
#cleos set account permission btcrelay.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS7pscBeDbJTNn5SNxxowmWwoM7hGj3jDmgxp5KTv7gR89Ny5ii3", "weight": 1 }], "accounts": [{ "permission": { "actor":"btcrelay.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p btcrelay.tbn

echo
echo -e "${CYAN}---------------------------ISSUE TOKENS--------------------------${NC}"

#    create and issue EZAR token
cleos push action stablecoin.z create '["zartknissuer", "1000000000000.00 EZAR"]' -p stablecoin.z@active
cleos push action stablecoin.z issue  '["zartknissuer", "1000000.00 EZAR", "setup"]' -p zartknissuer@active

#    create and issue relay token - TLOSZAR
cleos push action zarrelay.tbn create '["zar.tbn", "250000000.00000000 TLOSZAR"]' -p zarrelay.tbn@active
cleos push action zarrelay.tbn issue  '["zar.tbn", "20100.00000000 TLOSZAR", "setup"]' -p zar.tbn@active

#    create and issue EKSH token
#cleos push action stablecoin.z create '["kshtknissuer", "1000000000000.00 EKSH"]' -p stablecoin.z@active
#cleos push action stablecoin.z issue  '["kshtknissuer", "1000000.00 EKSH", "setup"]' -p kshtknissuer@active

#    create and issue relay token - TLOSKSH
#cleos push action kshrelay.tbn create '["ksh.tbn", "250000000.00000000 TLOSKSH"]' -p kshrelay.tbn@active
#cleos push action kshrelay.tbn issue  '["ksh.tbn", "20100.00000000 TLOSKSH", "setup"]' -p ksh.tbn@active

#    create and issue BTC token
#cleos push action stablecoin.z create '["btctknissuer", "21000000.00000000 BTC"]' -p stablecoin.z@active
#cleos push action stablecoin.z issue  '["btctknissuer", "10.00000000 BTC", "setup"]' -p btctknissuer@active

#    create and issue relay token - TLOSBTC
#cleos push action bnt2btcrelay create '["bnt2btccnvrt", "250000000.00000000 TLOSBTC"]' -p bnt2btcrelay@active
#cleos push action bnt2btcrelay issue  '["bnt2btccnvrt", "30100.00000000 TLOSBTC", "setup"]' -p bnt2btccnvrt@active

echo
sleep 1
echo -e "${CYAN}--------------setup converters and transfer tokens---------------${NC}"
#    initialize the converters
cleos push action zar.tbn init '["zarrelay.tbn", "0.00000000 TLOSZAR", 0, 1, "bancor.tbn", 0, 30000, 0]' -p zar.tbn@active
#cleos push action ksh.tbn init '["bnt2kshrelay", "0.00000000 BNTEKSH", 0, 1, "bancor.tbn", 0, 30000, 0]' -p ksh.tbn@active
#cleos push action bnt2btccnvrt init '["bnt2btcrelay", "0.00000000 TLOSBTC", 0, 1, "bancor.tbn", 0, 30000, 0]' -p bnt2btccnvrt@active

#    set reserves eos and bnt for bntzar relay
cleos push action zar.tbn setreserve '["eosio.token", "4,TLOS", 500000, 1]' -p zar.tbn@active
cleos push action zar.tbn setreserve '["stablecoin.z", "2,EZAR", 500000, 1]' -p zar.tbn@active

#    set reserves eos and bnt for bntksh relay
#cleos push action ksh.tbn setreserve '["eosio.token", "4,TLOS", 500000, 1]' -p ksh.tbn@active
#cleos push action ksh.tbn setreserve '["stablecoin.z", "2,EKSH", 500000, 1]' -p ksh.tbn@active

#    set reserves eos and bnt for bntbtc relay
#cleos push action bnt2btccnvrt setreserve '["eosio.token", "4,TLOS", 500000, 1]' -p bnt2btccnvrt@active
#cleos push action bnt2btccnvrt setreserve '["stablecoin.z", "8,BTC", 500000, 1]' -p bnt2btccnvrt@active
#cleos push action bnt2btccnvrt setreserve '["stablecoin.z", "2,EZAR", 333333, 1]' -p bnt2btccnvrt@active

echo
sleep 1
echo -e "${CYAN}-------------transfer ezar to admin.tbn and converter------------${NC}"
cleos push action stablecoin.z transfer '["zartknissuer","admin.tbn","1000.00 EZAR","setup"]' -p zartknissuer@active
cleos push action stablecoin.z transfer '["zartknissuer","zar.tbn","126109.17 EZAR","setup"]' -p zartknissuer@active

#echo
#sleep 1
#echo -e "${CYAN}-----------transfer eksh to admin.tbn and converter-----------${NC}"
#cleos push action stablecoin.z transfer '["kshtknissuer","admin.tbn","100.00 EKSH","setup"]' -p kshtknissuer@active
#cleos push action stablecoin.z transfer '["kshtknissuer","ksh.tbn","845616.49 EKSH","setup"]' -p kshtknissuer@active

#echo
#sleep 1
#echo -e "${CYAN}-----------transfer btc to admin.tbn and converter------------${NC}"
#cleos push action stablecoin.z transfer '["btctknissuer","admin.tbn","1.00000000 BTC","setup"]' -p btctknissuer@active
#cleos push action stablecoin.z transfer '["btctknissuer","bnt2btccnvrt","0.78968255 BTC","setup"]' -p btctknissuer@active

#echo
#sleep 1
#echo -e "${CYAN}--------------transfer TLOS to user1 and converters---------------${NC}"
#cleos push action eosio.token issue  '["bancorxoneos", "30000.0000 TLOS", "setup"]' -p bancorxoneos@active
cleos push action eosio.token transfer '["eosio","admin.tbn","200000.0000 TLOS","setup"]' -p eosio@active

cleos push action eosio.token transfer '["admin.tbn","zar.tbn","100000.0000 TLOS","setup"]' -p admin.tbn@active
#cleos push action eosio.token transfer '["admin.tbn","ksh.tbn","10000.0000 TLOS","setup"]' -p admin.tbn@active
#cleos push action eosio.token transfer '["admin.tbn","bnt2btccnvrt","10000.0000 TLOS","setup"]' -p admin.tbn@active

echo
sleep 1
echo -e "${CYAN}---------------transfer BNTTLOS and BNTSYS to user1---------------${NC}"
cleos push action zarrelay.tbn transfer '["zar.tbn","admin.tbn","100.00000000 TLOSZAR","setup"]' -p zar.tbn@active
#cleos push action bnt2kshrelay transfer '["ksh.tbn","admin.tbn","100.00000000 TLOSKSH","setup"]' -p ksh.tbn@active
#cleos push action bnt2btcrelay transfer '["bnt2btccnvrt","admin.tbn","100.00000000 TLOSBTC", "setup"]' -p bnt2btccnvrt@active

#echo
#sleep 1
#echo -e "${CYAN}##################################################################${NC}"
#echo -e "${CYAN}-------------------transfer EZAR to bnt2btccnvrt------------------${NC}"
#cleos push action stablecoin.z transfer '["zartknissuer","bnt2btccnvrt","119395.63 EZAR","setup"]' -p zartknissuer@active

echo
sleep 1
echo -e "${CYAN}-----trying to sell relays with 'smart_enabled' set to true-------${NC}"
echo -e "${CYAN}----------------------should not throw (TLOS)---------------------${NC}"
echo -e "${CYAN}---------------------------TLOSZAR=>TLOS---------------------------${NC}"
cleos push action zarrelay.tbn transfer '["admin.tbn","bancor.tbn","1.00000000 TLOSZAR","1,zar.tbn TLOS,0.00000010,admin.tbn"]' -p admin.tbn@active
echo -e "${CYAN}---------------------------TLOSZAR=>EZAR---------------------------${NC}"
cleos push action zarrelay.tbn transfer '["admin.tbn","bancor.tbn","1.00000000 TLOSZAR","1,zar.tbn EZAR,0.00000010,admin.tbn"]' -p admin.tbn@active

#echo
#sleep 1
#echo -e "${CYAN}-----trying to buy relays with 'smart_enabled' set to true-------${NC}"
#echo -e "${CYAN}----------------------should not throw (TLOS)---------------------${NC}"
#echo -e "${CYAN}---------------------------TLOS=>TLOSZAR---------------------------${NC}"
#cleos push action eosio.token transfer '["admin.tbn","bancor.tbn","1.0000 TLOS","1,zar.tbn TLOSZAR,0.0001,admin.tbn"]' -p admin.tbn@active
#echo -e "${CYAN}---------------------------EZAR=>TLOSZAR---------------------------${NC}"
#cleos push action stablecoin.z transfer '["admin.tbn","bancor.tbn","1.00 EZAR","1,zar.tbn TLOSZAR,0.01,admin.tbn"]' -p admin.tbn@active

#echo
#sleep 1
#echo -e "${CYAN}------------------------update fee for SYS------------------------${NC}"
#cleos push action bnt2eoscnvrt update '[1, 1, 0, 10000]' -p bnt2eoscnvrt@active
#cleos push action bnt2eosrelay transfer '["admin.tbn","bancor.tbn","0.00100000 BNTTLOS","1,bnt2eoscnvrt TLOS,0.00000010,admin.tbn"]' -p admin.tbn@active

#echo
#sleep 1
#echo -e "${CYAN}------------------------update fee for SYS------------------------${NC}"
#cleos push action bnt2syscnvrt update '[1, 1, 0, 10000]' -p bnt2syscnvrt@active

#echo
#sleep 1
#echo -e "${CYAN}--------------------update bnt2eos with staking-------------------${NC}"
#cleos push action bnt2eoscnvrt update '[1, 1, 0, 0]' -p bnt2eoscnvrt@active
#cleos push action eosio.token transfer '["admin.tbn","bancor.tbn","1.0000 TLOS","1,bnt2eoscnvrt BNTTLOS,0.00000001,admin.tbn"]' -p admin.tbn@active

echo
sleep 1
echo -e "${CYAN}----------------------------TLOS=>EZAR-----------------------------${NC}"
cleos push action eosio.token transfer '["admin.tbn","bancor.tbn","1.0000 TLOS","1,zar.tbn EZAR,0.01,admin.tbn"]' -p admin.tbn@active
echo -e "${CYAN}----------------------------EZAR=>TLOS-----------------------------${NC}"
cleos push action stablecoin.z transfer '["admin.tbn","bancor.tbn","0.01 EZAR","1,zar.tbn TLOS,0.0001,admin.tbn"]' -p admin.tbn@active

#echo
#sleep 1
#echo -e "${CYAN}----------------------------TLOS=>EKSH-----------------------------${NC}"
#cleos push action eosio.token transfer '["admin.tbn","bancor.tbn","1.0000 TLOS","1,bnt2kshcnvrt EKSH,0.0001,admin.tbn"]' -p admin.tbn@active
#echo -e "${CYAN}----------------------------EKSH=>TLOS-----------------------------${NC}"
#cleos push action stablecoin.z transfer '["admin.tbn","bancor.tbn","1.00 EKSH","1,bnt2kshcnvrt TLOS,0.00000001,admin.tbn"]' -p admin.tbn@active

#echo
#sleep 1
#echo -e "${CYAN}----------------------------TLOS=>BTC------------------------------${NC}"
#cleos push action eosio.token transfer '["admin.tbn","bancor.tbn","1.0000 TLOS","1,bnt2btccnvrt BTC,0.00000001,admin.tbn"]' -p admin.tbn@active
#echo -e "${CYAN}----------------------------BTC=>TLOS------------------------------${NC}"
#cleos push action stablecoin.z transfer '["admin.tbn","bancor.tbn","0.00007896 BTC","1,bnt2btccnvrt TLOS,0.00000001,admin.tbn"]' -p admin.tbn@active
#echo -e "${CYAN}##################################################################${NC}"
#echo -e "${CYAN}---------------------------EZAR=>BTC------------------------------${NC}"
#cleos push action stablecoin.z transfer '["admin.tbn","bancor.tbn","1.00 EZAR","1,bnt2btccnvrt BTC,0.00000001,admin.tbn"]' -p admin.tbn@active
#echo -e "${CYAN}----------------------------BTC=>TLOS------------------------------${NC}"
#cleos push action stablecoin.z transfer '["admin.tbn","bancor.tbn","0.00000661 BTC","1,bnt2btccnvrt EZAR,0.00000001,admin.tbn"]' -p admin.tbn@active

#echo
#sleep 1
#echo -e "${CYAN}----------------------------EZAR=>EKSH----------------------------${NC}"
#cleos push action stablecoin.z transfer '["admin.tbn","bancor.tbn","1000.00 EZAR","1,zar.tbn TLOS bnt2kshcnvrt EKSH,0.0001,admin.tbn"]' -p admin.tbn@active

#echo -e "${CYAN}----------------------------EKSH=>EZAR-----------------------------${NC}"
#cleos push action stablecoin.z transfer '["admin.tbn","bancor.tbn","6910.34 EKSH","1,bnt2kshcnvrt TLOS zar.tbn EZAR,0.0001,admin.tbn"]' -p admin.tbn@active







echo

on_exit
echo -e "${GREEN}--> Done${NC}"
