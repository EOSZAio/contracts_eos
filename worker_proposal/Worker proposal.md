
```bash
cleos wallet unlock -n rory

CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'

API="--url https://api.telos.africa:4443"
OWNER="EOS5oNHb9qY6seSxbNGT3LnRt5EjU97tWmx1GCg73sxc43fR9HPWX"
ACTIVE="EOS7VbFsbEHiYjB5rYzP2kmVQ8ZjD8m5AapENpqWehCQV4iaCd7cm"

# Fund bankor
cleos $API system claimrewards southafrica1 -p southafrica1@active
cleos $API push action eosio.token transfer '[ "southafrica1", "tbn", "3500.0000 TLOS", "Fund Bancor" ]' -p southafrica1@active

# Funding account 
cleos $API system newaccount tbn funding.tbn $OWNER $ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 10 --transfer -p tbn@active
cleos $API get account funding.tbn

```