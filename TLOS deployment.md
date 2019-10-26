## Constants

https://local.bloks.io/account/bancoradmin1?nodeUrl=basho.telos.caleos.io&coreSymbol=TLOS&systemDomain=eosio
https://local.bloks.io/account/bancoradmin1?nodeUrl=testnet.telos.africa:7777&coreSymbol=TLOS&systemDomain=eosio

### Testnet
```bash
API="--url http://testnet.telos.africa"
PUB="EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv" 
```
### Mainnet
```bash
API="--url https://history.telos.africa:3443"
```

## Step 0 : Create accounts

```bash
# Admin account 
cleos $API system newaccount southafrica1 bancoradmin1 $PUB --stake-cpu "1.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 10 --transfer -p southafrica1@active
cleos $API get account bancoradmin1

cleos $API get account z
cleos $API push action eosio.token transfer '[ "southafrica1", "z", "100.0000 TLOS", "Fund contracts" ]' -p southafrica1@active

# Network
cleos $API system newaccount z bancor.z $PUB --stake-cpu "1.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 200 --transfer -p z@active

# Converter
# cleos $API system newaccount z tlos.z $PUB --stake-cpu "1.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 600 --transfer -p z@active
cleos $API system newaccount z ezar.z $PUB --stake-cpu "1.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 600 --transfer -p z@active
cleos $API system newaccount z eksh.z $PUB --stake-cpu "1.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 600 --transfer -p z@active

# Relay
cleos $API system newaccount z tlosezar.z $PUB --stake-cpu "1.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 250 --transfer -p z@active
cleos $API system newaccount z tloseksh.z $PUB --stake-cpu "1.0000 TLOS" --stake-net "1.0000 TLOS" --buy-ram-kbytes 250 --transfer -p z@active

cleos $API get account bancor.z
# cleos $API get account tlos.z
cleos $API get account ezar.z
cleos $API get account eksh.z

cleos $API get account tlosezar.z
cleos $API get account tloseksh.z
```

## Step 1 : sort permissions
```bash
cleos $API set account permission bancor.z active '{ "threshold": 1, "keys": [{ "key": "EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv", "weight": 1 }], "accounts": [{ "permission": { "actor":"bancor.z","permission":"eosio.code" }, "weight":1 }] }' owner -p bancor.z@active
# cleos $API set account permission tlos.z active '{ "threshold": 1, "keys": [{ "key": "EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv", "weight": 1 }], "accounts": [{ "permission": { "actor":"tlos.z","permission":"eosio.code" }, "weight":1 }] }' owner -p tlos.z@active
cleos $API set account permission ezar.z active '{ "threshold": 1, "keys": [{ "key": "EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv", "weight": 1 }], "accounts": [{ "permission": { "actor":"ezar.z","permission":"eosio.code" }, "weight":1 }] }' owner -p ezar.z@active
cleos $API set account permission eksh.z active '{ "threshold": 1, "keys": [{ "key": "EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv", "weight": 1 }], "accounts": [{ "permission": { "actor":"eksh.z","permission":"eosio.code" }, "weight":1 }] }' owner -p eksh.z@active

cleos $API get account bancor.z
# cleos $API get account tlos.z
cleos $API get account ezar.z
cleos $API get account eksh.z
```

## Step 2 : Deploy bancor.z

```bash
cleos $API set contract bancor.z ./contracts/eos/BancorNetwork

cleos $API get account bancor.z
```

## Step 3 : Deploy converters

```bash
# cleos $API set contract tlos.z ./contracts/eos/BancorConverter
cleos $API set contract ezar.z ./contracts/eos/BancorConverter
cleos $API set contract eksh.z ./contracts/eos/BancorConverter

# cleos $API get account tlos.z
cleos $API get account ezar.z
cleos $API get account eksh.z
```
## Step 4 : Deploy relays
## Can use a single token contract

```bash
eosio-cpp ./contracts/eos/TlosToken/TlosToken.cpp -o ./contracts/eos/TlosToken/TlosToken.wasm

cleos $API set contract tlosezar.z ./contracts/eos/TlosToken
cleos $API set contract tloseksh.z ./contracts/eos/TlosToken

cleos $API get account tlosezar.z
cleos $API get account tloseksh.z
```

## Step 5 : Initialise relays

```bash
cleos $API push action tlosezar.z create '["ezar.z", "250000000.0000000000 TLSZAR"]' -p tlosezar.z@active
cleos $API push action tloseksh.z create '["eksh.z", "250000000.0000000000 TLSKSH"]' -p tloseksh.z@active

cleos $API get table tlosezar.z TLSZAR stat
cleos $API get table tloseksh.z TLSKSH stat
```

## Step 4 : Initialise converters

```bash
cleos $API push action ezar.z init '["tlosezar.z","0.0000000000 TLSZAR",0,0,"bancor.z",0,30000,3000]' -p ezar.z@active

cleos $API push action ezar.z setreserve '["stablecoin.z","0.00 EZAR",500000,1]' -p ezar.z@active
cleos $API push action ezar.z setreserve '["eosio.token","0.0000 TLOS",500000,1]' -p ezar.z@active

cleos $API push action tlosezar.z issue '["bancoradmin1", "20000.0000000000 TLSZAR", "Bancor token activation"]' -p ezar.z@active


cleos $API push action eksh.z init '["tloseksh.z","0.0000000000 TLSKSH",0,0,"bancor.z",0,30000,3000]' -p eksh.z@active

cleos $API push action eksh.z setreserve '["stablecoin.z","0.00 EKSH",500000,1]' -p eksh.z@active
cleos $API push action eksh.z setreserve '["eosio.token","0.0000 TLOS",500000,1]' -p eksh.z@active

cleos $API push action tloseksh.z issue '["bancoradmin1", "20000.0000000000 TLSKSH", "Bancor token activation"]' -p eksh.z@active


cleos $API get currency balance tlosezar.z bancoradmin1 TLSZAR
cleos $API get currency balance tloseksh.z bancoradmin1 TLSKSH
```

