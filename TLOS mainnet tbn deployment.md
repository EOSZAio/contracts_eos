
```bash
CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'

```

## Config

### Mainnet
```bash
API="--url https://api.telos.africa"
#API="--url https://history.telos.africa:3443"
#API="--url https://telos.caleos.io"
#API="--url https://api.telosuk.io"
OWNER="EOS5oNHb9qY6seSxbNGT3LnRt5EjU97tWmx1GCg73sxc43fR9HPWX"
ACTIVE="EOS7VbFsbEHiYjB5rYzP2kmVQ8ZjD8m5AapENpqWehCQV4iaCd7cm"
```

## Converters

### EZAR
```bash
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=stablecoin.z
CONVERTER_CODE=zar
SYMBOL=EZAR
PRESISION="00"

TLOS_LIQUIDITY=1000.0000
TOKEN_LIQUIDITY=1283.66
SMART_LIQUIDITY=25000.00000000
FEE=2500
```

### QBE
```bash
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=qubicletoken
CONVERTER_CODE=qbe
SYMBOL=QBE
PRESISION="0000"

TLOS_LIQUIDITY=579.6295
TOKEN_LIQUIDITY=12500.0000
SMART_LIQUIDITY=25000.00000000
FEE=2500

# Fund converter
cleos $API push action qubicletoken transfer '[ "rorymapstone", "admin.tbn", "18000.0000 QBE", "Fund Bancor" ]' -p rorymapstone@active

```

### TLOSDAC
```bash
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=telosdacdrop
CONVERTER_CODE=dac
SYMBOL=TLOSDAC
PRESISION="0000"

TLOS_LIQUIDITY=225.0000
TOKEN_LIQUIDITY=90000.0000
SMART_LIQUIDITY=25000.00000000
FEE=2500

# Fund converter
cleos $API push action $TOKEN transfer '[ "rorymapstone", "admin.tbn", "90000.0000 TLOSDAC", "Fund Bancor" ]' -p rorymapstone@active
```

### HEART
```bash
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=revelation21
CONVERTER_CODE=rev
SYMBOL=HEART
PRESISION="0000"

TLOS_LIQUIDITY=10.0000
TOKEN_LIQUIDITY=10.0000
SMART_LIQUIDITY=10.00000000
FEE=2500

# Fund converter
cleos $API push action eosio.token transfer '[ "admin.tbn", "tbn", "200.0000 TLOS", "Bancor contract accounts" ]' -p admin.tbn@active
```

### DC
```bash
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=greencointls
CONVERTER_CODE=dc
SYMBOL=DC
PRESISION="000000"

TLOS_LIQUIDITY=1000.0000
TOKEN_LIQUIDITY=10.0000
SMART_LIQUIDITY=1000.00000000
FEE=12000

# Fund converter
cleos $API push action eosio.token transfer '[ "admin.tbn", "tbn", "200.0000 TLOS", "Bancor contract accounts" ]' -p admin.tbn@active
```

### SQRL
```bash
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=sqrlwalletio
CONVERTER_CODE=sql
SYMBOL=SQRL
PRESISION="0000"

TLOS_LIQUIDITY=250.0000
TOKEN_LIQUIDITY=50000.0000
SMART_LIQUIDITY=500.00000000
FEE=2500

# Fund converter
cleos $API push action eosio.token transfer '[ "admin.tbn", "tbn", "200.0000 TLOS", "Bancor contract accounts" ]' -p admin.tbn@active
```

