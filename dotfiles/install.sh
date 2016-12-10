#!/bin/bash
DOTFILES_HOME=~/dotfiles
DOTFILES_LIB=$DOTFILES_HOME/lib
USER_BIN=~/bin
USER=`whoami`
GROUP=$USER
FEATURE_HOME=$DOTFILES_HOME/features
KERNEL_VERSION="`uname -r`"

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
start_feature "vim"
git submodule update --init --recursive
VIM_AUTOLOAD=~/.vim/autoload
if [ ! -e $VIM_AUTOLOAD ]; then
  mkdir $VIM_AUTOLOAD
fi
PATHOGEN_AUTLOAD=$VIM_AUTOLOAD/pathogen.vim
if [ ! -e $PATHOGEN_AUTLOAD ]; then
  PATHOGEN_VIM=~/.pathogen/vim-pathogen/autoload/pathogen.vim
  ln -s $PATHOGEN_VIM $PATHOGEN_AUTLOAD
fi
stop_feature "vim"

# update
start_feature "update pip"

sudo -H pip3 install --upgrade pip
sudo -H pip3 install keyring

stop_feature "update pip"
# apps

start_feature "apt-get update"
sudo apt update

start_feature "apt-get install python"

sudo apt-get  -y  install python3.5
sudo apt-get  -y  install python-sqlite
sudo apt-get  -y  install python-vobject
sudo apt-get  -y  install python-gnomekeyring
sudo apt-get install build-essential python-dev

start_feature "apt-get install tools"
sudo apt      -y  install tmux htop
sudo apt      -y  install wget
sudo apt      -y  install curl
sudo apt-get  -y  install w3m
sudo apt-get  -y  install feh
sudo apt-get  -y  install antiword
sudo apt-get  -y  install catdoc
sudo apt-get  -y  install ranger caca-utils highlight atool w3m poppler-utils mediainfo
sudo apt-get  -y  install ncurses-term
sudo apt-get  -y  install sqlite3

start_feature "apt-get install libs"
sudo apt-get  -y  install openssl

start_feature "apt-get install gnu stuff"
# The package libreadline is for running applications using readline command
# and the package libreadline-dev is for compiling and building readline application.
sudo apt-get  -y  install libreadline6 libreadline6-dev

start_feature "apt-get install cpp stuff"
# cpp
sudo apt-get  -y install clang
sudo apt-get  -y install cppcheck 
sudo apt-get  -y install cmake

start_feature "apt-get install perf"
sudo apt-get -y  install linux-tools-common linux-tools-generic linux-tools-`uname -r`

start_feature "pip install cpp"
sudo -H pip3 install cpplint

stop_feature "apt-get install"

# keyring
## work host <outlook.office365.com>
## work port <993>
## work username <>
## work email <>
## work password <>
## work domain <> mail_name@*domain*.com
## work realname <>
## work mail_name *mail_name*@domain.com

## personal password
## personal email
## personal cal_ical #gmail > settings > ... > copy private cal url

# pip2 for python2.7
which pip2
if [ ! $? -eq 0 ]; then
  PREV_DIR=`pwd`
  
  cd /tmp
  curl -O https://bootstrap.pypa.io/get-pip.py
  
  if [ $? -eq 0 ];then
    sudo -H  python2.7 get-pip.py
  fi
  
  cd $PREV_DIR
fi

# vdirsyncer - sync calendar events to disk
VDIR_FEATURE=$FEATURE_HOME/vdirsyncer
if [ ! -e "$VDIR_FEATURE" ]; then
  start_feature "vdirsyncer" 

  sudo -H pip3 install requests requests_oauthlib
  
  ## install
  sudo -H pip3 install git+https://github.com/untitaker/vdirsyncer.git
  
  ## crontab
  install_cron "*/5 * * * *	$DOTFILES_LIB/vdirsyncer_cron.sh"
  
  touch $VDIR_FEATURE
  stop_feature "vdirsyncer" 
fi

