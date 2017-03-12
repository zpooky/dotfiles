#!/bin/bash

source $HOME/dotfiles/shared.sh

# vdirsyncer - sync calendar events to disk
VDIR_FEATURE_INITIAL=$FEATURE_HOME/vdirsyncer
VDIR_FEATURE="${VDIR_FEATURE_INITIAL}1"
if [ ! -e "$VDIR_FEATURE" ]; then

  pip3_install requests requests_oauthlib || exit 1

  ## install
  pip3_install git+https://github.com/untitaker/vdirsyncer.git || exit 1

  if [ ! -e $VDIR_FEATURE_INITIAL ]; then
    ## crontab
    install_cron "*/5 * * * *	$DOTFILES_LIB/vdirsyncer_cron.sh"
  fi

  touch $VDIR_FEATURE
fi

# khal - interface to display calendar
KHAL_FEATURE=$FEATURE_HOME/khal1
if [ ! -e $KHAL_FEATURE ]; then
  # clear buggy cache
  rm $THE_HOME/.local/share/khal/khal.db 
  # install/update
  pip3_install git+https://github.com/pimutils/khal
  if [ $? -eq 0 ]; then
    touch $KHAL_FEATURE
  fi
fi
