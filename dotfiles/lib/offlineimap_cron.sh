#!/bin/bash

# DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
# export DBUS_SESSION_BUS_ADDRESS
source $HOME/.Xdbus
OUT=/tmp/sync_offlineimap

# sync
echo "offlineimap" > $OUT
echo "PATH:" >> $OUT
echo $PATH >> $OUT
which offlineimap >> $OUT

echo "start" >> $OUT
date >> $OUT
echo "offlineimap" >> $OUT
offlineimap >> $OUT
RET=$?
echo "ret: ${RET}" >> $OUT
echo "done" >> $OUT
date >> $OUT

#
new_mail_dirs=("$HOME/.mail/*/*/new/")
MSG=""
ANY_NEW=false
for dir in ${new_mail_dirs[@]}; do
  #count new mails
  new_mails=`find "$dir" -type f | wc -l`
  if [[ new_mails -gt 0 ]]; then
    box=`echo $dir | sed -re "s/^.*\/(.*)\/new.*/\1/"`
    MSG="${MSG}$box($new_mails)"
    if [[ $ANY_NEW = true ]]; then
      MSG="${MSG}/"
    fi
    ANY_NEW=true
  fi
done

if [[ $ANY_NEW = true ]]; then
  #--hint=STRING:body:11 --hint=STRING:body:"$MSG"
  if [[ ! -e ~/.nonotify ]]; then
    notify-send --urgency=critical "$MSG" --expire-time=10
  fi
fi


# log
whoami >> $OUT
date >> $OUT 