# khal - interface to display calendar
KHAL_FEATURE=$FEATURE_HOME/khal1
if [ ! -e $KHAL_FEATURE ]; then
  start_feature "khal"
  # clear buggy cache
  rm ~/.local/share/khal/khal.db 
  # install/update
  sudo -H pip3 install git+https://github.com/pimutils/khal
  
  touch $KHAL_FEATURE
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
  # 1. create project in https://console.developers.google.com/iam-admin/projects
  # 2. add permissions https://console.developers.google.com/apis/api/
  # - gmail API
  # - Calendar API
  # - CalDAV API?
  # 3. Credentials > Oath Constant Screen > Product name > Save
  # 4. Crednetials > Create credential > oath client id
  start_feature "offlineimap"

  sudo apt-get -y install offlineimap
  install_cron "*/5 * * * *	~/dotfiles/lib/offlineimap_cron.sh"

  touch $OFFLINEIMAP_FEATURE
  stop_feature "offlineimap"
fi

# bashrc
BASHRC_FEATURE=$FEATURE_HOME/bashrc
if [ ! -e $BASHRC_FEATURE ]; then
  start_feature "bashrc"

  echo 'source ~/dotfiles/extrarc' >> ~/.bashrc

  touch $BASHRC_FEATURE
  stop_feature "bashrc"
fi

# stdman
# example man std::vector
STDMAN_FEATURE=$FEATURE_HOME/stdman
if [ ! -e $STDMAN_FEATURE ]; then
  start_feature "stdman"
  
  STDMAN_ROOT=$USER_BIN/stdman
  rm -rf $STDMAN_ROOT

  git clone https://github.com/jeaye/stdman.git $STDMAN_ROOT
  if [ -e $STDMAN_ROOT ]; then
    PREV_DIR=`pwd`

    cd $STDMAN_ROOT
    ./configure

    RET=$?
    if [ $RET -eq 0 ];then
      sudo make install

      RET=$?
      if [ $RET -eq 0 ];then
        touch $STDMAN_FEATURE
        sudo mandb
        stop_feature "stdman"
      fi
     fi
     cd $PREV_DIR
   fi
fi

# bcc tools containging kernel debug stuff
BCC_FEATURE=$FEATURE_HOME/bcc
if [ ! -e $BCC_FEATURE ]; then
  if [ $KERNEL_VERSION != ^3.* ]; then
     start_feature "bcc"

     # https://github.com/iovisor/bcc/blob/master/INSTALL.md
     echo "deb [trusted=yes] https://repo.iovisor.org/apt/xenial xenial-nightly main" | sudo tee /etc/apt/sources.list.d/iovisor.list
     sudo apt-get update
     sudo apt-get -y install bcc-tools

     touch $BCC_FEATURE
     stop_feature "bcc"
  fi
fi

# # slang (mutt dependency)
# SLANG_DEP=slang-2.3.1
# SLANG_FEATURE=$FEATURE_HOME/$SLANG_DEP
# if [ ! -e $SLANG_FEATURE ]; then
#   start_feature "slang"
#
#   PREV_DIR=`pwd`
#   SLANG_TAR=$SLANG_DEP.tar.bz2
#   SLANG_TAR_PATH=$USER_BIN/$SLANG_TAR
#   SLANG_INSTALL_PATH=$USER_BIN/$SLANG_DEP
#
#   if [ -e $SLANG_INSTALL_PATH ]; then
#     rm -rf $SLANG_INSTALL_PATH
#   fi
#
#   wget "http://www.jedsoft.org/releases/slang/$SLANG_TAR" -O $SLANG_TAR_PATH
#   RET=$?
#   if [ $RET -eq 0 ];then
#     tar -xvf $SLANG_TAR_PATH --directory=$USER_BIN
#     RET=$?
#     rm $SLANG_TAR_PATH
#     if [ $RET -eq 0 ];then 
#       cd $SLANG_INSTALL_PATH
#       ./configure --prefix=/usr \
#             --sysconfdir=/etc \
#             --with-readline=gnu
#       RET=$?
#       if [ $RET -eq 0 ]; then
#         make -j1
#         RET=$?
#         if [ $RET -eq 0 ]; then
#           sudo make install
#           RET=$?
#           if [ $RET -e 0 ]; then
#             stop_feature "slang"
#             touch $SLANG_FEATURE
#           fi
#         fi
#       fi
#     fi
#   fi
#   cd $PREV_DIR
# fi

