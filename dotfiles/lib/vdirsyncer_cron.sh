#!/bin/bash
source $HOME/.Xdbus 
OUT=/tmp/sync_vdirsyncer

echo "==============================="
echo "==============================="
echo "==vdirsyncer============================"
echo "==============================="
echo "vdirsyncer" > $OUT
vdirsyncer discover 2>&1 | tee $OUT 
vdirsyncer sync 2>&1 | tee $OUT
echo "--PATH--" >> $OUT
echo $PATH >> $OUT

# log
whoami >> $OUT
date >> $OUT 
