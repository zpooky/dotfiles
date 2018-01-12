#!/bin/bash


LOG=/TMP/sync_mail

date > ${LOG}
#TODO file lock
davmail $HOME/.davmail/davmail.properties &
DAVMAIL_PID=$!
DAVMAIL_RET=$?
if [ ! $DAVMAIL_RET -eq 0 ]; then
  echo "davmail failed to start" >> ${LOG}
  exit 2
fi

DOTFILES=$HOME/dotfiles
DOTFILES_LIB=$DOTFILES/lib

$DOTFILES_LIB/keypass_cron.sh

sleep 2

$DOTFILES_LIB/offlineimap_cron.sh
$DOTFILES_LIB/vdirsyncer_cron.sh

echo "killing davmail" >> ${LOG}
kill -15 $DAVMAIL_PID
sleep 1
kill -9 $DAVMAIL_PID

#TODO stop davmail
