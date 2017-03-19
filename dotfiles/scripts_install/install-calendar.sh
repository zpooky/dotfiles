#!/bin/bash

source $HOME/dotfiles/shared.sh

# vdirsyncer - sync calendar events to disk
VDIR_FEATURE=="${FEATURE_HOME}/vdirsyncer"
if [ ! -e "$VDIR_FEATURE" ]; then

  pip3_install requests requests_oauthlib
  if [ $? -eq 0 ]; then

    pip3_install git+https://github.com/untitaker/vdirsyncer.git
    if [ $? -eq 0 ]; then
      install_cron "*/5 * * * *	$DOTFILES_LIB/vdirsyncer_cron.sh"
      touch $VDIR_FEATURE
    fi
  fi
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
