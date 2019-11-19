```bash
CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'
```

## Config

### Testnet

```bash
#API="--url https://testnet.telos.africa"
API="--url https://testnet.telosusa.io"

```

### Upgrade
```bash
# Code
#EOSIO_CONTRACTS_ROOT=~/eosio.contracts/build/contracts
MY_CONTRACTS_BUILD=~/bancor/contracts/eos

# Check
cleos $API get info

# Global stuff
NETWORK_TOKEN="TLOS"
NETWORK="bancor.tbn"

echo "== Unlock wallet =="
```

#### Update network

```bash
echo "Network token : "$NETWORK_TOKEN
echo "Network       : "$NETWORK
cleos $API set contract $NETWORK $MY_CONTRACTS_BUILD/BancorNetwork -p ${NETWORK}@active
```

#### EKSH
```bash
CONVERTER_CODE=ksh
CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active

# Update fees to 0.25%
cleos $API push action $CONVERTER update '[0, 1, 0, 2500]' -p $CONVERTER@active
```
#### TLOSD
```bash
CONVERTER_CODE=usd
CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active

# Update fees to 0.25%
cleos $API push action $CONVERTER update '[0, 1, 0, 2500]' -p $CONVERTER@active
```

#### EZAR
```bash
CONVERTER_CODE=zar
CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active

# Update fees to 0.25%
cleos $API push action $CONVERTER update '[1, 1, 0, 2500]' -p $CONVERTER@active
```

#### List of Testnet contracts
##### Before upgrade

* 5  bancor.tbn    09f819e5f7c7becc7e6eec72ddaba96b501e31d4be35022637146eaf066c144f
* 7  bnttlos.tbn   37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220
* 8  bnttoken.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220
* 39 ksh.tbn       fcf5b7e341cf6536563bad148cfc57f85a4abb084bc1d46ab19d15c53f81116f
* 40 kshrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220
* 77 tlos.tbn      fcf5b7e341cf6536563bad148cfc57f85a4abb084bc1d46ab19d15c53f81116f
* 83 usd.tbn       fcf5b7e341cf6536563bad148cfc57f85a4abb084bc1d46ab19d15c53f81116f
* 84 usdrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220
* 87 zar.tbn       fcf5b7e341cf6536563bad148cfc57f85a4abb084bc1d46ab19d15c53f81116f
* 88 zarrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220

##### New hashes

*  5 bancor.tbn    064604347eecee0361936aa41cab99f08fec06deeec06d119b01d7a06722d03f #
*  7 bnttlos.tbn   37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220 NC
*  8 bnttoken.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220 NC
* 39 ksh.tbn       4103f36ad38960cf813d4f295dc0723080ea563187fc56543c822924e17a4bf0 #
* 40 kshrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220 NC
* 77 tlos.tbn      fcf5b7e341cf6536563bad148cfc57f85a4abb084bc1d46ab19d15c53f81116f NC
* 83 usd.tbn       4103f36ad38960cf813d4f295dc0723080ea563187fc56543c822924e17a4bf0 #
* 84 usdrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220 NC
* 87 zar.tbn       4103f36ad38960cf813d4f295dc0723080ea563187fc56543c822924e17a4bf0 #
* 88 zarrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220 NC

### Test converters

#### EKSH
```bash
CONVERTER_CODE=ksh
SYMBOL=EKSH
TOKEN=stablecoin.z

SMART_AMOUNT=1.00000000
TLOS_AMOUNT=1.0000
TOKEN_AMOUNT=1.00
```

#### TLOSD
```bash
CONVERTER_CODE=usd
SYMBOL=TLOSD
TOKEN=stablecarbon

SMART_AMOUNT=1.00000000
TLOS_AMOUNT=1.0000
TOKEN_AMOUNT=1.0000
```

#### EZAR
```bash
CONVERTER_CODE=zar
SYMBOL=EZAR
TOKEN=stablecoin.z

SMART_AMOUNT=1.00000000
TLOS_AMOUNT=9.9332
TOKEN_AMOUNT=1.00
```

#### Test converter - single hop

