
```bash
CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'

```

## Config

### Mainnet
```bash
#API="--url https://api.telos.africa:4443"
#API="--url https://telos.caleos.io"
API="--url https://api.telosuk.io"
OWNER="EOS5oNHb9qY6seSxbNGT3LnRt5EjU97tWmx1GCg73sxc43fR9HPWX"
ACTIVE="EOS7VbFsbEHiYjB5rYzP2kmVQ8ZjD8m5AapENpqWehCQV4iaCd7cm"
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
FEE=2000

EOSIO_CONTRACTS_ROOT=~/eosio.contracts/build/contracts
MY_CONTRACTS_BUILD=~/bancor/contracts/eos

CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"
OLD_SMART_TOKEN=${NETWORK_TOKEN}$(echo $CONVERTER_CODE | tr '[a-z]' '[A-Z]')
SMART_TOKEN=TLSDAC
ISSUER="${CONVERTER_CODE}tknissuer"

echo $CONVERTER
echo $RELAY
echo $SMART_TOKEN
echo $SMART_LIQUIDITY
```

### Disable converter and change smart token
```bash
# Hack converter & compile
cd ~/bancor
./scripts/compile.sh

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active

# Hack update
cleos $API push action $CONVERTER update '[ "0.00000000 '${SMART_TOKEN}'", 0, 0, 0, '${FEE}']' -p $CONVERTER@active

# Return tokens
cleos $API push action $RELAY transfer '["admin.tbn","'${CONVERTER}'","24999.00000000 TLOSDAC","dac.tbn recovery"]' -p admin.tbn@active
cleos $API push action $RELAY retire '[ "24999.00000000 TLOSDAC", "dac.tbn recovery" ]' -p $CONVERTER@active

cleos $API push action $RELAY close '["admin.tbn", "TLOSDAC"]' -p admin.tbn@active
cleos $API push action $RELAY close '["'${CONVERTER}'", "TLOSDAC"]' -p $CONVERTER@active

cleos $API push action eosio.token transfer '["'${CONVERTER}'","admin.tbn","224.9821 TLOS","dac.tbn recovery"]' -p $CONVERTER@active
cleos $API push action $TOKEN transfer '["'${CONVERTER}'","admin.tbn","90000.0000 TLOSDAC","dac.tbn recovery"]' -p $CONVERTER@active


# Restore converter & compile
cd ~/bancor
./scripts/compile.sh

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active

# Enable converter
cleos $API push action $CONVERTER update '[ 0, 1, 0, '${FEE}']' -p $CONVERTER@active

cleos $API push action $RELAY create '["'${CONVERTER}'", "250000000.00000000 '${SMART_TOKEN}'"]' -p $RELAY@active
cleos $API push action $RELAY issue  '["'${CONVERTER}'", "'${SMART_LIQUIDITY}' '${SMART_TOKEN}'", "setup"]' -p $CONVERTER@active

cleos $API push action $TOKEN transfer '["admin.tbn","'${CONVERTER}'","'${TOKEN_LIQUIDITY}' '${SYMBOL}'","setup"]' -p admin.tbn@active
cleos $API push action eosio.token transfer '["admin.tbn","'${CONVERTER}'","'${TLOS_LIQUIDITY}' TLOS","setup"]' -p admin.tbn@active

cleos $API push action $RELAY transfer '["'${CONVERTER}'","admin.tbn","'${SMART_LIQUIDITY}' '${SMART_TOKEN}'","setup"]' -p $CONVERTER@active

SMART_AMOUNT=1.00000000
TLOS_AMOUNT=1.0000
TOKEN_AMOUNT=396.6385

# Test
cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' TLOS,0.00000010,admin.tbn"]' -p admin.tbn@active

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' '${SYMBOL}',0.00000010,admin.tbn"]' -p admin.tbn@active

cleos $API push action eosio.token transfer '["admin.tbn","'${NETWORK}'","'${TLOS_AMOUNT}' TLOS","1,'${CONVERTER}' '${SYMBOL}',0.0,admin.tbn"]' -p admin.tbn@active

cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT}' '${SYMBOL}'","1,'${CONVERTER}' TLOS,0.0,admin.tbn"]' -p admin.tbn@active

TOKEN_AMOUNT1=5.00
CONVERTER_CODE1=zar
SYMBOL1=EZAR
TOKEN1=stablecoin.z

TOKEN_AMOUNT2=1439.6772
CONVERTER_CODE2=dac
SYMBOL2=TLOSDAC
TOKEN2=telosdacdrop

CONVERTER1="${CONVERTER_CODE1}.tbn"
CONVERTER2="${CONVERTER_CODE2}.tbn"

echo -e "${CYAN}----------------------------${SYMBOL1}=>${SYMBOL2}-----------------------------${NC}"
cleos $API push action $TOKEN1 transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT1}' '${SYMBOL1}'","1,'${CONVERTER1}' TLOS '${CONVERTER2}' '${SYMBOL2}',0.0,admin.tbn"]' -p admin.tbn@active

echo -e "${CYAN}----------------------------${SYMBOL2}=>${SYMBOL1}-----------------------------${NC}"
cleos $API push action $TOKEN2 transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT2}' '${SYMBOL2}'","1,'${CONVERTER2}' TLOS '${CONVERTER1}' '${SYMBOL1}',0.0,admin.tbn"]' -p admin.tbn@active

```

### Verify account balances
```bash
ACCOUNT=admin.tbn
echo -e "${GREEN}${ACCOUNT}${NC}"
cleos $API get currency balance eosio.token $ACCOUNT TLOS
cleos $API get currency balance $TOKEN $ACCOUNT $SYMBOL
cleos $API get currency balance $RELAY $ACCOUNT $SMART_TOKEN
cleos $API get currency balance $RELAY $ACCOUNT $OLD_SMART_TOKEN

echo
ACCOUNT=$CONVERTER
echo -e "${GREEN}${ACCOUNT}${NC}"
cleos $API get currency balance eosio.token $ACCOUNT TLOS
cleos $API get currency balance $TOKEN $ACCOUNT $SYMBOL
cleos $API get currency balance $RELAY $ACCOUNT $SMART_TOKEN
cleos $API get currency balance $RELAY $ACCOUNT $OLD_SMART_TOKEN


```
