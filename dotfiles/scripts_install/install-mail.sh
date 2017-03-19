#!/bin/bash

source $HOME/dotfiles/shared.sh

install antiword || exit 1
install caca-utils
install feh || exit 1
install catdoc || exit 1
install w3m || exit 1
install w3m-img
#  for PDF text
install poppler-utils

# davmail - translates protocol used by vdirsyncer for calendar
DAVMAIL_FEATURE=$FEATURE_HOME/davmail
if [ ! -e $DAVMAIL_FEATURE ];then

  PREV_DIR=`pwd`
  TEMP_DIR=`mktemp -d`
  cd $TEMP_DIR

  TARGET="/opt/davmail"
  if [ ! -e $TARGET ];then
    sudo mkdir $TARGET || exit 1
  fi

  TAR="${TEMP_DIR}/davmail.tar.gz"
  echo $TAR
  DAVMAIL_VERSION=4.7.3
  URL="https://sourceforge.net/projects/davmail/files/davmail/${DAVMAIL_VERSION}/davmail-linux-x86_64-${DAVMAIL_VERSION}-2438.tgz"
  echo $URL
  wget -O $TAR $URL

  if [ $? -eq 0 ];then
    echo "sudo tar -xzvf $TAR -C $TARGET --strip-components=1"
    sudo tar -xzvf $TAR -C $TARGET --strip-components=1
    if [ $? -eq 0 ];then

      DAVMAIL_SOURCE_ROOT="${THE_HOME}/.davmail"
      sudo cp $DAVMAIL_SOURCE_ROOT/davmail.properties $TARGET || exit 1

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
  # TODO build from github https://github.com/tgray/lbdb
  if [ $? -eq 0 ]; then
    install_cron "1 */24 * * *" "$THE_HOME/.mutt/lib/refreshaddress.sh" || exit 1
    touch $LBDB_FEATURE
  fi
fi

# offlineimap - offline mail sync
FEATURE=$FEATURE_HOME/offlineimap
if [ ! -e $FEATURE ]; then
  # 1. create project in https://console.developers.google.com/iam-admin/projects
  # 2. add permissions https://console.developers.google.com/apis/api/
  # - gmail API
  # - Calendar API
  # - CalDAV API?
  # 3. Credentials > Oath Constant Screen > Product name > Save
  # 4. Crednetials > Create credential > oath client id
  PREV_DIR=`pwd`

  pip2_install git+https://github.com/OfflineIMAP/offlineimap.git
  if [ $? -eq 0 ]; then
    install_cron "*/5 * * * *	$THE_HOME/dotfiles/lib/offlineimap_cron.sh"
    touch $FEATURE
  fi

  cd $PREV_DIR

fi