### SAND
```bash
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=sandiegocoin
CONVERTER_CODE=san
SYMBOL=SAND
PRESISION="00000000"
PRESISION_COUNT=8

TLOS_LIQUIDITY=250.0000
TOKEN_LIQUIDITY=2500.00000000
SMART_LIQUIDITY=500.00000000
FEE=2500


# Fund converter
cleos $API push action eosio.token transfer '[ "admin.tbn", "tbn", "100.0000 TLOS", "Bancor contract accounts" ]' -p admin.tbn@active

# Fix error
./scripts/eos/compile.sh eosio-cpp
cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API push action $CONVERTER setreserve '["'${TOKEN}'", "'${PRESISION_COUNT}','${SYMBOL}'", 500000, 1]' -p $CONVERTER@active
./scripts/eos/compile.sh eosio-cpp
cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active

# 2499.00819102
TOKEN_LIQUIDITY=0.99180898
# 249.9008
TLOS_LIQUIDITY=0.0992
cleos $API push action $TOKEN transfer '["admin.tbn","'${CONVERTER}'","'${TOKEN_LIQUIDITY}' '${SYMBOL}'","setup"]' -p admin.tbn@active
cleos $API push action eosio.token transfer '["admin.tbn","'${CONVERTER}'","'${TLOS_LIQUIDITY}' TLOS","setup"]' -p admin.tbn@active
```

### Deployment
```bash
EOSIO_CONTRACTS_ROOT=~/eosio.contracts/build/contracts
MY_CONTRACTS_BUILD=~/bancor/contracts/eos

CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"
SMART_TOKEN=${NETWORK_TOKEN}$(echo $CONVERTER_CODE | tr '[a-z]' '[A-Z]')
ISSUER="${CONVERTER_CODE}tknissuer"

echo $CONVERTER
echo $RELAY
echo $SMART_TOKEN
echo $SMART_LIQUIDITY
```

## Verify network

```bash
cleos $API get info
```

## Fund Bancor
```bash
cleos $API push action eosio.token transfer '[ "southafrica1", "admin.tbn", "1000.0000 TLOS", "Fund Bancor" ]' -p southafrica1@active
```

## Core network accounts

### admin.tbn
```bash
# Admin account 
cleos $API system newaccount tbn admin.tbn $OWNER $ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 10 --transfer -p tbn@active
cleos $API system delegatebw tbn admin.tbn "4.9000 TLOS" "4.1000 TLOS" --transfer -p tbn@active
cleos $API get account admin.tbn
```

### funding.tbn
```bash
# Admin account 
cleos $API system newaccount tbn admin.tbn $OWNER $ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 10 --transfer -p tbn@active
cleos $API system delegatebw tbn admin.tbn "4.9000 TLOS" "4.1000 TLOS" --transfer -p tbn@active
cleos $API get account admin.tbn
```

### bancor.tbn
```bash
cleos $API system newaccount tbn $NETWORK $OWNER $ACTIVE --stake-cpu "9.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 200 --transfer -p tbn@active
cleos $API set contract $NETWORK $MY_CONTRACTS_BUILD/BancorNetwork
cleos $API set account permission $NETWORK active '{ "threshold": 1, "keys": [{ "key": "'${ACTIVE}'", "weight": 1 }], "accounts": [{ "permission": { "actor":"'${NETWORK}'","permission":"eosio.code" }, "weight":1 }] }' owner -p $NETWORK@active
```

## Converter
```bash
cleos $API system newaccount tbn $CONVERTER $OWNER  $ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 600 --transfer -p tbn@active
cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set account permission $CONVERTER active '{ "threshold": 1, "keys": [{ "key": "'${ACTIVE}'", "weight": 1 }], "accounts": [{ "permission": { "actor":"'${CONVERTER}'","permission":"eosio.code" }, "weight":1 }] }' owner -p $CONVERTER@active
```

## Relay
```bash
cleos $API system newaccount tbn $RELAY $OWNER  $ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 300 --transfer -p tbn@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
cleos $API set account permission $RELAY active '{ "threshold": 1, "keys": [{ "key": "'${ACTIVE}'", "weight": 1 }], "accounts": [{ "permission": { "actor":"'${RELAY}'","permission":"eosio.code" }, "weight":1 }] }' owner -p $RELAY@active
```

### Smart token
```bash
cleos $API push action $RELAY create '["'${CONVERTER}'", "250000000.00000000 '${SMART_TOKEN}'"]' -p $RELAY@active
cleos $API push action $RELAY issue  '["'${CONVERTER}'", "'${SMART_LIQUIDITY}' '${SMART_TOKEN}'", "setup"]' -p $CONVERTER@active
```

