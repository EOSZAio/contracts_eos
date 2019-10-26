## Constants

https://local.bloks.io/account/bancoradmin1?nodeUrl=basho.telos.caleos.io&coreSymbol=TLOS&systemDomain=eosio

## Check TLOS Bancor accounts

```bash
# bnttoken.tbn
permissions: 
     owner     1:    1 EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv
        active     1:    1 EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv, 1 bnttoken.tbn@eosio.code
memory: 
     quota:     299.8 KiB    used:     292.8 KiB  

  token BNT
  issuer bancorx.tbn

# bancorx.tbn
permissions: 
     owner     1:    1 EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv
        active     1:    1 EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv, 1 bancorx.tbn@eosio.code
memory: 
     quota:     11.32 KiB    used:     3.404 KiB  

# bancor.tbn
permissions: 
     owner     1:    1 EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv
        active     1:    1 EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv, 1 bancor.tbn@eosio.code
memory: 
     quota:     200.4 KiB    used:     165.2 KiB  

# tlos.tbn
permissions: 
     owner     1:    1 EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv
        active     1:    1 EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv, 1 tlos.tbn@eosio.code
memory: 
     quota:     598.3 KiB    used:       536 KiB  

  smart contract bnttlos.tbn
  smart token BNTTLOS
  reserve bancorx.tbn BNT
  reserve eosio.token TLOS

# bnttlos.tbn (BNTTLOS)
permissions: 
     owner     1:    1 EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv
        active     1:    1 EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv
memory: 
     quota:     299.8 KiB    used:       293 KiB

  token BNTTLOS
  issuer tlos.tbn
```

### Testnet API and keys

```bash
API="--url http://testnet.telos.africa:7777"
PUB_OWNER="EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv" 
PUB_ACTIVE="EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv"
echo $PUB_OWNER
echo $PUB_ACTIVE
```

## Step 0 : Compile conteacts
```bash
cd ~/bancor
./scripts/compile.sh
```
## Step 0 : Create accounts

```bash
# tbn namespace
cleos $API system newaccount southafrica1 tbn $PUB_OWNER $PUB_ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 10 --transfer -p southafrica1@active
cleos $API get account tbn

# Fund bankor
cleos $API system claimrewards southafrica1 -p southafrica1@active
cleos $API push action eosio.token transfer '[ "southafrica1", "tbn", "3500.0000 TLOS", "Fund Bancor" ]' -p southafrica1@active

# Admin account 
cleos $API system newaccount tbn admin.tbn $PUB_OWNER $PUB_ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 10 --transfer -p tbn@active
cleos $API get account admin.tbn

# TLOS Network
cleos $API system newaccount tbn bancor.tbn $PUB_OWNER $PUB_ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 200 --transfer -p tbn@active
cleos $API get account bancor.tbn

# bancorx.tbn (bancor token issuer)
cleos $API system newaccount tbn bancorx.tbn $PUB_OWNER $PUB_ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 10 --transfer -p tbn@active
cleos $API get account bancorx.tbn

# BNT Token
cleos $API system newaccount tbn bnttoken.tbn $PUB_OWNER $PUB_ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 250 --transfer -p tbn@active
cleos $API get account bnttoken.tbn

# BNTTLOS Smart token
cleos $API system newaccount tbn bnttlos.tbn $PUB_OWNER $PUB_ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 300 --transfer -p tbn@active
cleos $API get account bnttlos.tbn

# TLOS Converter
cleos $API system newaccount tbn tlos.tbn $PUB_OWNER $PUB_ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 600 --transfer -p tbn@active
cleos $API get account tlos.tbn

# Checklist
# 1. TLOS (eosio.token)
# 2. BNT (bnttoken.tbn)
# 3. Network (bancor.tbn)
# 4. BNTTLOS (bnttlos.tbn)
# 5. BNT<->TLOS (tlos.tbn)
```

## Step 1 : sort permissions

```bash
# BNT Token (bnttoken.tbn)
cleos $API set account permission bnttoken.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv", "weight": 1 }], "accounts": [{ "permission": { "actor":"bnttoken.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p bnttoken.tbn@active
cleos $API get account bnttoken.tbn

# BNT issuer (bancorx.tbn) (contract not deployed)
cleos $API set account permission bancorx.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv", "weight": 1 }], "accounts": [{ "permission": { "actor":"bancorx.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p bancorx.tbn@active
cleos $API get account bancorx.tbn

# Network (bancor.tbn)
cleos $API set account permission bancor.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv", "weight": 1 }], "accounts": [{ "permission": { "actor":"bancor.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p bancor.tbn@active
cleos $API get account bancor.tbn

# Converter (tlos.tbn)
cleos $API set account permission tlos.tbn active '{ "threshold": 1, "keys": [{ "key": "EOS6QwSoHnrbB8z5ufYd91Ckqyd2ZBNXsbKBE9qJ5zxp3YZYsdiqv", "weight": 1 }], "accounts": [{ "permission": { "actor":"tlos.tbn","permission":"eosio.code" }, "weight":1 }] }' owner -p tlos.tbn@active
cleos $API get account tlos.tbn
```