# # mutt
# MUTT_DIR=mutt-1.7.2
# MUTT_FEATURE=$FEATURE_HOME/$MUTT_DIR
# if [ ! -e $MUTT_FEATURE ]; then
#   start_feature "mutt"
#   
#   PREV_DIR=`pwd`
#   MUTT_TAR=$MUTT_DIR.tar.gz
#   MUTT_INSTALL_ROOT=$USER_BIN/$MUTT_DIR
#   MUTT_TAR_PATH=$USER_BIN/$MUTT_TAR
#
#   if [ -e $MUTT_INSTALL_ROOT ]; then
#     rm -rf $MUTT_INSTALL_ROOT
#   fi
#   
#   cd $USER_BIN
#   wget "ftp://ftp.mutt.org/pub/mutt/$MUTT_TAR" -O $MUTT_TAR_PATH
#   RET=$?
#   if [ $RET -eq 0 ];then
#      tar -xzvf $MUTT_TAR_PATH --directory=$USER_BIN
#      rm $MUTT_TAR_PATH
#
#      # touch $MUTT_FEATURE
#      stop_feature "mutt"
#   fi
#   cd $PREV_DIR
# fi

# git
GIT_CONFIG_FEATURE=$FEATURE_HOME/gitconfig1
if [ ! -e $GIT_CONFIG_FEATURE ]; then
  start_feature "git config"

  # TODO fetch from keychain
  git config --global user.name ""
  git config --global user.email ""
  git config --global core.editor vim

  git config --global alias.st status
  git config --global alias.tree "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
  
  touch $GIT_CONFIG_FEATURE

  stop_feature "git config"
fi

# keepass
FEATURE=$FEATURE_HOME/keepass1
if [ ! -e $FEATURE ]; then
  start_feature "keepass"

  #keepass
  sudo apt-add-repository -y ppa:jtaylor/keepass
  sudo apt-get update
  sudo apt-get -y install keepass2

  touch $FEATURE
  stop_feature "keepass"
fi

# git You Complete Me
FEATURE=$FEATURE_HOME/YouCompleteMe1
if [ ! -e $FEATURE ]; then
  start_feature "YouCompleteMe"

  PREV_DIR=`pwd`

  cd ~/.vim/bundle/YouCompleteMe/
  ./install.sh --clang-completer
  RET=$?

  if [ $RET -eq 0 ];then
    touch $FEATURE
  fi
  
  cd $PREV_DIR

  stop_feature "YouCompleteMe"
fi


# powerline
FEATURE=$FEATURE_HOME/powerline1
if [ ! -e $FEATURE ]; then
  start_feature "powerline"

  PREV_DIR=`pwd`
  
  sudo -H pip2 install powerline-status
  RET=$?
  if [ $RET -eq 0 ];then
    
    FONTS_DIR=~/.fonts
    if [ ! -e $FONTS_DIR ]; then
      mkdir $FONTS_DIR
    fi
    
    POWERLINE_FONT=$FONTS_DIR/PowerlineSymbols.otf 
    if [ ! -e $POWERLINE_FONT ];then
      cd $FONTS_DIR
      
      wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
      RET=$?
      
      sudo fc-cache -vf $FONTS_DIR
    fi
    
    if [ $RET -eq 0 ];then
      FONTCONFIG_DIR=~/.config/fontconfig/conf.d
      if [ ! -e $FONTCONFIG_DIR ];then
        mkdir -p $FONTCONFIG_DIR
      fi
      
      POWERLINE_CONF=$FONTCONFIG_DIR/10-powerline-symbols.conf
      if [ ! -e $POWERLINE_CONF ]; then
        cd $FONTCONFIG_DIR
        
        wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf 
        RET=$?
      fi
      
      if [ $RET -eq 0 ]; then
        touch $FEATURE
      fi
      echo ""
    fi
  fi

  cd $PREV_DIR 
  stop_feature "powerline"
fi

# # less colors
# FEATURE=$FEATURE_HOME/lesscolors
# if [ ! -e $FEATURE ]; then
#   start_feature "lesscolors"
# 
# 
#   touch $FEATURE
#   stop_feature "lesscolors"
# fi
