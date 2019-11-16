#!/bin/bash
################################################################################
#
# Scrip Created by http://EOSza.io
# Bancor trading bot
#
# Rebalance Bancor every 10 min.
#
# Edit config.json with your data and run start.sh to run bot in background
#
################################################################################

config="config.json"
LOG_INTERVAL="$( jq -r '.LOG_INTERVAL' "$config" )";

trade(){

    now=`(date +%s)`
    echo
    echo "Time since last trade : "$(($now-$LAST_TRADE_TIME))" seconds"
    LAST_TRADE_TIME=`(date +%s)`
    echo $LAST_TRADE_TIME > lastlog.txt

    ./trade.py
    ./lock_wallet.sh

    echo
    echo "waiting for next trade..."
    sleep $LOG_INTERVAL

    trade ""
}

now=`(date +%s)`
LAST_TRADE_TIME=$now
trade ""

#if [ $(($now-$LAST_TRADE_TIME)) -lt $LOG_INTERVAL ]; then
#    wait=$(($LOG_INTERVAL - $now + $LAST_TRADE_TIME));
#    wait_min=$((wait/60));
#    echo "wait to log: $wait_min min"
#    sleep $wait;
#    trade ""

#else
#    echo "It's time to Log."
#    trade ""
#fi
