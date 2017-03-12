#!/bin/bash

source $HOME/dotfiles/shared.sh

# davmail - translates protocol used by vdirsyncer for calendar
DAVMAIL_FEATURE=$FEATURE_HOME/davmail
if [ ! -e $DAVMAIL_FEATURE ];then
  PREV_DIR=`pwd`
  TEMP_DIR=`mktemp -d`
  cd $TEMP_DIR
  TARGET=/opt/davmail
  if [ -e $TARGET ];then
    sudo mkdir $TARGET || exit 1
  fi

  TAR=$TEMP_DIR/davmail.tar.gz
  DAVMAIL_VERSION=4.7.3
  wget -O $TAR https://sourceforge.net/projects/davmail/files/davmail/$DAVMAIL_VERSION/davmail-linux-x86_64-$DAVMAIL_VERSION-2438.tgz

  if [ $? -eq 0 ];then
    sudo tar -xzvf $TAR -C $TARGET --strip-components=1
    if [ $? -eq 0 ];then

      DAVMAIL_SOURCE_ROOT=$THE_HOME/dotfiles/davmail
      sudo cp $DAVMAIL_SOURCE_ROOT/davmail.properties $TARGET || exit 1
      sudo cp $DAVMAIL_SOURCE_ROOT/start.sh $TARGET || exit 1
      SYSTEMD_ROOT=/usr/local/lib/systemd/system
      sudo mkdir -p $SYSTEMD_ROOT || exit 1
      sudo cp $DAVMAIL_SOURCE_ROOT/davmail.service $SYSTEMD_ROOT || exit 1
      sudo systemctl enable davmail.service
      sudo systemctl start davmail.service

      touch $DAVMAIL_FEATURE
    else
      sudo rm -rf $TARGET
    fi 
  else
    failed_feature "davmail remote zip"
  fi

  cd $PREV_DIR
fi

# lbdb - contact list for mutt
LBDB_FEATURE=$FEATURE_HOME/lbdb
if [ ! -e $LBDB_FEATURE ]; then
  install lbdb
  RET=$?
  install_cron "1 */24 * * *" "$THE_HOME/.mutt/lib/refreshaddress.sh"
  # TODO build from github https://github.com/tgray/lbdb
  if [ $RET -eq 0 ]; then
    touch $LBDB_FEATURE
  fi
fi

# offlineimap - offline mail sync
FEATURE=$FEATURE_HOME/offlineimap
FEATURE_LATEST="${FEATURE}1"
if [ ! -e $FEATURE_LATEST ]; then
  # 1. create project in https://console.developers.google.com/iam-admin/projects
  # 2. add permissions https://console.developers.google.com/apis/api/
  # - gmail API
  # - Calendar API
  # - CalDAV API?
  # 3. Credentials > Oath Constant Screen > Product name > Save
  # 4. Crednetials > Create credential > oath client id
  PREV_DIR=`pwd`

  if [ ! -e $FEATURE ]; then
    install_cron "*/5 * * * *	$THE_HOME/dotfiles/lib/offlineimap_cron.sh"
  fi

  pip2_install git+https://github.com/OfflineIMAP/offlineimap.git
  if [ $? -eq 0 ]; then
    touch $FEATURE_LATEST
  fi

  cd $PREV_DIR

fi