```bash
CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"
SMART_TOKEN=${NETWORK_TOKEN}$(echo $CONVERTER_CODE | tr '[a-z]' '[A-Z]')

echo "=================================================="
echo "Smart token amount : "$SMART_AMOUNT" "$SMART_TOKEN
echo "TLOS amount        : "$TLOS_AMOUNT" TLOS"
echo $SYMBOL" token amount   : "$TOKEN_AMOUNT" "$SYMBOL
echo "Network            : "$NETWORK
echo "=================================================="
echo

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' TLOS,0.00000000,admin.tbn"]' -p admin.tbn@active

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' '${SYMBOL}',0.00000000,admin.tbn"]' -p admin.tbn@active

cleos $API push action eosio.token transfer '["admin.tbn","'${NETWORK}'","'${TLOS_AMOUNT}' TLOS","1,'${CONVERTER}' '${SYMBOL}',0.0,admin.tbn"]' -p admin.tbn@active

cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT}' '${SYMBOL}'","1,'${CONVERTER}' TLOS,0.0,admin.tbn"]' -p admin.tbn@active
```

#### Double hops

```bash
TOKEN_AMOUNT1=14.00
CONVERTER_CODE1=zar
SYMBOL1=EZAR
TOKEN1=stablecoin.z

TOKEN_AMOUNT2=1.0000
CONVERTER_CODE2=usd
SYMBOL2=TLOSD
TOKEN2=stablecarbon

CONVERTER1="${CONVERTER_CODE1}.tbn"
CONVERTER2="${CONVERTER_CODE2}.tbn"

echo -e "${CYAN}----------------------------${SYMBOL1}=>${SYMBOL2}-----------------------------${NC}"
cleos $API push action $TOKEN1 transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT1}' '${SYMBOL1}'","1,'${CONVERTER1}' TLOS '${CONVERTER2}' '${SYMBOL2}',0.0,admin.tbn"]' -p admin.tbn@active

echo -e "${CYAN}----------------------------${SYMBOL2}=>${SYMBOL1}-----------------------------${NC}"
cleos $API push action $TOKEN2 transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT2}' '${SYMBOL2}'","1,'${CONVERTER2}' TLOS '${CONVERTER1}' '${SYMBOL1}',0.0,admin.tbn"]' -p admin.tbn@active
```

#### List of Mainnet contracts
##### Before upgrade

* 12  bancor.tbn    09f819e5f7c7becc7e6eec72ddaba96b501e31d4be35022637146eaf066c144f
* 24  dac.tbn       fcf5b7e341cf6536563bad148cfc57f85a4abb084bc1d46ab19d15c53f81116f
* 25  dacrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220
* 26  dc.tbn        fcf5b7e341cf6536563bad148cfc57f85a4abb084bc1d46ab19d15c53f81116f
* 27  dcrelay.tbn   37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220
* 102 qbe.tbn       fcf5b7e341cf6536563bad148cfc57f85a4abb084bc1d46ab19d15c53f81116f
* 103 qberelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220
* 107 rev.tbn       fcf5b7e341cf6536563bad148cfc57f85a4abb084bc1d46ab19d15c53f81116f
* 109 revrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220
* 259 zar.tbn       fcf5b7e341cf6536563bad148cfc57f85a4abb084bc1d46ab19d15c53f81116f
* 260 zarrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220

##### New hashes

* 12  bancor.tbn    064604347eecee0361936aa41cab99f08fec06deeec06d119b01d7a06722d03f #
* 24  dac.tbn       596e1a7d4ded2546c5895a821ff2b39122e92bea5b8c302692bdcc6a5838b64e #
* 25  dacrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220 NC
* 26  dc.tbn        596e1a7d4ded2546c5895a821ff2b39122e92bea5b8c302692bdcc6a5838b64e #
* 27  dcrelay.tbn   37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220 NC
* 102 qbe.tbn       596e1a7d4ded2546c5895a821ff2b39122e92bea5b8c302692bdcc6a5838b64e #
* 103 qberelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220 NC
* 107 rev.tbn       596e1a7d4ded2546c5895a821ff2b39122e92bea5b8c302692bdcc6a5838b64e #
* 109 revrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220 NC
* 259 zar.tbn       596e1a7d4ded2546c5895a821ff2b39122e92bea5b8c302692bdcc6a5838b64e #
* 260 zarrelay.tbn  37f75f4f73bfce9b1450562a710cb1f327fae7a9b385c40215cf7964f4dce220 NC

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
```

### Upgrade
```bash
# Code
#EOSIO_CONTRACTS_ROOT=~/eosio.contracts/build/contracts
MY_CONTRACTS_BUILD=~/bancor/contracts/eos

