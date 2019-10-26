
```bash
CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'
```

## Config

### Mainnet
```bash
API="--url http://testnet.telos.africa"
OWNER="EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv"
ACTIVE="EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv"
```

## Converters

### TLOSD
```bash
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=stablecarbon
CONVERTER_CODE=usd
SYMBOL=TLOSD
PRESISION="0000"

TLOS_LIQUIDITY=10000.0000
TOKEN_LIQUIDITY=1000.0000
SMART_LIQUIDITY=20000.00000000
FEE=2000
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
cleos $API system claimrewards southafrica1 -p southafrica1@active
cleos $API push action eosio.token transfer '[ "southafrica1", "tbn", "500.0000 TLOS", "Fund Bancor" ]' -p southafrica1@active
cleos $API push action eosio.token transfer '[ "southafrica1", "admin.tbn", "15000.0000 TLOS", "Fund Bancor" ]' -p southafrica1@active
```

### Setup TLOSD
```bash
cleos $API system newaccount admin.tbn stablecarbon $OWNER  $ACTIVE --stake-cpu "9.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 300 --transfer -p admin.tbn@active

cleos $API set contract stablecarbon $MY_CONTRACTS_BUILD/eosio.token -p stablecarbon@active
#cleos $API set account permission stablecarbon active '{ "threshold": 1, "keys": [{ "key": "'${ACTIVE}'", "weight": 1 }], "accounts": [{ "permission": { "actor":"stablecarbon","permission":"eosio.code" }, "weight":1 }] }' owner -p stablecarbon@active


cleos $API system newaccount admin.tbn carbonissuer $OWNER  $ACTIVE --stake-cpu "9.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 10 --transfer -p admin.tbn@active
cleos $API push action stablecarbon create '["carbonissuer", "10000000.0000 TLOSD"]' -p stablecarbon@active
cleos $API push action stablecarbon issue  '["carbonissuer", "50000.0000 TLOSD", "Test tokens"]' -p carbonissuer@active

cleos $API push action stablecarbon transfer '[ "carbonissuer", "admin.tbn", "1500.0000 TLOSD", "Fund Bancor" ]' -p carbonissuer@active
```

## Converter
```bash
cleos $API system newaccount tbn $CONVERTER $OWNER  $ACTIVE --stake-cpu "9.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 600 --transfer -p tbn@active
cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set account permission $CONVERTER active '{ "threshold": 1, "keys": [{ "key": "'${ACTIVE}'", "weight": 1 }], "accounts": [{ "permission": { "actor":"'${CONVERTER}'","permission":"eosio.code" }, "weight":1 }] }' owner -p $CONVERTER@active
```

## Relay
```bash
cleos $API system newaccount tbn $RELAY $OWNER  $ACTIVE --stake-cpu "9.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 300 --transfer -p tbn@active
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
cleos $API push action $CONVERTER setreserve '["eosio.token", "0.0000 TLOS", 500000, 1]' -p $CONVERTER@active
cleos $API push action $CONVERTER setreserve '["'${TOKEN}'", "0.'${PRESISION}' '${SYMBOL}'", 500000, 1]' -p $CONVERTER@active
```

### Liquidity
```bash
# EZAR
#cleos $API push action $TOKEN transfer '["'${ISSUER}'","admin.tbn","1500.'${PRESISION}' '${SYMBOL}'","setup"]' -p $ISSUER@active
cleos $API push action $TOKEN transfer '["admin.tbn","'${CONVERTER}'","'${TOKEN_LIQUIDITY}' '${SYMBOL}'","setup"]' -p admin.tbn@active

#cleos $API push action eosio.token transfer '[ "tbn", "admin.tbn", "600.0000 TLOS", "Fund Bancor" ]' -p tbn@active
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
SMART_AMOUNT=1.00000000
TLOS_AMOUNT=1.0000
TOKEN_AMOUNT=1.0000

# Funding to test
#cleos $API push action eosio.token transfer '[ "tbn", "admin.tbn", "10.0000 TLOS", "Fund Bancor" ]' -p tbn@active

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' TLOS,0.00000010,admin.tbn"]' -p admin.tbn@active

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' '${SYMBOL}',0.00000010,admin.tbn"]' -p admin.tbn@active

cleos $API push action eosio.token transfer '["admin.tbn","'${NETWORK}'","'${TLOS_AMOUNT}' TLOS","1,'${CONVERTER}' '${SYMBOL}',0.0,admin.tbn"]' -p admin.tbn@active

cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT}' '${SYMBOL}'","1,'${CONVERTER}' TLOS,0.0,admin.tbn"]' -p admin.tbn@active
```