### Initialise converter
```bash
#    initialize the converters
cleos $API push action $CONVERTER init '["'${RELAY}'", "0.00000000 '${SMART_TOKEN}'", 0, 1, "'${NETWORK}'", 0, 30000, '${FEE}']' -p $CONVERTER@active

#    set reserves EZAR and TLOS for zar.tbn converter
cleos $API push action $CONVERTER setreserve '["eosio.token", "4,TLOS", 500000, 1]' -p $CONVERTER@active
cleos $API push action $CONVERTER setreserve '["'${TOKEN}'", "'${PRESISION_COUNT}','${SYMBOL}'", 500000, 1]' -p $CONVERTER@active
```

### Liquidity
```bash
# EZAR
cleos $API push action $TOKEN transfer '["'${ISSUER}'","admin.tbn","1500.'${PRESISION}' '${SYMBOL}'","setup"]' -p $ISSUER@active
cleos $API push action $TOKEN transfer '["admin.tbn","'${CONVERTER}'","'${TOKEN_LIQUIDITY}' '${SYMBOL}'","setup"]' -p admin.tbn@active

cleos $API push action eosio.token transfer '[ "tbn", "admin.tbn", "600.0000 TLOS", "Fund Bancor" ]' -p tbn@active
cleos $API push action eosio.token transfer '["admin.tbn","'${CONVERTER}'","'${TLOS_LIQUIDITY}' TLOS","setup"]' -p admin.tbn@active

cleos $API push action $RELAY transfer '["'${CONVERTER}'","admin.tbn","'${SMART_LIQUIDITY}' '${SMART_TOKEN}'","setup"]' -p $CONVERTER@active
```

### Verify account balances
```bash
ACCOUNT=admin.tbn
echo -e "${GREEN}${ACCOUNT}${NC}"
cleos $API get currency balance eosio.token $ACCOUNT TLOS
cleos $API get currency balance $TOKEN $ACCOUNT $SYMBOL
cleos $API get currency balance $RELAY $ACCOUNT $SMART_TOKEN

echo
ACCOUNT=$TOKEN
echo -e "${GREEN}${ACCOUNT}${NC}"
cleos $API get currency balance eosio.token $ACCOUNT TLOS
cleos $API get currency balance $TOKEN $ACCOUNT $SYMBOL
cleos $API get currency balance $RELAY $ACCOUNT $SMART_TOKEN

echo
ACCOUNT=$RELAY
echo -e "${GREEN}${ACCOUNT}${NC}"
cleos $API get currency balance eosio.token $ACCOUNT TLOS
cleos $API get currency balance $TOKEN $ACCOUNT $SYMBOL
cleos $API get currency balance $RELAY $ACCOUNT $SMART_TOKEN

echo
ACCOUNT=$CONVERTER
echo -e "${GREEN}${ACCOUNT}${NC}"
cleos $API get currency balance eosio.token $ACCOUNT TLOS
cleos $API get currency balance $TOKEN $ACCOUNT $SYMBOL
cleos $API get currency balance $RELAY $ACCOUNT $SMART_TOKEN
```

### Test converter
```bash
SMART_AMOUNT=0.10000000
TLOS_AMOUNT=0.1000
TOKEN_AMOUNT=1.00000000

# Funding to test
cleos $API push action eosio.token transfer '[ "tbn", "admin.tbn", "10.0000 TLOS", "Fund Bancor" ]' -p tbn@active

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' TLOS,0.0,admin.tbn"]' -p admin.tbn@active

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' '${SYMBOL}',0.0,admin.tbn"]' -p admin.tbn@active

cleos $API push action eosio.token transfer '["admin.tbn","'${NETWORK}'","'${TLOS_AMOUNT}' TLOS","1,'${CONVERTER}' '${SYMBOL}',0.0,admin.tbn"]' -p admin.tbn@active

cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT}' '${SYMBOL}'","1,'${CONVERTER}' TLOS,0.0,admin.tbn"]' -p admin.tbn@active

## Rebalance converters
# 249.9008 TLOS => 0.0992 TLOS
# 49980.1561 SQRL => 19.8439 SQRL
# 499.80000000 TLOSSQL => 0.20000000 TLOSSQL
SMART_LIQUIDITY=0.20000000

cleos $API push action $RELAY issue  '["'${CONVERTER}'", "'${SMART_LIQUIDITY}' '${SMART_TOKEN}'", "setup"]' -p $CONVERTER@active
cleos $API push action $RELAY transfer '["'${CONVERTER}'","admin.tbn","'${SMART_LIQUIDITY}' '${SMART_TOKEN}'","setup"]' -p $CONVERTER@active

TOKEN_LIQUIDITY=19.8439
TLOS_LIQUIDITY=0.0992
cleos $API push action $TOKEN transfer '["admin.tbn","'${CONVERTER}'","'${TOKEN_LIQUIDITY}' '${SYMBOL}'","setup"]' -p admin.tbn@active
cleos $API push action eosio.token transfer '["admin.tbn","'${CONVERTER}'","'${TLOS_LIQUIDITY}' TLOS","setup"]' -p admin.tbn@active


```

