#!/bin/bash
THE_HOME=~
DOTFILES_HOME=$THE_HOME/dotfiles
DOTFILES_LIB=$DOTFILES_HOME/lib
USER_BIN=$THE_HOME/bin
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

GIT_CONFIG_FEATURE=$FEATURE_HOME/gitconfig1
if [ ! -e $GIT_CONFIG_FEATURE ]; then
  start_feature "git config"

  # TODO fetch from keychain
  git config --global user.name "Fredrik Olsson"
  git config --global user.email "spooky.bender@gmail.com"
  git config --global core.editor vim

  git config --global alias.st status
  git config --global alias.tree "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
  
  touch $GIT_CONFIG_FEATURE

  stop_feature "git config"
fi

# setup directory structure
if [ ! -e $USER_BIN ]; then
  mkdir $USER_BIN || exit 1
fi

# submodules
start_feature "vim"
git submodule sync
# recursivly pull in all submodule repos
# git submodule update --init --recursive --remote
git submodule update --init --recursive
VIM_AUTOLOAD=$THE_HOME/.vim/autoload
if [ ! -e $VIM_AUTOLOAD ]; then
  mkdir $VIM_AUTOLOAD
fi
PATHOGEN_AUTLOAD=$VIM_AUTOLOAD/pathogen.vim
if [ ! -e $PATHOGEN_AUTLOAD ]; then
  PATHOGEN_VIM=$THE_HOME/.pathogen/vim-pathogen/autoload/pathogen.vim
  ln -s $PATHOGEN_VIM $PATHOGEN_AUTLOAD
fi
stop_feature "vim"

# git You Complete Me(YCM)
FEATURE=$FEATURE_HOME/YouCompleteMe2
if [ ! -e $FEATURE ]; then
  start_feature "YouCompleteMe"

  PREV_DIR=`pwd`

  cd $THE_HOME/.vim/bundle/YouCompleteMe/
  ./install.py --clang-completer
  RET=$?

  if [ $RET -eq 0 ];then
    touch $FEATURE
  fi
  
  cd $PREV_DIR

  stop_feature "YouCompleteMe"
fi

# vim color coded
FEATURE=$FEATURE_HOME/color_coded1
if [ ! -e $FEATURE ]; then
  start_feature "color_coded1"

  PREV_DIR=`pwd`
  COLOR_CODED_PATH=~/.vim/bundle/color_coded 
  COLOR_CODED_BUILD_PATH=$COLOR_CODED_PATH/build
  cd $COLOR_CODED_PATH
  if [ -d $COLOR_CODED_BUILD_PATH ]; then
    rm -rf $COLOR_CODED_BUILD_PATH
  fi
  mkdir build
  cd build
  cmake ..
  if [ $? -eq 0 ];then 
    make && make install
    RET=$?
    
      # Cleanup afterward; frees several hundred megabytes
      make clean && make clean_clang

    if [ $RET -eq 0 ];then 
      touch $FEATURE
    fi
  fi
  
  cd $PREV_DIR
  
  stop_feature "color_coded1"
fi

# command-t(vim)
FEATURE=$FEATURE_HOME/commandt2
if [ ! -e $FEATURE ]; then
  start_feature "commandt1"
  
  PREV_DIR=`pwd`

  cd $THE_HOME/.vim/bundle/command-t/plugin
  rake make
  if [ $? -eq 0 ]; then 
    touch $FEATURE
  fi
  cd $PREV_DIR

  stop_feature "commandt1"
fi

# bashrc
BASHRC_FEATURE=$FEATURE_HOME/bashrc
if [ ! -e $BASHRC_FEATURE ]; then
  start_feature "bashrc"

  echo 'source ~/dotfiles/extrarc' >> ~/.bashrc

  touch $BASHRC_FEATURE
  stop_feature "bashrc"
fi

echo "Enter sudo password"
sudo echo "start" || exit 1

# pip3

# update
start_feature "update pip"

sudo apt-get  -y  install python3.5 || exit 1
sudo -H pip3 install --upgrade pip || exit 1
sudo -H pip3 install keyring || exit 1

stop_feature "update pip"
# apps

start_feature "apt-get update"
sudo apt-get update || exit 1

start_feature "apt-get install python"

sudo apt-get  -y  install python-sqlite || exit 1
sudo apt-get  -y  install python-vobject || exit 1
sudo apt-get  -y  install python-gnomekeyring || exit 1
sudo apt-get install build-essential python-dev || exit 1

