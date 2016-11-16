#!/bin/bash
source $HOME/.Xdbus 
OUT=/tmp/sync_vdirsyncer

vdirsyncer discover > $OUT 2>&1
vdirsyncer sync >> $OUT 2>&1

# log
whoami >> $OUT
date >> $OUT 