### Double hops
```bash
TOKEN_AMOUNT1=1.00
CONVERTER_CODE1=zar
SYMBOL1=EZAR
TOKEN1=stablecoin.z

TOKEN_AMOUNT2=10.00
CONVERTER_CODE2=ksh
SYMBOL2=EKSH
TOKEN2=stablecoin.z

CONVERTER1="${CONVERTER_CODE1}.tbn"
CONVERTER2="${CONVERTER_CODE2}.tbn"

echo -e "${CYAN}----------------------------${SYMBOL1}=>${SYMBOL2}-----------------------------${NC}"
cleos $API push action $TOKEN1 transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT1}' '${SYMBOL1}'","1,'${CONVERTER1}' TLOS '${CONVERTER2}' '${SYMBOL2}',0.0,admin.tbn"]' -p admin.tbn@active

echo -e "${CYAN}----------------------------${SYMBOL2}=>${SYMBOL1}-----------------------------${NC}"
cleos $API push action $TOKEN2 transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT2}' '${SYMBOL2}'","1,'${CONVERTER2}' TLOS '${CONVERTER1}' '${SYMBOL1}',0.0,admin.tbn"]' -p admin.tbn@active
```

### All converters
```bash
echo
TOKEN=stablecoin.z
CONVERTER_CODE=zar
SYMBOL=EZAR

ACCOUNT="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"
SMART_TOKEN=${NETWORK_TOKEN}$(echo $CONVERTER_CODE | tr '[a-z]' '[A-Z]')

echo -e "${GREEN}${ACCOUNT}${NC}"
cleos $API get currency balance eosio.token $ACCOUNT TLOS
cleos $API get currency balance $TOKEN $ACCOUNT $SYMBOL
cleos $API get currency balance $RELAY $ACCOUNT $SMART_TOKEN

# 992.1301 TLOS
# 1293.86 EZAR

echo
TOKEN=telosdacdrop
CONVERTER_CODE=dac
SYMBOL=TLOSDAC

ACCOUNT="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"
SMART_TOKEN=${NETWORK_TOKEN}$(echo $CONVERTER_CODE | tr '[a-z]' '[A-Z]')

echo -e "${GREEN}${ACCOUNT}${NC}"
cleos $API get currency balance eosio.token $ACCOUNT TLOS
cleos $API get currency balance $TOKEN $ACCOUNT $SYMBOL
cleos $API get currency balance $RELAY $ACCOUNT $SMART_TOKEN

# 233.7253 TLOS
# 86656.5962 TLOSDAC

echo
TOKEN=qubicletoken
CONVERTER_CODE=qbe
SYMBOL=QBE

ACCOUNT="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"
SMART_TOKEN=${NETWORK_TOKEN}$(echo $CONVERTER_CODE | tr '[a-z]' '[A-Z]')

echo -e "${GREEN}${ACCOUNT}${NC}"
cleos $API get currency balance eosio.token $ACCOUNT TLOS
cleos $API get currency balance $TOKEN $ACCOUNT $SYMBOL
cleos $API get currency balance $RELAY $ACCOUNT $SMART_TOKEN

# 577.4492 TLOS
# 12546.8545 QBE

```
