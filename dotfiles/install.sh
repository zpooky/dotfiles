#!/bin/bash
DOTFILES_HOME=~/dotfiles
DOTFILES_LIB=$DOTFILES_HOME/lib
FEATURE_HOME=$DOTFILES_HOME/features

function start_feature(){
  echo ""
  echo ""
  echo "START $1"
  echo "------------------------------------"
  echo "------------------------------------"
}

function stop_feature(){
  echo ""
  echo ""
  echo "STOP $1"
  echo "------------------------------------"
  echo "------------------------------------"
}

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
start_feature "submodules"
git submodule update --init --recursive
stop_feature "submodules"

# apps
start_feature "apt-get install"
sudo apt update
sudo apt install tmux htop
sudo apt-get install python3.5
stop_feature "apt-get install"

# update
start_feature "update pip"
sudo -H python3.5 `which pip` install --upgrade pip
stop_feature "update pip"

# vdirsyncer
VDIR_FEATURE=$FEATURE_HOME/vdirsyncer
if [ ! -e "$VDIR_FEATURE" ]; then
  start_feature "vdirsyncer" 
  ## otath support for googlecalendar
  sudo -H python3.5 `which pip` install requests requests_oauthlib
  
  ## install
  sudo -H python3.5 `which pip` install git+https://github.com/untitaker/vdirsyncer.git
  
  ## crontab
  install_cron "*/5 * * * *	$DOTFILES_LIB/vdirsyncer_cron.sh"
  
  touch $VDIR_FEATURE
  stop_feature "vdirsyncer" 
fi

# khal
KHAL_HOME=$FEATURE_HOME/khal
if [ ! -e $KHAL_HOME ]; then
  start_feature "khal"
  ## 
  sudo -H python3.5 `which pip` install git+https://github.com/pimutils/khal
  
  touch $KHAL_HOME
  stop_feature "khal"
fi