# Check
cleos $API get info

# Global stuff
NETWORK_TOKEN="TLOS"
NETWORK="bancor.tbn"

echo "== Unlock wallet =="
```

#### Update network

```bash
echo "Network token : "$NETWORK_TOKEN
echo "Network       : "$NETWORK
cleos $API set contract $NETWORK $MY_CONTRACTS_BUILD/BancorNetwork -p ${NETWORK}@active
```

#### TLOSDAC
```bash
CONVERTER_CODE=dac
CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active

# Update fees to 0.25%
cleos $API push action $CONVERTER update '[0, 1, 0, 2500]' -p $CONVERTER@active
```
#### DC
```bash
CONVERTER_CODE=dc
CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active

# Update fees to 0.25%
cleos $API push action $CONVERTER update '[0, 1, 0, 2500]' -p $CONVERTER@active
```

#### QBE
```bash
CONVERTER_CODE=qbe

CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active

# Update fees to 0.25%
cleos $API push action $CONVERTER update '[0, 1, 0, 2500]' -p $CONVERTER@active
```

#### REV
```bash
CONVERTER_CODE=rev

CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active

# Update fees to 0.25%
cleos $API push action $CONVERTER update '[0, 1, 0, 2500]' -p $CONVERTER@active
```

#### ZAR
```bash
CONVERTER_CODE=zar

CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active

# Update fees to 0.25%
cleos $API push action $CONVERTER update '[0, 1, 0, 2500]' -p $CONVERTER@active
```

#### SQRL
```bash
CONVERTER_CODE=sqrl

CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}.rly.tbn"

cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active

# Update fees to 0.25%
cleos $API push action $CONVERTER update '[0, 1, 0, 2500]' -p $CONVERTER@active
```


### Test converter - single hop

#### TLOSDAC
```bash
CONVERTER_CODE=dac
SYMBOL=TLOSDAC
TOKEN=telosdacdrop

#SMART_AMOUNT=1.00000000
TLOS_AMOUNT=1.0000
TOKEN_AMOUNT=384.0902
```

#### DC (not tested)
```bash
CONVERTER_CODE=dc
SYMBOL=DC
TOKEN=greencointls

SMART_AMOUNT=1.00000000
TLOS_AMOUNT=10.0000
TOKEN_AMOUNT=0.108691

```

#### QBE
```bash
CONVERTER_CODE=qbe
SYMBOL=QBE
TOKEN=qubicletoken

SMART_AMOUNT=1.00000000
TLOS_AMOUNT=1.0000
TOKEN_AMOUNT=21.2408
```

#### HEART
```bash
CONVERTER_CODE=rev
SYMBOL=HEART
TOKEN=revelation21

SMART_AMOUNT=0.01000000
TLOS_AMOUNT=0.0100
TOKEN_AMOUNT=0.0517
```

#### EZAR
```bash
CONVERTER_CODE=zar
SYMBOL=EZAR
TOKEN=stablecoin.z

SMART_AMOUNT=1.00000000
TLOS_AMOUNT=1.0000
TOKEN_AMOUNT=1.03
```


```bash
CONVERTER="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"
SMART_TOKEN=${NETWORK_TOKEN}$(echo $CONVERTER_CODE | tr '[a-z]' '[A-Z]')

echo "=================================================="
echo "Smart token amount : "$SMART_AMOUNT" "$SMART_TOKEN
echo "TLOS amount        : "$TLOS_AMOUNT" TLOS"
echo $SYMBOL" token amount   : "$TOKEN_AMOUNT" "$SYMBOL
echo "Network            : "$NETWORK
echo "=================================================="
echo

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' TLOS,0.00000000,admin.tbn"]' -p admin.tbn@active

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' '${SYMBOL}',0.00000000,admin.tbn"]' -p admin.tbn@active

cleos $API push action eosio.token transfer '["admin.tbn","'${NETWORK}'","'${TLOS_AMOUNT}' TLOS","1,'${CONVERTER}' '${SYMBOL}',0.0,admin.tbn"]' -p admin.tbn@active

cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT}' '${SYMBOL}'","1,'${CONVERTER}' TLOS,0.0,admin.tbn"]' -p admin.tbn@active
```

## Balancing converters


#### TLOSDAC
```bash
# 90,000.0000 TLOSDAC -> 88,793.7425 TLOSDAC
# 270.0000 TLOS, 88793.7425 TLOSDAC, 540.00000000 TLSDAC, 0.0030 TLOSDAC / 1.0000 TLOS

# 24998 TLSDAC -> 540.00000000 TLSDAC
cleos $API push action dacrelay.tbn transfer '["admin.tbn","bancor.tbn","24458.00000000 TLSDAC","1,dac.tbn TLOS,0.00000000,admin.tbn"]' -p admin.tbn@active

#  88793.7425 TLOSDAC -> 90000.0000 TLOSDAC
cleos $API push action telosdacdrop transfer '["admin.tbn","dac.tbn","1206.2575 TLOSDAC","setup"]' -p admin.tbn@active

# 0.6799 TLOS -> 270.0000 TLOS, 269.3201 TLOS
cleos $API push action eosio.token transfer '["admin.tbn","dac.tbn","269.3201 TLOS","setup"]' -p admin.tbn@active

# Return surplus tokens 240.3061 TLOSDAC
cleos $API push action telosdacdrop transfer '["admin.tbn","qwertyqwerty","240.3061 TLOSDAC","Return excess tokens"]' -p admin.tbn@active

```

#### DC
```bash
# 889.6 TLOSDC -> 1000.00000000 TLOSDC
# cleos $API push action $RELAY issue  '["'${CONVERTER}'", "'${SMART_LIQUIDITY}' '${SMART_TOKEN}'", "setup"]' -p $CONVERTER@active
cleos $API push action dcrelay.tbn issue '["dc.tbn", "1110.40000000 TLOSDC", "setup"]' -p dc.tbn@active
cleos $API push action dcrelay.tbn transfer '["dc.tbn","admin.tbn","1110.40000000 TLOSDC","setup"]' -p dc.tbn@active

# 808.3992 TLOS -> 1000.0000 TLOS, 191.6008 TLOS
cleos $API push action eosio.token transfer '["admin.tbn","dc.tbn","191.6008 TLOS","setup"]' -p admin.tbn@active

# Return surplus tokens 0.004632 DC
cleos $API push action greencointls transfer '["admin.tbn","greensite555","0.004632 DC","Return test tokens"]' -p admin.tbn@active
```

#### QBE
```bash
# 12500.0000 QBE -> 12454.0035 QBE, + 5454.1400 QBE -> 17 908.1435 QBE
# 18000.0000 QBE = 270.0000 TLOS @ 0.0150 TLOS / QBE

# 24996 TLOSQBE -> 540.00000000 TLOSQBE
cleos $API push action qberelay.tbn transfer '["admin.tbn","bancor.tbn","24456.00000000 TLOSQBE","1,qbe.tbn TLOS,0.00000000,admin.tbn"]' -p admin.tbn@active

# + 5454.1400 QBE -> 17 908.1435 QBE
cleos $API push action qubicletoken transfer '["admin.tbn","qbe.tbn","5454.1400 QBE","setup"]' -p admin.tbn@active

# 1.7289 TLOS -> 270.0000 TLOS, 268.2711 TLOS
cleos $API push action eosio.token transfer '["admin.tbn","qbe.tbn","268.2711 TLOS","setup"]' -p admin.tbn@active
```

#### REV
```bash
# 
cleos $API push action rev.tbn update '[1, 1, 0, 2500]' -p rev.tbn@active

#
cleos $API push action revelation21 transfer '["admin.tbn","bancor.tbn","1.2452 HEART","1,rev.tbn TLOSREV,0.00000000,admin.tbn"]' -p admin.tbn@active
# 0.04459808
cleos $API push action revrelay.tbn transfer '["admin.tbn","bancor.tbn","0.04459808 TLOSREV","1,rev.tbn TLOS,0.00000000,admin.tbn"]' -p admin.tbn@active

