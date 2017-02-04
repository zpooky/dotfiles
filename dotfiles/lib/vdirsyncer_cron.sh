#!/bin/bash
source $HOME/.Xdbus 
OUT=/tmp/sync_vdirsyncer

/usr/local/bin/vdirsyncer discover > $OUT 2>&1
/usr/local/bin/vdirsyncer sync >> $OUT 2>&1
echo "--PATH--" >> $OUT
echo $PATH >> $OUT

# log
whoami >> $OUT
date >> $OUT 
