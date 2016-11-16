#!/bin/bash
DOTFILES_HOME=~/dotfiles
DOTFILES_LIB=$DOTFILES_HOME/lib
FEATURE_HOME=$DOTFILES_HOME/features

function install_cron(){
  CRON_FILE=/tmp/mycron
  #write out current crontab
  crontab -l > $CRON_FILE
  #echo new cron into cron file
  echo "$1" >> $CRON_FILE
  #install new cron file
  crontab $CRON_FILE
  rm $CRON_FILE
}

# submodules
git submodule update --init --recursive

# apps
sudo apt update
sudo apt install tmux htop
sudo apt-get install python3.5

# update
sudo -H python3.5 `which pip` install --upgrade pip

# vdirsyncer
VDIR_FEATURE=$FEATURE_HOME/vdirsyncer
if [ ! -e "$VDIR_FEATURE" ]; then
## otath support for googlecalendar
sudo -H python3.5 `which pip` install requests requests_oauthlib

## install
sudo -H python3.5 `which pip` install git+https://github.com/untitaker/vdirsyncer.git

## crontab
install_cron "*/5 * * * *	$DOTFILES_LIB/vdirsyncer_cron.sh"

touch $VDIR_FEATURE
fi

# khal
KHAL_HOME=$FEATURE_HOME/khal
if [ ! -e $KHAL_HOME ]; then
## 
sudo -H python3.5 `which pip` install git+https://github.com/pimutils/khal

touch $KHAL_HOME
fi
