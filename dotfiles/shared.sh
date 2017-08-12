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

function has_feature(){
  which $1 > /dev/null 2>&1
  WHICH_FEATURE=$?
  hash $1 > /dev/null 2>&1
  HASH_FEATURE=$?
  if [ $WHICH_FEATURE -eq $HASH_FEATURE ]; then
    if [ $WHICH_FEATURE -eq 0 ]; then
      return 0
    fi
  fi
  return 1
}

function install_aur() {
  echo "================================"
URL="$@"

TEMP_DIR=`mktemp -d`
TAR=$TEMP_DIR/aur_package.tar.gz
TARGET=$TEMP_DIR/target

wget $URL -O $TAR
if [ $? -eq 0 ]; then
  ls -alh $TAR

  mkdir $TARGET
  tar -xzf $TAR -C $TARGET --strip-components=1
  if [ $? -eq 0 ]; then 
    cd $TARGET
    if [ $? -eq 0 ]; then
      makepkg -Acs
      if [ $? -ne 0 ]; then
        return 3
      fi
      INSTALLS=( $TARGET/*x86_64.pkg.tar.xz )
      # echo "matching: ${INSTALLS[@]}"
      ls -alh

      if [ ${#INSTALLS[@]} -eq 0 ]; then
        return 1
      fi

      if [ ${#INSTALLS[@]} -gt 1 ]; then
        return 2
      fi

      echo "sudo pacman -U ${INSTALLS[0]}"
      sudo pacman -U "${INSTALLS[0]}"
    fi
  fi
fi

}

function is_cygwin(){
  if [[ $(uname -s) =~ CYGWIN.* ]]; then
    return 0
  else
    return 1
  fi
}

function is_arch(){
  has_feature pacman
  if [ $? -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

function is_apt_get(){
  # lets say that everything that is not arch uses apt-get
  has_feature "apt-get"
  if [ $? -eq 0 ]; then
    return 0
  else
    return 1
  fi
}
function update_package_list(){
  is_apt_get
  if [ $? -eq 0 ]; then
    sudo apt-get update || exit 1
  fi
}

function install(){
  is_arch
  if [ $? -eq 0 ];then
    echo "sudo pacman -S $@"
    sudo pacman -S $@
  else
    echo "sudo apt-get -y install $@"
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
  LIB_PYTHON2=/usr/lib/python2.7
  LIB_PYTHON3=/usr/lib/python3.6
  LIB_PYTHON2_PACKAGES="${LIB_PYTHON2}/site-packages"
  LIB_PYTHON3_PACKAGES="${LIB_PYTHON3}/site-packages"
else
  LIB_PYTHON2=/usr/local/lib/pthon2.7
  LIB_PYTHON3=/usr/local/lib/pthon3.6
  LIB_PYTHON2_PACKAGES="${LIB_PYTHON2}/dist-packages"
  LIB_PYTHON3_PACKAGES="${LIB_PYTHON3}/dist-packages"
fi
