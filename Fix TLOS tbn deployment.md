```bash
cleos wallet unlock -n rory

CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'
```
### Testent
```bash
API="--url https://testnet.telos.africa:4443"
OWNER="EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv" 
ACTIVE="EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv"
```
### Mainnet
```bash
API="--url https://history.telos.africa:4443"
OWNER="EOS5oNHb9qY6seSxbNGT3LnRt5EjU97tWmx1GCg73sxc43fR9HPWX"
ACTIVE="EOS7VbFsbEHiYjB5rYzP2kmVQ8ZjD8m5AapENpqWehCQV4iaCd7cm"
```

## EZAR
```bash
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=stablecoin.z
CONVERTER_CODE=zar
SYMBOL=EZAR
PRESISION="00"

TLOS_LIQUIDITY=1000.0000
TOKEN_LIQUIDITY=1463.12
SMART_LIQUIDITY=25000.00000000
FEE=2000
```

## EKSH
```bash
NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=stablecoin.z
CONVERTER_CODE=ksh
SYMBOL=EKSH
PRESISION="00"

TLOS_LIQUIDITY=1000.0000
TOKEN_LIQUIDITY=10106.08
SMART_LIQUIDITY=25000.00000000
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

cleos $API get info

echo -e "${CYAN}-----------------------------FUNDING-----------------------------${NC}"
cleos $API system claimrewards southafrica1 -p southafrica1@active
cleos $API push action eosio.token transfer '[ "southafrica1", "admin.tbn", "1000.0000 TLOS", "Fund Bancor" ]' -p southafrica1@active
cleos $API push action eosio.token transfer '[ "southafrica1", "tbn", "1000.0000 TLOS", "Fund Bancor" ]' -p southafrica1@active

# Update Bancor Network
echo -e "${CYAN}-----------------------------NETWORK-----------------------------${NC}"
cleos $API set contract $NETWORK $MY_CONTRACTS_BUILD/BancorNetwork -p ${NETWORK}@active

# EZAR converter

echo
echo -e "${CYAN}----------------------------CONVERTER----------------------------${NC}"
cleos $API system newaccount tbn $CONVERTER $ACTIVE --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 600 --transfer -p tbn@active
cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set account permission $CONVERTER active '{ "threshold": 1, "keys": [{ "key": "'${ACTIVE}'", "weight": 1 }], "accounts": [{ "permission": { "actor":"'${CONVERTER}'","permission":"eosio.code" }, "weight":1 }] }' owner -p $CONVERTER@active

echo
echo -e "${CYAN}------------------------------RELAY------------------------------${NC}"
cleos $API system newaccount tbn $RELAY $ACTIVE --stake-cpu "50 TLOS" --stake-net "10 TLOS" --buy-ram-kbytes 300 --transfer -p tbn@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
cleos $API set account permission $RELAY active '{ "threshold": 1, "keys": [{ "key": "'${ACTIVE}'", "weight": 1 }], "accounts": [{ "permission": { "actor":"'${CONVERTER}'","permission":"eosio.code" }, "weight":1 }] }' owner -p $RELAY@active

echo -e "${CYAN}---------------------------ISSUE TOKENS--------------------------${NC}"
#    create and issue $SYMBOL token
#$COMMAND push action $TOKEN create '["'${ISSUER}'", "'${MAX_SUPPLY}'.'${PRESISION}' '${SYMBOL}'"]' -p $TOKEN@active
cleos $API push action $TOKEN issue  '["'${ISSUER}'", "1000000.'${PRESISION}' '${SYMBOL}'", "setup"]' -p $ISSUER@active

#    create and issue relay token - $SMART_TOKEN
cleos $API push action $RELAY create '["'${CONVERTER}'", "250000000.00000000 '${SMART_TOKEN}'"]' -p $RELAY@active
cleos $API push action $RELAY issue  '["'${CONVERTER}'", "'${SMART_LIQUIDITY}' '${SMART_TOKEN}'", "setup"]' -p $CONVERTER@active

echo -e "${CYAN}--------------setup converters and transfer tokens---------------${NC}"
#    initialize the converters
cleos $API push action $CONVERTER init '["'${RELAY}'", "0.00000000 '${SMART_TOKEN}'", 0, 1, "'${NETWORK}'", 0, 30000, '${FEE}']' -p $CONVERTER@active

#    set reserves EZAR and TLOS for zar.tbn converter
cleos $API push action $CONVERTER setreserve '["eosio.token", "0.0000 TLOS", 500000, 1]' -p $CONVERTER@active
cleos $API push action $CONVERTER setreserve '["'${TOKEN}'", "0.'${PRESISION}' '${SYMBOL}'", 500000, 1]' -p $CONVERTER@active

```

