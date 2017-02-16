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
mkdir $GIT_SOURCES

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

function head_id(){
  git rev-parse HEAD
}

# compile less settings from .lesskey into .less
lesskey -o $THE_HOME/.less $THE_HOME/.lesskey

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
git submodule sync --recursive
# recursivly pull in all submodule repos
git submodule update --init --recursive --remote
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
YCM_IT=3
YCM_FORKS=("OblitumYouCompleteMe" "YouCompleteMe")

for YCM in "${YCM_FORKS[@]}"
do
  FEATURE="$FEATURE_HOME/${YCM}${YCM_IT}"
  if [ ! -e $FEATURE ]; then
    start_feature "$YCM"

    # TODO should recompile when vim version changes
    PREV_DIR=`pwd`

    cd $THE_HOME/.vim/bundle/$YCM
    ./install.py --clang-completer
    RET=$?
    if [ $RET -eq 0 ];then
      touch $FEATURE
    fi
    
    cd $PREV_DIR

    stop_feature "$YCM"
  fi
done

# vim color coded
FEATURE=$FEATURE_HOME/color_coded2
if [ ! -e $FEATURE ]; then
  start_feature "color_coded1"

  # TODO should recompile when vim version changes
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
FEATURE=$FEATURE_HOME/commandt3
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

start_feature "update tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins
stop_feature "update tmux plugins"


echo "Enter sudo password"
sudo echo "start" || exit 1

# pip3

# update
start_feature "update pip"

sudo apt-get  -y  install python3.5 || exit 1
sudo apt-get  -y  install python3-pip || exit 1
sudo -H pip3 install --upgrade pip || exit 1
sudo -H pip3 install keyring || exit 1

sudo apt-get install gnome-common gtk-doc-tools libglib2.0-dev libgtk2.0-dev || exit 1
sudo apt-get install python-gtk2 python-gtk2-dev python-vte glade python-glade2 || exit 1
sudo apt-get install libgconf2-dev python-appindicator || exit 1
sudo apt-get install python-vte python-gconf python-keybinder || exit 1
sudo apt-get install notify-osd || exit 1
sudo apt-get install libutempter0 || exit 1
sudo apt-get install python-notify || exit 1

stop_feature "update pip"
# apps

start_feature "apt-get update"
sudo apt-get update || exit 1

start_feature "apt-get install python"

sudo apt-get  -y  install python-sqlite || exit 1
sudo apt-get  -y  install python-vobject || exit 1
sudo apt-get  -y  install python-gnomekeyring || exit 1
sudo apt-get install python-dev || exit 1

start_feature "apt-get install tools"
sudo apt-get  -y  install htop || exit 1
sudo apt-get  -y  install rake || exit 1
sudo apt-get  -y  install wget || exit 1
sudo apt-get  -y  install curl || exit 1
# text terminal web browser
sudo apt-get  -y  install w3m || exit 1
sudo apt-get  -y  install w3m-img
sudo apt-get  -y  install colordiff || exit 1
sudo apt-get  -y  install feh || exit 1
sudo apt-get  -y  install antiword || exit 1
sudo apt-get  -y  install catdoc || exit 1
sudo apt-get  -y  install ncurses-term || exit 1
sudo apt-get  -y  install sqlite3 || exit 1
sudo apt-get  -y  install sed || exit 1
sudo apt-get  -y  install autoconf || exit 1
sudo apt-get  -y  install caca-utils || exit 1

# xterm-256color support
sudo apt-get  -y  install ncurses-term || exit 1
# for archives text
sudo apt-get  -y  install atool || exit 1
# for syntax highlighting. text ranger
sudo apt-get  -y  install highlight || exit 1
# for media file information.
sudo apt-get  -y  install mediainfo || exit 1
#  for PDF text
sudo apt-get  -y  install poppler-utils || exit 1
sudo apt-get  -y  install transmission-cli || exit 1


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

start_feature "standalone"
sudo apt-get -y install vlc
#newsbeuter 2.9
sudo apt-get -y install newsbeuter
stop_feature "standalone"

# keyring
## work host <outlook.office365.com>
## work port <993>
## work username <>
## work email <>
## work password <>
## work domain <> mail_name@*domain*.com
## work realname <> firstname surname
## work mail_name *mail_name*@domain.com

