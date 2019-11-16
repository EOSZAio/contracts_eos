#!/bin/bash
################################################################################
#
################################################################################

DIR="./"

if [ -f $DIR"/tradebot.pid" ]; then
    pid=`cat $DIR"/tradebot.pid"`
    echo $pid
    kill $pid
    rm -r $DIR"/tradebot.pid"

    echo -ne "Stoping tradebot"

    while true; do
        [ ! -d "/proc/$pid/fd" ] && break
        echo -ne "."
        sleep 1
    done
    echo -ne "\rtradebot stopped.    \n"
fi