### Liquidity
```bash
echo -e "${CYAN}-------------transfer $SYMBOL to admin.tbn and converter------------${NC}"
cleos $API push action $TOKEN transfer '["'${ISSUER}'","admin.tbn","1000.'${PRESISION}' '${SYMBOL}'","setup"]' -p $ISSUER@active
cleos $API push action $TOKEN transfer '["'${ISSUER}'","'${CONVERTER}'","'${TOKEN_LIQUIDITY}' '${SYMBOL}'","setup"]' -p $ISSUER@active

echo -e "${CYAN}------------transfer TLOS to admin.tbn and converter-------------${NC}"
#cleos $API push action eosio.token transfer '["eosio","admin.tbn","200000.0000 TLOS","setup"]' -p eosio@active
cleos $API push action eosio.token transfer '["admin.tbn","'${CONVERTER}'","'${TLOS_LIQUIDITY}' TLOS","setup"]' -p admin.tbn@active

echo -e "${CYAN}-------------------transfer ${SMART_TOKEN} to admin.tbn------------------${NC}"
cleos $API push action $RELAY transfer '["'${CONVERTER}'","admin.tbn","'${SMART_LIQUIDITY}' '${SMART_TOKEN}'","setup"]' -p $CONVERTER@active
```

### Test converter
```bash
SMART_AMOUNT=1.00000000
TLOS_AMOUNT=1.0000
TOKEN_AMOUNT=10.11

echo -e "${CYAN}---------------------------${SMART_TOKEN}=>TLOS---------------------------${NC}"
cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' TLOS,0.00000010,admin.tbn"]' -p admin.tbn@active

echo -e "${CYAN}---------------------------'${SMART_TOKEN}'=>${SYMBOL}---------------------------${NC}"
cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' '${SYMBOL}',0.00000010,admin.tbn"]' -p admin.tbn@active

echo -e "${CYAN}----------------------------TLOS=>${SYMBOL}-----------------------------${NC}"
cleos $API push action eosio.token transfer '["admin.tbn","'${NETWORK}'","'${TLOS_AMOUNT}' TLOS","1,'${CONVERTER}' '${SYMBOL}',0.0,admin.tbn"]' -p admin.tbn@active

echo -e "${CYAN}----------------------------${SYMBOL}=>TLOS-----------------------------${NC}"
cleos $API push action stablecoin.z transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT}' '${SYMBOL}'","1,'${CONVERTER}' TLOS,0.0,admin.tbn"]' -p admin.tbn@active
```

### Double hops
```bash
TOKEN_AMOUNT1=1.46
CONVERTER_CODE1=zar
SYMBOL1=EZAR

TOKEN_AMOUNT2=10.11
CONVERTER_CODE2=ksh
SYMBOL2=EKSH

CONVERTER1="${CONVERTER_CODE1}.tbn"
CONVERTER2="${CONVERTER_CODE2}.tbn"

echo -e "${CYAN}----------------------------${SYMBOL1}=>${SYMBOL2}-----------------------------${NC}"
cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT1}' '${SYMBOL1}'","1,'${CONVERTER1}' TLOS '${CONVERTER2}' '${SYMBOL2}',0.0,admin.tbn"]' -p admin.tbn@active

echo -e "${CYAN}----------------------------${SYMBOL2}=>${SYMBOL1}-----------------------------${NC}"
cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT2}' '${SYMBOL2}'","1,'${CONVERTER2}' TLOS '${CONVERTER1}' '${SYMBOL1}',0.0,admin.tbn"]' -p admin.tbn@active
```

### Verify account balances
```bash
echo -e "${CYAN}----------------------Verify account token balances----------------------${NC}"
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

```bash
cleos $API get table zar.tbn zar.tbn settings
cleos $API get table zar.tbn zar.tbn reserves

```