start_feature "apt-get install tools"
sudo apt-get  -y  install tmux htop || exit 1
sudo apt-get  -y  install rake || exit 1
sudo apt-get  -y  install wget || exit 1
sudo apt-get  -y  install curl || exit 1
sudo apt-get  -y  install w3m || exit 1
sudo apt-get  -y  install feh || exit 1
sudo apt-get  -y  install antiword || exit 1
sudo apt-get  -y  install catdoc || exit 1
sudo apt-get  -y  install ranger caca-utils highlight atool w3m poppler-utils mediainfo || exit 1
sudo apt-get  -y  install ncurses-term || exit 1
sudo apt-get  -y  install sqlite3 || exit 1
sudo apt-get  -y  install sed || exit 1
sudo apt-get  -y  install ack-grep || exit 1

sudo apt-get -y install libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev || exit 1
sudo apt-get -y install libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev || exit 1

# vim things
sudo apt-get  -y  install build-essential libclang-3.9-dev libncurses-dev libz-dev cmake xz-utils libpthread-workqueue-dev
LUA_VIM_MINOR_VERSION=`vim --version | grep "\-llua" | sed -r "s/.*\-llua5.([0-9]*).*/\1/"`
sudo apt-get -y   install liblua5.$LUA_VIM_MINOR_VERSION-dev lua5.$LUA_VIM_MINOR_VERSION

start_feature "apt-get install libs"
sudo apt-get  -y  install openssl || exit 1

start_feature "apt-get install gnu stuff"
# The package libreadline is for running applications using readline command
# and the package libreadline-dev is for compiling and building readline application.
sudo apt-get  -y  install libreadline6 libreadline6-dev || exit 1

start_feature "apt-get install cpp stuff"
# cpp
sudo apt-get  -y install clang || exit 1
sudo apt-get  -y install cmake || exit 1
#TODO assert cmake version is greater than 2.8

start_feature "apt-get install perf"
sudo apt-get -y  install linux-tools-common linux-tools-generic linux-tools-`uname -r` || exit 1

start_feature "pip install cpp"
sudo -H pip3 install cpplint || exit 1

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

  sudo -H pip3 install requests requests_oauthlib || exit 1
  
  ## install
  sudo -H pip3 install git+https://github.com/untitaker/vdirsyncer.git || exit 1
  
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
  rm $THE_HOME/.local/share/khal/khal.db 
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

    DAVMAIL_SERVICE_SRC=$THE_HOME/dotfiles/service/davmail
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
  install_cron "*/5 * * * *	$THE_HOME/dotfiles/lib/offlineimap_cron.sh"

  touch $OFFLINEIMAP_FEATURE
  stop_feature "offlineimap"
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

# mega
FEATURE=$FEATURE_HOME/mega1
if [ ! -e $FEATURE ]; then
  start_feature "mega"

  PREV_DIR=`pwd`

  TEMP_DIR=`mktemp -d`
  cd $TEMP_DIR

  MEGA_DEB=$TEMP_DIR/megasync.deb
  # TODO automatic fetch ubuntu version and use it in the wget
  wget -O $MEGA_DEB https://mega.nz/linux/MEGAsync/xUbuntu_16.04/amd64/megasync-xUbuntu_16.04_amd64.deb

  if [ $? -eq 0 ];then
    sudo apt-get -y install libcrypto++9
    if [ $? -eq 0 ];then
      sudo dpkg -y -i $MEGA_DEB
        if [ $? -eq 0 ];then
          touch $FEATURE
        fi
    fi
  fi

  stop_feature "mega"
fi

# powerline
FEATURE=$FEATURE_HOME/powerline1
if [ ! -e $FEATURE ]; then
  # http://askubuntu.com/questions/283908/how-can-i-install-and-use-powerline-plugin
  # TODO add system wide font install base on answer above
  start_feature "powerline"

  PREV_DIR=`pwd`
  
  sudo -H pip2 install powerline-status
  RET=$?
  if [ $RET -eq 0 ];then
    
    FONTS_DIR=$THE_HOME/.fonts
    if [ ! -e $FONTS_DIR ]; then
      mkdir $FONTS_DIR
    fi
    
    POWERLINE_FONT=$FONTS_DIR/PowerlineSymbols.otf 
    if [ ! -e $POWERLINE_FONT ];then
      cd $FONTS_DIR
      
      wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
      RET=$?
      
      fc-cache -vf $FONTS_DIR
    fi
    
    if [ $RET -eq 0 ];then
      FONTCONFIG_DIR=$THE_HOME/.config/fontconfig/conf.d
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