## Step 4.5 : Patch ezar.z (use update hack to correct error in max_fee)

```bash
# Modify contract
eosio-cpp ./contracts/eos/BancorConverter/BancorConverter.cpp -o ./contracts/eos/BancorConverter/BancorConverter.wasm
cleos $API set contract ezar.z ./contracts/eos/BancorConverter -p ezar.z@active
cleos $API push action ezar.z update '[0,0,0,30000]' -p ezar.z@active

# Revert contract
eosio-cpp ./contracts/eos/BancorConverter/BancorConverter.cpp -o ./contracts/eos/BancorConverter/BancorConverter.wasm
cleos $API set contract ezar.z ./contracts/eos/BancorConverter -p ezar.z@active
cleos $API push action ezar.z update '[0,0,0,3000]' -p ezar.z@active
```

## Step 5 : Fund connecter

```bash
cleos $API system claimrewards southafrica1 -p southafrica1@active
cleos $API push action eosio.token transfer '[ "southafrica1", "bancoradmin1", "900.0000 TLOS", "Fund Bancor" ]' -p southafrica1@active

cleos $API push action stablecoin.z issue '["bancoradmin1", "15000.00 EZAR",  "Fund Bancor"]' -p zartknissuer@active
cleos $API push action stablecoin.z issue '["bancoradmin1", "100000.00 EKSH", "Fund Bancor"]' -p kshtknissuer@active

cleos $API get currency balance stablecoin.z bancoradmin1 EZAR
cleos $API get currency balance stablecoin.z bancoradmin1 EKSH

cleos $API get actions bancoradmin1
```
## Step 6 : Fund and test converter

```bash
cleos $API push action ezar.z update '[0,0,0,3000]' -p ezar.z@active
cleos $API push action eosio.token  transfer '[ "bancoradmin1", "ezar.z", "2000.0000 TLOS", "setup" ]' -p bancoradmin1@active
cleos $API push action stablecoin.z transfer '[ "bancoradmin1", "ezar.z", "2000.00 EZAR", "setup" ]' -p bancoradmin1@active
cleos $API push action ezar.z update '[0,1,0,3000]' -p ezar.z@active

cleos $API get currency balance eosio.token ezar.z TLOS
cleos $API get currency balance stablecoin.z ezar.z EZAR

cleos $API push action eosio.token transfer '[ "bancoradmin1", "bancor.z", "1.0000 TLOS", "1,ezar.z EZAR,0.95,bancoradmin1" ]' -p bancoradmin1@active

```

```bash
cleos $API push action eksh.z update '[0,0,0,3000]' -p eksh.z@active
cleos $API push action eosio.token  transfer '[ "bancoradmin1", "eksh.z", "2000.0000 TLOS", "setup" ]' -p bancoradmin1@active
cleos $API push action stablecoin.z transfer '[ "bancoradmin1", "eksh.z", "14000.00 EKSH", "setup" ]' -p bancoradmin1@active
cleos $API push action eksh.z update '[0,1,0,3000]' -p eksh.z@active

cleos $API get currency balance eosio.token eksh.z TLOS
cleos $API get currency balance stablecoin.z eksh.z EKSH

cleos $API push action eosio.token transfer '[ "bancoradmin1", "bancor.z", "1.0000 TLOS", "1,eksh.z EKSH,0.95,bancoradmin1" ]' -p bancoradmin1@active
cleos $API push action eosio.token transfer '[ "bancoradmin1", "bancor.z", "10.00 EKSH", "1,eksh.z TLOS,0.95,bancoradmin1" ]' -p bancoradmin1@active





./scripts/compile.sh
cleos $API set contract bancor.z ./contracts/eos/BancorNetwork
cleos $API push action eosio.token transfer '[ "bancoradmin1", "bancor.z", "1.0000 TLOS", "1,eksh.z EKSH,6.95,bancoradmin1" ]' -p bancoradmin1@active
cleos $API push action eosio.token transfer '[ "bancoradmin1", "bancor.z", "1.00 EKSH", "1,eksh.z TLOS,0.14,bancoradmin1" ]' -p bancoradmin1@active




"from":"thefoxthefox"
"to":"thisisbancor"
"memo":"1,bnt2eoscnvrt BNT bnt2eoscnvrt BNTEOS,5.7579040216,thefoxthefox"
"quantity": "1.0000 EOS"

"from":"bancoradmin1"
"to":"bancor.z"
"memo":"1,bnt2eoscnvrt BNTEOS,0.0,bancoradmin1"
"quantity": "1.0000 EOS"

cleos $API push action ezar.z update '[1,1,0,3000]' -p ezar.z@active
cleos $API push action eosio.token  transfer '[ "bancoradmin1", "bancor.z", "1.0000 TLOS", "1,ezar.z TLSZAR,0.0,bancoradmin1" ]' -p bancoradmin1@active
cleos $API push action ezar.z update '[0,0,0,3000]' -p ezar.z@active

```