# 4.3070 TLOS -> 5.0000 TLOS, 0.6930 TLOS
cleos $API push action eosio.token transfer '["admin.tbn","rev.tbn","0.6930 TLOS","setup"]' -p admin.tbn@active

```
#### EZAR
```bash
# 2500.0000 TLOS, 3125 EZAR, 5000.00000000 TLOSZAR, 1.25 EZAR / 1.0000 TLOS

# 24996 TLOSZAR -> 5000 TLOSZAR
cleos $API push action zarrelay.tbn transfer '["admin.tbn","bancor.tbn","19996.00000000 TLOSZAR","1,zar.tbn TLOS,0.00000000,admin.tbn"]' -p admin.tbn@active

#  1161.85 EZAR -> 1963.15 EZAR
cleos $API push action stablecoin.z issue '["zartknissuer","2000.00 EZAR","Issue 2000.00 EZAR, cost R2000.00, fee R0.00"]' -p zartknissuer@active
cleos $API push action stablecoin.z transfer '["zartknissuer","admin.tbn","2000.00 EZAR","Issue 2000.00 EZAR, cost R2000.00, fee R0.00"]' -p zartknissuer@active
cleos $API push action stablecoin.z transfer '["admin.tbn","zar.tbn","1963.15 EZAR","setup"]' -p admin.tbn@active

# Should transfer from reserve
cleos $API push action stablecoin.z retire '["2000.00 EZAR","Reverse issue 2000.00 EZAR, cost R2000.00, fee R0.00"]' -p zartknissuer@active
cleos $API push action stablecoin.z transfer '["admin.tbn","zartknissuer","1963.15 EZAR","refund, correct error with Telos Bancor setup"]' -p admin.tbn@active

# 47.3435 TLOS -> 2500.0000 TLOS
cleos $API push action eosio.token transfer '["admin.tbn","zar.tbn","2452.6565 TLOS","setup"]' -p admin.tbn@active