# install powerline tmux segments
POWERLINE_SEGMENTS=/usr/local/lib/python2.7/dist-packages/powerline/segments
if [ ! -e $POWERLINE_SEGMENTS/spooky ]; then
 sudo cp $THE_HOME/.config/powerline/segments/spooky $POWERLINE_SEGMENTS -R 
fi

# csope bin. install to /usr/bin
FEATURE=$FEATURE_HOME/cscope
if [ ! -e $FEATURE ]; then
  start_feature "cscope"

  PREV_DIR=`pwd`

  TEMP_DIR=`mktemp -d`
  cd $TEMP_DIR
  CSCOPE_TAR_PATH=$TEMP_DIR/csope.tar.gz
  wget -O $CSCOPE_TAR_PATH https://sourceforge.net/projects/cscope/files/cscope/15.8b/cscope-15.8b.tar.gz/download
  if [ $? -eq 0 ];then 
    UNTAR_CSCOPE=$TEMP_DIR/cscope
    mkdir $UNTAR_CSCOPE
    tar -xzvf $CSCOPE_TAR_PATH -C $UNTAR_CSCOPE --strip-components=1
    if [ $? -eq 0 ];then 
      cd $UNTAR_CSCOPE
      ./configure --prefix=/usr
      if [ $? -eq 0 ];then 
        make
        if [ $? -eq 0 ];then 
          sudo make install
          if [ $? -eq 0 ];then 
            cscope --version
            touch $FEATURE
          fi
        fi
      fi
    fi
  fi

  cd $PREV_DIR

  stop_feature "cscope"
fi

# caps to shift
FEATURE=$FEATURE_HOME/caps_to_shift
if [ ! -e $FEATURE ]; then
  start_feature "caps_to_shift"

  xmodmap -e "keycode 66 = Shift_L NoSymbol Shift_L"

  touch $FEATURE
  stop_feature "caps_to_shift"
fi

#uninstall ctags
OLD_FEATURE=$FEATURE_HOME/ctags
if [ -e $OLD_FEATURE ]; then
  sudo apt-get -y remove ctags
  sudo apt-get -y autoremove
  rm $OLD_FEATURE
fi

# ctags
FEATURE=$FEATURE_HOME/ctags_universal1
if [ ! -e $FEATURE ]; then
  start_feature "ctags"

  PREV_DIR=`pwd`

  TEMP_DIR=`mktemp -d`
  cd $TEMP_DIR

  CTAGS=ctags
  git clone https://github.com/universal-ctags/$CTAGS.git

  if [ $? -eq 0 ];then 
    cd $CTAGS
    ./autogen.sh

    if [ $? -eq 0 ];then 
      ./configure --prefix=/usr/local

      if [ $? -eq 0 ];then 
        make
        if [ $? -eq 0 ];then 
          sudo make install
          if [ $? -eq 0 ];then 
            ctags --version
            touch $FEATURE
          fi
        fi
      fi
    fi
  fi

  cd $PREV_DIR

  stop_feature "ctags"
fi

# cppcheck
FEATURE=$FEATURE_HOME/cppcheck1
if [ ! -e $FEATURE ]; then
  start_feature "cppcheck"
  
  PREV_DIR=`pwd`

  sudo apt-get -y remove cppcheck

  TEMP_DIR=`mktemp -d`
  cd $TEMP_DIR

  CPPCHECK=cppcheck
  git clone https://github.com/danmar/$CPPCHECK.git 

  if [ $? -eq 0 ];then 
    cd $CPPCHECK

      if [ $? -eq 0 ];then 
        make
        if [ $? -eq 0 ];then 
          sudo make install
          if [ $? -eq 0 ];then 
            cppcheck --version
            touch $FEATURE
          fi
        fi
      fi
  fi

  cd $PREV_DIR

  stop_feature "cppcheck"
fi

# less colors
# FEATURE=$FEATURE_HOME/lesscolors
# if [ ! -e $FEATURE ]; then
#   start_feature "lesscolors"
# 
# 
#   touch $FEATURE
#   stop_feature "lesscolors"
# fi