## personal password
## personal email
## personal realname <> firstname surname
## personal mail_name *mail_name*@domain.com
#not used: personal cal_ical #gmail > settings > ... > copy private cal url

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
sudo -H pip2 install --upgrade pip || exit 1

#python format
sudo -H pip2 install git+https://github.com/google/yapf.git
#python import sort
# sudo -H pip2 install git+https://github.com/timothycrosley/isort.git
which npm
if [ $? -eq 0 ];then
  sudo npm install -g typescript
  # js format
  sudo npm install -g js-beautify
  # typescript format
  sudo npm install -g typescript-formatter
  # markdown format
  sudo npm install -g remark
fi

STYLEISH_HASKELL=stylish-haskell
which $STYLEISH_HASKELL
if [ ! $? -eq 0 ];then
  cabal update
  cabal install $STYLEISH_HASKELL
fi

# vdirsyncer - sync calendar events to disk
VDIR_FEATURE_INITIAL=$FEATURE_HOME/vdirsyncer
VDIR_FEATURE="${VDIR_FEATURE_INITIAL}1"
if [ ! -e "$VDIR_FEATURE" ]; then
  start_feature "vdirsyncer" 

  sudo -H pip3 install requests requests_oauthlib || exit 1

  ## install
  sudo -H pip3 install git+https://github.com/untitaker/vdirsyncer.git || exit 1

  if [ ! -e $VDIR_FEATURE_INITIAL ]; then
    ## crontab
    install_cron "*/5 * * * *	$DOTFILES_LIB/vdirsyncer_cron.sh"
  fi

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
    stop_feature "davmail"
  else
    failed_feature "davmail remote zip"
  fi
  
  cd $PREV_DIR
fi

# lbdb - contact list for mutt
LBDB_FEATURE=$FEATURE_HOME/lbdb
if [ ! -e $LBDB_FEATURE ]; then
  start_feature "LBDB"
	sudo apt-get -y install lbdb
  RET=$?
  install_cron "1 */24 * * *" "$THE_HOME/.mutt/lib/refreshaddress.sh"
  # TODO build from github https://github.com/tgray/lbdb
  if [ $RET -ne 0 ]; then
    failed_feature "LBDB"
  else
    stop_feature "LBDB"
  fi
  touch $LBDB_FEATURE
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
  start_feature "offlineimap"
  PREV_DIR=`pwd`

  sudo apt-get -y remove offlineimap
  if [ ! -e $FEATURE ]; then
    install_cron "*/5 * * * *	$THE_HOME/dotfiles/lib/offlineimap_cron.sh"
  fi

  sudo -H pip2 install git+https://github.com/OfflineIMAP/offlineimap.git
  if [ $? -eq 0 ]; then
    touch $FEATURE_LATEST
  fi

  cd $PREV_DIR

  stop_feature "offlineimap"
fi

# stdman
# example man std::vector
STDMAN_FEATURE=$FEATURE_HOME/stdman
if [ ! -e $STDMAN_FEATURE ]; then
  start_feature "stdman"
  
  PREV_DIR=`pwd`

  STDMAN_ROOT=$GIT_SOURCES/stdman

  if [ ! -e $STDMAN_ROOT ]; then
    git clone https://github.com/jeaye/stdman.git $STDMAN_ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $STDMAN_ROOT
    fi
  fi

  if [ -e $STDMAN_ROOT ];then
    cd $STDMAN_ROOT
    git pull --rebase origin master

    if [ -e $STDMAN_ROOT ]; then

      sudo make uninstall
      ./configure

      if [ $? -eq 0 ];then
        make
        if [ $? -eq 0 ];then
          sudo make install
          if [ $? -eq 0 ];then
            sudo mandb
            if [ $? -eq 0 ];then
              touch $STDMAN_FEATURE
            fi
          fi
        fi
      fi
    fi
  fi

  stop_feature "stdman"

  cd $PREV_DIR
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

  CSOPE=csope
  CSOPE_VERSION=15.8b
  CSOPE_ROOT=$GIT_SOURCES/$CSOPE
  CSCOPE_TAR_PATH=$CSOPE_ROOT/$CSOPE.tar.gz
  TARGET=$CSOPE_ROOT/$CSOPE-$CSOPE_VERSION
  CSOPE_LATEST=$CSOPE_ROOT/$CSOPE-latest
  if [ -e ! $CSOPE_ROOT ]; then
    mkdir $CSOPE_ROOT
  fi

  if [ ! -e $TARGET ]; then
    wget -O $CSCOPE_TAR_PATH https://sourceforge.net/projects/cscope/files/$CSOPE/$CSOPE_VERSION/$CSOPE-$CSOPE_VERSION.tar.gz
    if [ $? -eq 0 ];then
      mkdir $TARGET
      tar -xzvf $CSCOPE_TAR_PATH -C $TARGET --strip-components=1
      if [ $? -eq 0 ];then
        cd $TARGET
        ./configure --prefix=/usr
        if [ $? -eq 0 ];then
          make
          if [ $? -eq 0 ];then
            CURRENT=`pwd`
            if [ -e $CSOPE_LATEST ];then
              # uninstall previous
              cd $CSOPE_LATEST
              sudo make uninstall
              cd $CURRENT
              rm -rf $CSOPE_LATEST
            fi
            sudo make install
            if [ $? -eq 0 ];then
              ln -s $TARGET $CSOPE_LATEST
              cscope --version
              touch $FEATURE
            fi
          fi
        fi
      fi
    fi
    if [ ! $? -eq 0 ]; then
      rm -rf $TARGET
    fi
    rm $CSCOPE_TAR_PATH
  fi

  cd $PREV_DIR

  stop_feature "cscope"