```










## Log history

```bash
Rorys-MacBook-Pro:bancor rory$ API="--url https://api.telos.africa"
Rorys-MacBook-Pro:bancor rory$ MY_CONTRACTS_BUILD=~/bancor/contracts/eos
Rorys-MacBook-Pro:bancor rory$ cleos $API get info
{
  "server_version": "7c0b0d38",
  "chain_id": "4667b205c6838ef70ff7988f6e8257e8be0e1284a2f59699054a018f743b1d11",
  "head_block_num": 56935887,
  "last_irreversible_block_num": 56935561,
  "last_irreversible_block_id": "0364c4891b8dcc0ff46ab1cf32bd097c6b8903697fba6aed091e9cd44d28f890",
  "head_block_id": "0364c5cfe2c6f471f31a76968cdc0d665f5ed6512a1462e59449c59bf38b3de9",
  "head_block_time": "2019-11-08T18:23:30.500",
  "head_block_producer": "telosmiamibp",
  "virtual_block_cpu_limit": 200000000,
  "virtual_block_net_limit": 1048576000,
  "block_cpu_limit": 199900,
  "block_net_limit": 1048576,
  "server_version_string": "v1.8.4",
  "fork_db_head_block_num": 56935887,
  "fork_db_head_block_id": "0364c5cfe2c6f471f31a76968cdc0d665f5ed6512a1462e59449c59bf38b3de9"
}
Rorys-MacBook-Pro:bancor rory$ NETWORK_TOKEN="TLOS"
Rorys-MacBook-Pro:bancor rory$ NETWORK="bancor.tbn"
Rorys-MacBook-Pro:bancor rory$ 
Rorys-MacBook-Pro:bancor rory$ echo "== Unlock wallet =="
== Unlock wallet ==
Rorys-MacBook-Pro:bancor rory$ cleos wallet unlock -n rory
password: Unlocked: rory
Rorys-MacBook-Pro:bancor rory$ echo "Network token : "$NETWORK_TOKEN
Network token : TLOS
Rorys-MacBook-Pro:bancor rory$ echo "Network       : "$NETWORK
Network       : bancor.tbn
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $NETWORK $MY_CONTRACTS_BUILD/BancorNetwork -p ${NETWORK}@active
cleos --url https://api.telos.africa set contract bancor.tbn /Users/rory/bancor/contracts/eos/BancorNetwork -p bancor.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $NETWORK $MY_CONTRACTS_BUILD/BancorNetwork -p ${NETWORK}@active
Reading WASM from /Users/rory/bancor/contracts/eos/BancorNetwork/BancorNetwork.wasm...
Publishing contract...
executed transaction: b3302ba6c51f8d7b443e3f0e7cab42108f10f98900fde305c5cb64238ab30a54  6856 bytes  1562 us
#         eosio <= eosio::setcode               {"account":"bancor.tbn","vmtype":0,"vmversion":0,"code":"0061736d010000000192011860000060027f7f00600...
#         eosio <= eosio::setabi                {"account":"bancor.tbn","abi":"0e656f73696f3a3a6162692f312e31000204696e697400000a73657474696e67735f7...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MacBook-Pro:bancor rory$ CONVERTER_CODE=dac
Rorys-MacBook-Pro:bancor rory$ CONVERTER="${CONVERTER_CODE}.tbn"
Rorys-MacBook-Pro:bancor rory$ RELAY="${CONVERTER_CODE}relay.tbn"
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos --url https://api.telos.africa set contract dac.tbn /Users/rory/bancor/contracts/eos/BancorConverter -p dac.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
Reading WASM from /Users/rory/bancor/contracts/eos/BancorConverter/BancorConverter.wasm...
Publishing contract...
executed transaction: 01e765e6db71c47076a7805352b00a2e69d291875799b3f42d848707b26e1b03  19784 bytes  20176 us
#         eosio <= eosio::setcode               {"account":"dac.tbn","vmtype":0,"vmversion":0,"code":"0061736d0100000001ac022c60000060047f7f7f7f0060...
#         eosio <= eosio::setabi                {"account":"dac.tbn","abi":"0e656f73696f3a3a6162692f312e3100060a64656c726573657276650001086375727265...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
cleos --url https://api.telos.africa set contract dacrelay.tbn /Users/rory/bancor/contracts/eos/Token -p dacrelay.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
Reading WASM from /Users/rory/bancor/contracts/eos/Token/Token.wasm...
Skipping set abi because the new abi is the same as the existing abi
Publishing contract...
executed transaction: fc7bb6d90124746126f7265bd12272071413df0bc3b862ef66b2a10b8dd85469  8664 bytes  11025 us
#         eosio <= eosio::setcode               {"account":"dacrelay.tbn","vmtype":0,"vmversion":0,"code":"0061736d0100000001ca012160000060017e00600...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MacBook-Pro:bancor rory$ CONVERTER_CODE=dc
Rorys-MacBook-Pro:bancor rory$ CONVERTER="${CONVERTER_CODE}.tbn"
Rorys-MacBook-Pro:bancor rory$ RELAY="${CONVERTER_CODE}relay.tbn"
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos --url https://api.telos.africa set contract dc.tbn /Users/rory/bancor/contracts/eos/BancorConverter -p dc.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
Reading WASM from /Users/rory/bancor/contracts/eos/BancorConverter/BancorConverter.wasm...
Publishing contract...
executed transaction: c168c92ebed4df0a1721611a3ac7b1f7421f191b211dfc63464f0fdc5dbb6270  19784 bytes  15929 us
#         eosio <= eosio::setcode               {"account":"dc.tbn","vmtype":0,"vmversion":0,"code":"0061736d0100000001ac022c60000060047f7f7f7f00600...
#         eosio <= eosio::setabi                {"account":"dc.tbn","abi":"0e656f73696f3a3a6162692f312e3100060a64656c7265736572766500010863757272656...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
cleos --url https://api.telos.africa set contract dcrelay.tbn /Users/rory/bancor/contracts/eos/Token -p dcrelay.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
Reading WASM from /Users/rory/bancor/contracts/eos/Token/Token.wasm...
Skipping set abi because the new abi is the same as the existing abi
Publishing contract...
executed transaction: 8551722c9e0347f7e9cd58347425db2713dd7345a5e16a16bcc42ee0fbb58f69  8664 bytes  10972 us
#         eosio <= eosio::setcode               {"account":"dcrelay.tbn","vmtype":0,"vmversion":0,"code":"0061736d0100000001ca012160000060017e006002...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MacBook-Pro:bancor rory$ CONVERTER_CODE=qbe
Rorys-MacBook-Pro:bancor rory$ 
Rorys-MacBook-Pro:bancor rory$ CONVERTER="${CONVERTER_CODE}.tbn"
Rorys-MacBook-Pro:bancor rory$ RELAY="${CONVERTER_CODE}relay.tbn"
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos --url https://api.telos.africa set contract qbe.tbn /Users/rory/bancor/contracts/eos/BancorConverter -p qbe.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
Reading WASM from /Users/rory/bancor/contracts/eos/BancorConverter/BancorConverter.wasm...
Publishing contract...
executed transaction: 250b2641d8e19ebbc3e35c6fa896354ca08f92653a0009f882d6688ed306ea41  19784 bytes  20711 us
#         eosio <= eosio::setcode               {"account":"qbe.tbn","vmtype":0,"vmversion":0,"code":"0061736d0100000001ac022c60000060047f7f7f7f0060...
#         eosio <= eosio::setabi                {"account":"qbe.tbn","abi":"0e656f73696f3a3a6162692f312e3100060a64656c726573657276650001086375727265...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
cleos --url https://api.telos.africa set contract qberelay.tbn /Users/rory/bancor/contracts/eos/Token -p qberelay.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
Reading WASM from /Users/rory/bancor/contracts/eos/Token/Token.wasm...
Skipping set abi because the new abi is the same as the existing abi
Publishing contract...
executed transaction: 7433864659140269db74010864b8c961532ff7380ab2a274d4ef957293e17bbd  8664 bytes  2053 us
#         eosio <= eosio::setcode               {"account":"qberelay.tbn","vmtype":0,"vmversion":0,"code":"0061736d0100000001ca012160000060017e00600...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MacBook-Pro:bancor rory$ CONVERTER_CODE=rev
Rorys-MacBook-Pro:bancor rory$ 
Rorys-MacBook-Pro:bancor rory$ CONVERTER="${CONVERTER_CODE}.tbn"
Rorys-MacBook-Pro:bancor rory$ RELAY="${CONVERTER_CODE}relay.tbn"
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos --url https://api.telos.africa set contract rev.tbn /Users/rory/bancor/contracts/eos/BancorConverter -p rev.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
Reading WASM from /Users/rory/bancor/contracts/eos/BancorConverter/BancorConverter.wasm...
Publishing contract...
executed transaction: d9069c3a6f493442973839d9cc2527b9dadc0fa1886497af801e6f966381f9a2  19792 bytes  16890 us
#         eosio <= eosio::setcode               {"account":"rev.tbn","vmtype":0,"vmversion":0,"code":"0061736d0100000001ac022c60000060047f7f7f7f0060...
#         eosio <= eosio::setabi                {"account":"rev.tbn","abi":"0e656f73696f3a3a6162692f312e3100060a64656c726573657276650001086375727265...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
cleos --url https://api.telos.africa set contract revrelay.tbn /Users/rory/bancor/contracts/eos/Token -p revrelay.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
Reading WASM from /Users/rory/bancor/contracts/eos/Token/Token.wasm...
Skipping set abi because the new abi is the same as the existing abi
Publishing contract...
executed transaction: b4732bbfaae19dc0be1410e2b00a3a4f10cd026ed3cdf8a6b574d1c8dbb59fef  8664 bytes  10236 us
#         eosio <= eosio::setcode               {"account":"revrelay.tbn","vmtype":0,"vmversion":0,"code":"0061736d0100000001ca012160000060017e00600...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MacBook-Pro:bancor rory$ CONVERTER_CODE=zar
Rorys-MacBook-Pro:bancor rory$ 
Rorys-MacBook-Pro:bancor rory$ CONVERTER="${CONVERTER_CODE}.tbn"
Rorys-MacBook-Pro:bancor rory$ RELAY="${CONVERTER_CODE}relay.tbn"
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
cleos --url https://api.telos.africa set contract zar.tbn /Users/rory/bancor/contracts/eos/BancorConverter -p zar.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $CONVERTER $MY_CONTRACTS_BUILD/BancorConverter -p ${CONVERTER}@active
Reading WASM from /Users/rory/bancor/contracts/eos/BancorConverter/BancorConverter.wasm...
Publishing contract...
executed transaction: 038ddff16156751cd0e833555afe007e1f3e489bcf14bf84b653f860c11f2183  19792 bytes  20793 us
#         eosio <= eosio::setcode               {"account":"zar.tbn","vmtype":0,"vmversion":0,"code":"0061736d0100000001ac022c60000060047f7f7f7f0060...
#         eosio <= eosio::setabi                {"account":"zar.tbn","abi":"0e656f73696f3a3a6162692f312e3100060a64656c726573657276650001086375727265...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MacBook-Pro:bancor rory$ echo cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
cleos --url https://api.telos.africa set contract zarrelay.tbn /Users/rory/bancor/contracts/eos/Token -p zarrelay.tbn@active
Rorys-MacBook-Pro:bancor rory$ cleos $API set contract $RELAY $MY_CONTRACTS_BUILD/Token -p ${RELAY}@active
Reading WASM from /Users/rory/bancor/contracts/eos/Token/Token.wasm...
Skipping set abi because the new abi is the same as the existing abi
Publishing contract...
executed transaction: 9af37f85a41fd70005f301684038ac20484961315005c33e311ac60f3cdb225e  8664 bytes  6986 us
#         eosio <= eosio::setcode               {"account":"zarrelay.tbn","vmtype":0,"vmversion":0,"code":"0061736d0100000001ca012160000060017e00600...
warning: transaction executed locally, but may not be confirmed by the network yet         ] 

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
FEE=2000
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
FEE=2000

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
FEE=2000

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
FEE=2000

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
TOKEN_AMOUNT=0.10

