
```bash
CYAN='\033[1;36m'
GREEN='\033[0;32m'
NC='\033[0m'
```

## Config

### Mainnet
```bash
API="--url https://api.telos.africa"
OWNER="EOS5oNHb9qY6seSxbNGT3LnRt5EjU97tWmx1GCg73sxc43fR9HPWX"
ACTIVE="EOS7VbFsbEHiYjB5rYzP2kmVQ8ZjD8m5AapENpqWehCQV4iaCd7cm"

cleos $API push action free.tf create '[ "coolxcreator", "tlseosbridge", "'$OWNER'", "'$ACTIVE'", "EOS" ]' -p coolxcreator@freeaccount
```