fi

# caps to escape
xmodmap -e "keycode 66 = Escape NoSymbol Escape"

#uninstall ctags
OLD_FEATURE=$FEATURE_HOME/ctags
if [ -e $OLD_FEATURE ]; then
  sudo apt-get -y remove ctags
  sudo apt-get -y autoremove
  rm $OLD_FEATURE
fi

# ctags
FEATURE=$FEATURE_HOME/ctags_universal2
if [ ! -e $FEATURE ]; then
  start_feature "ctags"

  PREV_DIR=`pwd`

  CTAGS=ctags
  CTAGS_ROOT=$GIT_SOURCES/$CTAGS
  if [ ! -e $CTAGS_ROOT ]; then
    git clone https://github.com/universal-ctags/$CTAGS.git $CTAGS_ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $CTAGS_ROOT
    fi
  fi
  if [ -e $CTAGS_ROOT ]; then
    cd $CTAGS_ROOT
    git pull --rebase origin master

    if [ $? -eq 0 ];then
      sudo make uninstall
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

  CPPCHECK=cppcheck
  CPPCHECK_ROOT=$GIT_SOURCES/$CPPCHECK
  if [ ! -e $CPPCHECK_ROOT ]; then
    git clone https://github.com/danmar/$CPPCHECK.git $CPPCHECK_ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $CPPCHECK_ROOT
    fi
  fi

  if [ -e $CPPCHECK_ROOT ];then
    cd $CPPCHECK_ROOT
    git pull --rebase origin master
    if [ $? -eq 0 ];then 
      cd $CPPCHECK
      if [ $? -eq 0 ];then 
          sudo make uninstall
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
  fi

  cd $PREV_DIR

  stop_feature "cppcheck"
fi

# libevent(tmux)
FEATURE=$FEATURE_HOME/libevent
if [ ! -e $FEATURE ]; then
  start_feature "libevent"

  PREV_DIR=`pwd`

  LIBEVENT=libevent
  LIBEVENT_ROOT=$GIT_SOURCES/$LIBEVENT

  if [ ! -e $LIBEVENT_ROOT ]; then
    git clone https://github.com/libevent/libevent.git $LIBEVENT_ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $LIBEVENT_ROOT
    fi
  fi

  if [ -e $LIBEVENT_ROOT ]; then
    cd $LIBEVENT_ROOT
    git pull --rebase origin master

    if [ $? -eq 0 ];then 
      sudo make uninstall
      ./configure
      if [ $? -eq 0 ];then 
        make
        if [ $? -eq 0 ];then 
          sudo make install
          if [ $? -eq 0 ];then 
            touch $FEATURE
          fi
        fi
      fi
    fi
  fi

  cd $PREV_DIR

  stop_feature "libevent"
fi