# Funding to test
cleos $API push action eosio.token transfer '[ "tbn", "admin.tbn", "10.0000 TLOS", "Fund Bancor" ]' -p tbn@active

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' TLOS,0.00000010,admin.tbn"]' -p admin.tbn@active

cleos $API push action $RELAY transfer '["admin.tbn","'${NETWORK}'","'${SMART_AMOUNT}' '${SMART_TOKEN}'","1,'${CONVERTER}' '${SYMBOL}',0.00000010,admin.tbn"]' -p admin.tbn@active

cleos $API push action eosio.token transfer '["admin.tbn","'${NETWORK}'","'${TLOS_AMOUNT}' TLOS","1,'${CONVERTER}' '${SYMBOL}',0.0,admin.tbn"]' -p admin.tbn@active

cleos $API push action $TOKEN transfer '["admin.tbn","'${NETWORK}'","'${TOKEN_AMOUNT}' '${SYMBOL}'","1,'${CONVERTER}' TLOS,0.0,admin.tbn"]' -p admin.tbn@active
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

```bash
API="--url https://api.telos.africa"

NETWORK="bancor.tbn"
NETWORK_TOKEN=TLOS
TOKEN=stablecoin.z
CONVERTER_CODE=zar
SYMBOL=EZAR
PRESISION="00"

TLOS_LIQUIDITY=1000.0000
TOKEN_LIQUIDITY=1283.66
SMART_LIQUIDITY=25000.00000000
FEE=2000

echo
TOKEN=stablecoin.z
CONVERTER_CODE=zar
SYMBOL=EZAR

ACCOUNT="${CONVERTER_CODE}.tbn"
RELAY="${CONVERTER_CODE}relay.tbn"
SMART_TOKEN=${NETWORK_TOKEN}$(echo $CONVERTER_CODE | tr '[a-z]' '[A-Z]')

echo cleos $API push action eosio.token transfer '["qwertyqwerty","'${NETWORK}'","'${TLOS_AMOUNT}' TLOS","1,'${CONVERTER}' '${SYMBOL}',0.0,admin.tbn"]' -p admin.tbn@active

cleos --url https://api.telos.africa push action eosio.token transfer '["qwertyqwerty","bancor.tbn","10.0000 TLOS","1,zar.tbn EZAR,13.00858494,qwertyqwerty"]' -p qwertyqwerty@active
# 13.07 EZAR
cleos --url https://api.telos.africa push action stablecoin.z transfer '["qwertyqwerty","bancor.tbn","13.07 EZAR","1,zar.tbn TLOS,9.84727167,qwertyqwerty"]' -p qwertyqwerty@active
# 9.8970 TLOS


```