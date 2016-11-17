#!/bin/bash
DOTFILES_HOME=~/dotfiles
DOTFILES_LIB=$DOTFILES_HOME/lib
USER_BIN=~/bin
USER=`whoami`
GROUP=$USER
FEATURE_HOME=$DOTFILES_HOME/features

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

sudo echo "start" || exit 1

# setup directory structure
if [ ! -e $USER_BIN ]; then
  mkdir $USER_BIN || exit 1
fi

# submodules
start_feature "submodules"
git submodule update --init --recursive
stop_feature "submodules"

# apps
start_feature "apt-get install"

sudo apt update
sudo apt      -y  install tmux htop
sudo apt-get  -y  install python3.5
sudo apt-get  -y  install w3m
sudo apt-get  -y  install feh
sudo apt-get  -y  install antiword
sudo apt-get  -y  install catdoc
sudo apt-get  -y  install python-sqlite
sudo apt-get  -y  install python-vobject
sudo apt-get  -y  installpython-gnomekeyring
sudo apt-get  -y  install ranger caca-utils highlight atool w3m poppler-utils mediainfo


stop_feature "apt-get install"

# update
start_feature "update pip"

sudo -H python3.5 `which pip` install --upgrade pip
sudo -H python3.5 `which pip` install keyring

stop_feature "update pip"

# keyring
## work host
## work port 993
## work username
## work email
## work password

# vdirsyncer
VDIR_FEATURE=$FEATURE_HOME/vdirsyncer
if [ ! -e "$VDIR_FEATURE" ]; then
  start_feature "vdirsyncer" 
  ## oauth support for googlecalendar
  sudo -H python3.5 `which pip` install requests requests_oauthlib
  
  ## install
  sudo -H python3.5 `which pip` install git+https://github.com/untitaker/vdirsyncer.git
  
  ## crontab
  install_cron "*/5 * * * *	$DOTFILES_LIB/vdirsyncer_cron.sh"
  
  touch $VDIR_FEATURE
  stop_feature "vdirsyncer" 
fi

# khal - interface to display calendar
KHAL_HOME=$FEATURE_HOME/khal
if [ ! -e $KHAL_HOME ]; then
  start_feature "khal"
  ## 
  sudo -H python3.5 `which pip` install git+https://github.com/pimutils/khal
  
  touch $KHAL_HOME
  stop_feature "khal"
fi

# davmail - translates protocol used by vdirsyncer for calendar
DAVMAIL_FEATURE=$FEATURE_HOME/davmail
if [ ! -e $DAVMAIL_FEATURE ];then
  start_feature "davmail"
  
  DAVMAIL_ZIP=$USER_BIN/davmail.zip
  wget -O $DAVMAIL_ZIP https://sourceforge.net/projects/davmail/files/latest/download?source=files
  RET=$?

  if [ $RET -eq 0 ];then
    unzip $DAVMAIL_ZIP -d $USER_BIN
    rm $DAVMAIL_ZIP
  
    # wget http://sourceforge.net/projects/davmail/files/davmail/4.7.2/davmail_4.7.2-2427-1_all.deb

    DAVMAIL_SERVICE_SRC=~/dotfiles/service/davmail
    DAVMAIL_SERVICE_DEST=/etc/init.d/davmail
    if [ ! -e $DAVMAIL_SERVICE_DEST ];then
      sudo cp $DAVMAIL_SERVICE_SRC /etc/init.d
      sudo chmod a+x $DAVMAIL_SERVICE_DEST
      # TODO fix service
      sudo service davmail start
      sudo update-rc.d davmail defaults

    fi

    touch $DAVMAIL_FEATURE
    stop_feature "davmail"
  else
    failed_feature "davmail remote zip"
  fi
fi

# lbdb - contact list for mutt
LBDB_FEATURE=$FEATURE_HOME/lbdb
if [ ! -e $LBDB_FEATURE ]; then
  start_feature "LBDB"
	sudo apt-get -y install lbdb
  RET=$?
  if [ $RET -ne 0 ]; then
    failed_feature "LBDB"
  else
    stop_feature "LBDB"
  fi
  touch $LBDB_FEATURE
fi

# offlineimap - offline mail sync
OFFLINEIMAP_FEATURE=$FEATURE_HOME/offlineimap
if [ ! -e $OFFLINEIMAP_FEATURE ]; then
  start_feature "offlineimap"

  sudo apt-get -y install offlineimap
  install_cron "*/5 * * * *	~/dotfiles/lib/offlineimap_cron.sh"

  touch $OFFLINEIMAP_FEATURE
  stop_feature "offlineimap"
fi

# mutt - mail client reads mail from disk
MUTT_FEATURE=$FEATURE_HOME/mutt
if [ ! -e $MUTT_FEATURE ]; then
  start_feature "mutt"
  # TODO fix
  stop_feature "mutt"
fi

# bashrc
BASHRC_FEATURE=$FEATURE_HOME/bashrc
if [ ! -e $BASHRC_FEATURE ]; then
  start_feature "bashrc"

  echo 'source ~/dotfiles/extrarc' >> ~/.bashrc

  touch $BASHRC_FEATURE
  stop_feature "bashrc"
fi