# tmux
FEATURE=$FEATURE_HOME/tmux2
if [ ! -e $FEATURE ]; then
  start_feature "tmux1"

  PREV_DIR=`pwd`

  TMUX=tmux
  TMUX_ROOT=$GIT_SOURCES/$TMUX

  if [ ! -e $TMUX_ROOT ]; then
    git clone https://github.com/tmux/$TMUX.git $TMUX_ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $TMUX_ROOT
    fi
  fi

  if [ -e $TMUX_ROOT ]; then
    cd $TMUX_ROOT
    git pull --rebase origin master

    if [ $? -eq 0 ];then 
      cd $TMUX
      sudo make uninstall
      ./autogen.sh

      if [ $? -eq 0 ];then 
        ./configure --prefix=/usr

        if [ $? -eq 0 ];then 
          make

          if [ $? -eq 0 ];then 
            # sudo apt-get -y remove tmux
            sudo make install

            if [ $? -eq 0 ];then 
              tmux -V
              touch $FEATURE
            fi
          fi
        fi
      fi
    fi
  fi

  cd $PREV_DIR

  stop_feature "tmux1"
fi

# less colors
FEATURE=$FEATURE_HOME/guake1
if [ ! -e $FEATURE ]; then
  start_feature "guake"

  PREV_DIR=`pwd`

  GUAKE_ROOT=$GIT_SOURCES/guake
  if [ ! -e $GUAKE_ROOT ]; then
    git clone https://github.com/Guake/guake.git $GUAKE_ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $GUAKE_ROOT
    fi
  fi

  if [ -e $GUAKE_ROOT ];then
    cd $GUAKE_ROOT

    git pull --rebase origin master

    if [ $? -eq 0 ];then
      ./autogen.sh

      if [ $? -eq 0 ];then
        ./configure

        if [ $? -eq 0 ];then 
          sudo make uninstall
          make

          if [ $? -eq 0 ];then 
            sudo make install

            if [ $? -eq 0 ];then 
              guake --help
              touch $FEATURE
            fi
          fi
        fi
      fi
    fi
  fi

  cd $PREV_DIR

  stop_feature "guake"
fi

# ranger
FEATURE=$FEATURE_HOME/ranger1
if [ ! -e $FEATURE ]; then
  start_feature "ranger"

  sudo apt-get -y remove ranger
  sudo -H pip2 install git+https://github.com/ranger/ranger.git
  if [ $? -eq 0 ]; then
    touch $FEATURE
  fi

  stop_feature "ranger"
fi

# less colors
FEATURE=$FEATURE_HOME/xclip
if [ ! -e $FEATURE ]; then
  start_feature "xclip"

  PREV_DIR=`pwd`

  XCLIP_ROOT=$GIT_SOURCES/xclip
  if [ ! -e $XCLIP_ROOT ]; then 
    git clone https://github.com/astrand/xclip.git $XCLIP_ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $XCLIP_ROOT
    fi
  fi

  if [ -e $XCLIP_ROOT ];then
    cd $XCLIP_ROOT
    git pull --rebase origin master
    sudo apt-get install libxcb-util-dev
    autoreconf
    if [ $? -eq 0 ];then 
      ./configure

      if [ $? -eq 0 ];then 
        sudo make uninstall
        make

        if [ $? -eq 0 ];then 
          sudo make install.man
          sudo make install

          if [ $? -eq 0 ];then 
            xclip -h
            touch $FEATURE
          fi
        fi
      fi
    fi
  fi

  cd $PREV_DIR

  stop_feature "xclip"
fi

# ensime scala vim support
FEATURE=$FEATURE_HOME/ensime
if [ ! -e $FEATURE ]; then
  start_feature "ensime"

  sudo -H pip2 install websocket-client sexpdata 


  touch $FEATURE
  stop_feature "ensime"
fi

sudo apt-get -y remove ack-grep
# grep optimized for code used by vim ack plugin
which ack-grep
if [ ! $? -eq 0 ]; then
  start_feature "ack"

  TEMP_DIR=`mktemp -d`
  ACK_SOURCE=$TEMP_DIR/ack-grep
  ACK_DESTINATION=/usr/bin/ack-grep
  curl http://beyondgrep.com/ack-2.14-single-file > $ACK_SOURCE
  if [ $? -eq 0 ];then
    chmod 0755 $ACK_SOURCE
    sudo chown root:root $ACK_SOURCE
    sudo mv $ACK_SOURCE $ACK_DESTINATION
  fi

  stop_feature "ack"
