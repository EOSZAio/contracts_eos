#!/bin/bash

HOME=/Users/rory/bancor/telos-scripts
NODEOS=$HOME/nodeos
DATADIR=$NODEOS/data

$HOME/stop.sh

#rm -r $NODEOS/*

rm $NODEOS/nodeos.log
rm $NODEOS/nodeos.pid
rm $NODEOS/nodeos.tty
rm -r $NODEOS/data
rm -r $NODEOS/protocol_features

$HOME/start.sh
