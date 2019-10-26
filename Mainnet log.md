```bash
Rorys-MBP:bancor rory$ API="--url https://history.telos.africa:3443"
Rorys-MBP:bancor rory$ PUB_OWNER="EOS5oNHb9qY6seSxbNGT3LnRt5EjU97tWmx1GCg73sxc43fR9HPWX"
Rorys-MBP:bancor rory$ PUB_ACTIVE="EOS7VbFsbEHiYjB5rYzP2kmVQ8ZjD8m5AapENpqWehCQV4iaCd7cm"
Rorys-MBP:bancor rory$ echo $PUB_OWNER
EOS5oNHb9qY6seSxbNGT3LnRt5EjU97tWmx1GCg73sxc43fR9HPWX
Rorys-MBP:bancor rory$ echo $PUB_ACTIVE
EOS7VbFsbEHiYjB5rYzP2kmVQ8ZjD8m5AapENpqWehCQV4iaCd7cm
Rorys-MBP:bancor rory$ cleos $API system newaccount southafrica1 tbn $PUB_OWNER $PUB_ACTIVE --stake-cpu "0.9000 TLOS" --stake-net "0.1000 TLOS" --buy-ram-kbytes 10 --transfer -p southafrica1@active
executed transaction: ba0815f5cc4f183b897e4612c5c5ab48a9853b144498e8f15f133c0efcd4cf4d  336 bytes  19675 us
#         eosio <= eosio::newaccount            {"creator":"southafrica1","name":"tbn","owner":{"threshold":1,"keys":[{"key":"EOS5oNHb9qY6seSxbNGT3L...
#         eosio <= eosio::buyrambytes           {"payer":"southafrica1","receiver":"tbn","bytes":10240}
#   eosio.token <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.ram","quantity":"0.8743 TLOS","memo":"buy ram"}
#  southafrica1 <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.ram","quantity":"0.8743 TLOS","memo":"buy ram"}
#     eosio.ram <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.ram","quantity":"0.8743 TLOS","memo":"buy ram"}
#   eosio.trail <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.ram","quantity":"0.8743 TLOS","memo":"buy ram"}
#   eosio.token <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.ramfee","quantity":"0.0044 TLOS","memo":"ram fee"}
#  southafrica1 <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.ramfee","quantity":"0.0044 TLOS","memo":"ram fee"}
#  eosio.ramfee <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.ramfee","quantity":"0.0044 TLOS","memo":"ram fee"}
#   eosio.trail <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.ramfee","quantity":"0.0044 TLOS","memo":"ram fee"}
#   eosio.token <= eosio.token::transfer        {"from":"eosio.ramfee","to":"eosio.rex","quantity":"0.0044 TLOS","memo":"transfer from eosio.ramfee ...
#  eosio.ramfee <= eosio.token::transfer        {"from":"eosio.ramfee","to":"eosio.rex","quantity":"0.0044 TLOS","memo":"transfer from eosio.ramfee ...
#     eosio.rex <= eosio.token::transfer        {"from":"eosio.ramfee","to":"eosio.rex","quantity":"0.0044 TLOS","memo":"transfer from eosio.ramfee ...
#   eosio.trail <= eosio.token::transfer        {"from":"eosio.ramfee","to":"eosio.rex","quantity":"0.0044 TLOS","memo":"transfer from eosio.ramfee ...
#         eosio <= eosio::delegatebw            {"from":"southafrica1","receiver":"tbn","stake_net_quantity":"0.1000 TLOS","stake_cpu_quantity":"0.9...
#   eosio.token <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.stake","quantity":"1.0000 TLOS","memo":"stake bandwidth"}
#  southafrica1 <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.stake","quantity":"1.0000 TLOS","memo":"stake bandwidth"}
#   eosio.stake <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.stake","quantity":"1.0000 TLOS","memo":"stake bandwidth"}
#   eosio.trail <= eosio.token::transfer        {"from":"southafrica1","to":"eosio.stake","quantity":"1.0000 TLOS","memo":"stake bandwidth"}
warning: transaction executed locally, but may not be confirmed by the network yet         ] 
Rorys-MBP:bancor rory$ cleos $API get account tbn
created: 2019-09-09T12:35:32.000
permissions: 
     owner     1:    1 EOS5oNHb9qY6seSxbNGT3LnRt5EjU97tWmx1GCg73sxc43fR9HPWX
        active     1:    1 EOS7VbFsbEHiYjB5rYzP2kmVQ8ZjD8m5AapENpqWehCQV4iaCd7cm
memory: 
     quota:     11.32 KiB    used:     3.373 KiB  

net bandwidth: 
     staked:         0.1000 TLOS           (total stake delegated from account to self)
     delegated:      0.0000 TLOS           (total staked delegated to account from others)
     used:                 0 bytes
     available:        230.5 KiB  
     limit:            230.5 KiB  

cpu bandwidth:
     staked:         0.9000 TLOS           (total stake delegated from account to self)
     delegated:      0.0000 TLOS           (total staked delegated to account from others)
     used:                 0 us   
     available:        395.7 ms   
     limit:            395.7 ms   

producers:     <not voted>





```