fi
# clipster cliboard manager
FEATURE=$FEATURE_HOME/clipster1
if [ ! -e $FEATURE ]; then
  start_feature "clipster"

  PREV_DIR=`pwd`
  
  CLIPSTER=clipster
  CLIPSTER_ROOT=$GIT_SOURCES/$CLIPSTER
  if [ ! -e $CLIPSTER_ROOT ]; then
    git clone https://github.com/mrichar1/clipster.git $CLIPSTER_ROOT || exit 1
    if [ ! $? -eq 0 ]; then
      rm -rf $CLIPSTER_ROOT
    fi
  fi

  if [ -e $CLIPSTER_ROOT ]; then
    cd $CLIPSTER_ROOT
    git pull --rebase origin master
    if [ $? -eq 0 ];then
      CLIPSTER_BIN=$USER_BIN/$CLIPSTER
      if [ ! -e $CLIPSTER_BIN ]; then
        ln -s $CLIPSTER_ROOT/$CLIPSTER $CLIPSTER_BIN
      fi
      systemctl enable --user clipster.service
      touch $FEATURE
    fi
  fi
  cd $PREV_DIR

  stop_feature "clipster"
fi

# jsonlint used by syntastic to check json
FEATURE=$FEATURE_HOME/jsonlint
if [ ! -e $FEATURE ]; then
  start_feature "jsonlint"

  JSONLINT=jsonlint
  NODE_LATEST=/opt/node-latest
  if [ -e $NODE_LATEST ];then
    sudo npm -g install $JSONLINT
    if [ $? -eq 0 ];then
      JSONLINT_BIN=$NODE_LATEST/bin/$JSONLINT
      JSONLINT_LINK=/opt/$JSONLINT
      sudo ln -s $JSONLINT_BIN $JSONLINT_LINK
      sudo update-alternatives --install /usr/bin/$JSONLINT $JSONLINT $JSONLINT_LINK 100
      if [ $? -eq 0 ];then
        touch $FEATURE
      fi
    fi
  else
    echo "NO $NODE_LATEST"
  fi

  stop_feature "jsonlint"
fi

# haskell enviornment
FEATURE=$FEATURE_HOME/haskell8
if [ ! -e $FEATURE ]; then
  start_feature "haskell8"

  PREV_DIR=`pwd`
  TEMP_DIR=`mktemp -d`
  cd $TEMP_DIR

  HASKELL_VERSION=8.0.1
  TAR=$TEMP_DIR/haskell-$HASKELL_VERSION.tar.gz
  wget -O $TAR https://haskell.org/platform/download/$HASKELL_VERSION/haskell-platform-$HASKELL_VERSION-unknown-posix--minimal-x86_64.tar.gz
  if [ $? -eq 0 ]; then
    tar xf $TAR
    if [ $? -eq 0 ]; then
      sudo ./install-haskell-platform.sh
      if [ $? -eq 0 ]; then
        touch $FEATURE
      fi
    fi
  fi

  stop_feature "haskell8"
fi

# global
FEATURE=$FEATURE_HOME/global
if [ ! -e $FEATURE ]; then
  start_feature "global"

  PREV_DIR=`pwd`
  GLOBAL_ROOT=$GIT_SOURCES/global
  GLOBAL_LATEST=$GLOBAL_ROOT/global-latest

  if [ ! -e $GLOBAL_ROOT ]; then
    mkdir $GLOBAL_ROOT
  fi
  VERSION=6.5.6
  TAR=$GLOBAL_ROOT/global-$VERSION.tar.gz
  TARGET=$GLOBAL_ROOT/global-$VERSION
  if [ ! -e $TARGET ]; then
    wget -O $TAR http://tamacom.com/global/global-$VERSION.tar.gz
    if [ $? -eq 0 ]; then
      mkdir $TARGET
      tar -xzvf $TAR -C $TARGET --strip-components=1
      if [ $? -eq 0 ]; then
        cd $TARGET
        ./configure
        if [ $? -eq 0 ];then
          make
          if [ $? -eq 0 ];then
            CURRENT=`pwd`
            if [ -e $GLOBAL_LATEST ]; then
              # uninstall previous
              cd $GLOBAL_LATEST
              sudo make uninstall
              cd $CURRENT
              rm -rf $GLOBAL_LATEST
            fi
            sudo make install
            if [ $? -eq 0 ]; then
              ln -s $TARGET $GLOBAL_LATEST 
              touch $FEATURE
            fi
          fi
        fi
      else
        rm -rf $TARGET
      fi
    fi
    rm $TAR
  fi

  cd $PREV_DIR
  stop_feature "global"
