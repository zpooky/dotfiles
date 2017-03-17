#!/bin/bash

THE_HOME=$HOME
DOTFILES_HOME=$THE_HOME/dotfiles
DOTFILES_LIB=$DOTFILES_HOME/lib
USER_BIN=$THE_HOME/bin
USER=`whoami`
GROUP=$USER
FEATURE_HOME=$DOTFILES_HOME/features
KERNEL_VERSION="`uname -r`"
GIT_SOURCES=$THE_HOME/sources
SOURCES_ROOT=$GIT_SOURCES
if [ ! -e $SOURCES_ROOT ]; then
  mkdir $GIT_SOURCES
fi

function echoerr() { echo "$@" 1>&2; }

function failed_feature(){
  echoerr "FAILED"
  echoerr "FAILED"
  echoerr "FAILED $1"
  echoerr "------------------------------------"
  echoerr "------------------------------------"
}

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

function is_arch(){
  if [ -f /etc/arch-release ];then
    return 0
  else
    return 1
  fi
}

function is_apt_get(){
  # lets say that everything that is not arch uses apt-get
  is_arch
  if [ $? -eq 0 ]; then
    return 1
  else
    return 0
  fi
}
function update_package_list(){
  is_apt_get
  if [ $? -eq 0 ];then
    sudo apt-get update || exit 1
  fi
}

function install(){
  is_arch
  if [ $? -eq 0 ];then
    sudo pacman -S $@
  else
    sudo apt-get -y install $@
  fi
}

function pip2_install(){
  sudo -H pip2 install $@
}

function pip3_install(){
  is_arch
  if [ $? -eq 0 ]; then
    sudo -H pip install $@
  else
    sudo -H pip3 install $@
  fi
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

function head_id(){
  git rev-parse HEAD
}
is_arch()
if [ $? -eq 0 ]; then
  LIB_PYTHON2=/usr/local/lib/pthon2.7
else
  LIB_PYTHON2=/usr/lib/python2.7
fi
