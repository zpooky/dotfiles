#!/bin/bash
source $HOME/.Xdbus 
OUT=/tmp/sync_vdirsyncer


echo "vdirsyncer" > $OUT
which vdirsyncer >> $OUT
date >> $OUT

echo "vdirsyncer discover" >> $OUT
vdirsyncer discover 2>&1 >> $OUT
RET=$?
echo "ret: ${RET}" >> $OUT

echo "vdirsyncer sync" >> $OUT
vdirsyncer sync 2>&1 >> $OUT
RET=$?
echo "ret: ${RET}" >> $OUT

date >> $OUT

echo "--PATH--" >> $OUT
echo $PATH >> $OUT

# log
whoami >> $OUT
date >> $OUT 
