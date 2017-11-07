#!/bin/bash

#TODO file lock
davmail $HOME/.davmail/davmail.properties &
DAVMAIL_PID=$!
sleep 2

DOTFILES=$HOME/dotfiles
DOTFILES_LIB=$DOTFILES/lib

$DOTFILES_LIB/keypass_cron.sh
$DOTFILES_LIB/offlineimap_cron.sh
$DOTFILES_LIB/vdirsyncer_cron.sh

kill -9 $DAVMAIL_PID

#TODO stop davmail