## Step 2 : deploy contracts

```bash
# BNT Token
cleos $API set contract bnttoken.tbn ./contracts/eos/Token
cleos $API get account bnttoken.tbn

# Network (bancor.tbn)
cleos $API set contract bancor.tbn ./contracts/eos/BancorNetwork
cleos $API get account bancor.tbn

# BNTTLOS Smart token (bnttlos.tbn)
cleos $API set contract bnttlos.tbn ./contracts/eos/Token
cleos $API get account bnttlos.tbn

# BNT<->TLOS Converter (tlos.tbn)
cleos $API set contract tlos.tbn ./contracts/eos/BancorConverter
cleos $API get account tlos.tbn
```

## Step 3 : Initialise contracts

```bash
# Funding
cleos $API system claimrewards southafrica1 -p southafrica1@active
cleos $API push action eosio.token transfer '[ "southafrica1", "tbn", "1800.0000 TLOS", "Fund Bancor" ]' -p southafrica1@active


# BNT Token (bnttoken.tbn, issuer bancorx.tbn)
cleos $API push action bnttoken.tbn create '["bancorx.tbn", "250000000.0000000000 BNT"]' -p bnttoken.tbn@active
cleos $API get currency stats bnttoken.tbn BNT

{
  "BNT": {
    "supply": "0.0000000000 BNT",
    "max_supply": "250000000.0000000000 BNT",
    "issuer": "bancorx.tbn"
  }
}

# Network does not need initialisation

# BNTTLOS Smart token (bnttlos.tbn)
cleos $API push action bnttlos.tbn create '["tlos.tbn", "250000000.0000000000 BNTTLOS"]' -p bnttlos.tbn@active
cleos $API get currency stats bnttlos.tbn BNTTLOS

{
  "BNTTLOS": {
    "supply": "0.0000000000 BNTTLOS",
    "max_supply": "250000000.0000000000 BNTTLOS",
    "issuer": "tlos.tbn"
  }
}

# initialise converter (tlos.tbn)
cleos $API push action tlos.tbn init '["bnttlos.tbn","0.0000000000 BNTTLOS",0,0,"bancor.tbn",0,30000,3000]' -p tlos.tbn@active

cleos $API push action tlos.tbn setreserve '["bnttoken.tbn","0.0000000000 BNT",500000,1]' -p tlos.tbn@active
cleos $API push action tlos.tbn setreserve '["eosio.token","0.0000 TLOS",500000,1]' -p tlos.tbn@active

cleos $API push action bnttlos.tbn issue '["admin.tbn", "20000.0000000000 BNTTLOS", "Bancor token activation"]' -p tlos.tbn@active

# Get liquidity
cleos $API push action eosio.token  transfer '[ "tbn", "admin.tbn", "5000.0000 TLOS", "Funding for Bancor" ]' -p tbn@active
cleos $API push action bnttoken.tbn issue '["admin.tbn", "20000.0000000000 BNT", "Issue BNT"]' -p bancorx.tbn@active

cleos $API get currency balance bnttlos.tbn admin.tbn BNTTLOS
cleos $API get currency balance eosio.token admin.tbn TLOS
cleos $API get currency balance bnttoken.tbn admin.tbn BNT

# Add liquidity (0.147023  / 0.363320 ~ 2.5)
cleos $API push action eosio.token  transfer '[ "admin.tbn", "tlos.tbn", "5000.0000 TLOS", "setup" ]' -p admin.tbn@active
cleos $API push action bnttoken.tbn transfer '[ "admin.tbn", "tlos.tbn", "2000.0000000000 BNT", "setup" ]' -p admin.tbn@active

cleos $API get currency balance eosio.token tlos.tbn TLOS
cleos $API get currency balance bnttoken.tbn tlos.tbn BNT

# Enable converter
cleos $API push action tlos.tbn update '[0,1,0,3000]' -p tlos.tbn@active
```

## Step 4 : Test converstion

```bash
cleos $API push action eosio.token  transfer '[ "tbn", "admin.tbn", "250.0000 TLOS", "Funding to test Bancor" ]' -p tbn@active

cleos $API push action eosio.token transfer '[ "admin.tbn", "bancor.tbn", "1.0000 TLOS", "1,tlos.tbn BNT,0.0,admin.tbn" ]' -p admin.tbn@active
Error 3050003: eosio_assert_message assertion failure
Error Details:
assertion failure with message: converter doesn't exist

cleos $API push action eosio.token transfer '[ "admin.tbn", "bancor.tbn", "1.0000000000 BNT", "1,tlos.tbn TLOS,0.0,admin.tbn" ]' -p admin.tbn@active
Error 3050003: eosio_assert_message assertion failure
Error Details:
assertion failure with message: unable to find key
```