fi

# artistic style(primarly java formatter)
FEATURE=$FEATURE_HOME/artistic
if [ ! -e $FEATURE ]; then
  start_feature "artistic"

  NAME=astyle
  VERSION="2.06"
  NAME_VERSION="${NAME}_${VERSION}"
  ROOT=$SOURCES_ROOT/$NAME
  TARGET=$ROOT/$NAME_VERSION
  LATEST=$ROOT/$NAME-latest
  if [ ! -e $ROOT ];then
    mkdir $ROOT
  fi

  if [ ! -e $TARGET ]; then

    TAR_NAME="${NAME_VERSION}_linux.tar.gz"
    TAR=$ROOT/$TAR_NAME
    RET=1
        #https://sourceforge.net/projects/astyle/files/astyle/astyle%202.06/astyle_2.06_linux.tar.gz
    wget https://sourceforge.net/projects/astyle/files/astyle/astyle%20$VERSION/$TAR_NAME -O $TAR
    if [ $? -eq 0 ];then
      mkdir $TARGET
      tar -xzf $TAR -C $TARGET --strip-components=1
      if [ $? -eq 0 ];then 
        cd $TARGET/build/gcc
        if [ $? -eq 0 ]; then
          make
          if [ $? -eq 0 ]; then
            CURRENT=`pwd`
            if [ -e $LATEST ];then
              # uninstall previous
              cd $LATEST
              sudo make uninstall
              cd $CURRENT
              rm -rf $LATEST
            fi
            sudo make install
            if [ $? -eq 0 ];then
              RET=0
              ln -s $TARGET $LATEST
              echo "$NAME OK"
              touch $FEATURE
            fi
          fi
        fi
      fi
      if [ ! $RET -eq 0 ];then
        rm -rf $TARGET
      fi
      rm $TAR
    fi
  fi
  stop_feature "artistic"
fi

# tig - git terminal ncurses TUI
FEATURE=$FEATURE_HOME/tig
if [ ! -e $FEATURE ]; then
  start_feature "tig"

  PREV_DIR=`pwd`

  ROOT=$GIT_SOURCES/tig
  if [ ! -e $ROOT ]; then
    git clone https://github.com/jonas/tig.git $ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $ROOT
    fi
  fi

  if [ -e $ROOT ];then
    cd $ROOT

    git pull --rebase origin master

    if [ $? -eq 0 ];then
      ./autogen.sh

      if [ $? -eq 0 ];then
        ./configure --prefix=/usr/local

        if [ $? -eq 0 ];then
          make

          if [ $? -eq 0 ];then
            sudo make uninstall
            sudo make install

            if [ $? -eq 0 ];then
              tig --help
              touch $FEATURE
            fi
          fi
        fi
      fi
    fi
  fi

  cd $PREV_DIR

  stop_feature "tig"
fi

# qutebrowser - browser with vim like binding
FEATURE=$FEATURE_HOME/qutebrowser
if [ ! -e $FEATURE ]; then
  start_feature "qutebrowser"

  sudo apt-get -y install python3-lxml python-tox python3-pyqt5 python3-pyqt5.qtwebkit
  sudo apt-get -y install python3-pyqt5.qtquick python3-sip python3-jinja2 python3-pygments python3-yaml

  #TODO install

  stop_feature "qutebrowser"
fi

# mpv video player
which mpv
if [ ! $? -eq 0 ];then
  sudo add-apt-repository -y ppa:mc3man/mpv-tests
  sudo apt-get update
  sudo apt-get -y install mpv
fi
# allows mpv to download and play youtube videos
sudo apt install youtube-dl

## less colors
# FEATURE=$FEATURE_HOME/lesscolors
# if [ ! -e $FEATURE ]; then
#   start_feature "lesscolors"
#
#
#   touch $FEATURE
#   stop_feature "lesscolors"
# fi
