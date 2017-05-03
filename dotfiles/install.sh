#!/bin/bash

source $HOME/dotfiles/shared.sh

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
start_feature "git submodules"
git submodule sync --recursive
# recursivly pull in all submodule repos
git submodule update --init --recursive --remote
git submodule update --init --recursive

stop_feature "git submodules"
start_feature "vim"

VIM_AUTOLOAD=$THE_HOME/.vim/autoload
if [ ! -e $VIM_AUTOLOAD ]; then
  mkdir $VIM_AUTOLOAD
fi

PATHOGEN_AUTLOAD=$VIM_AUTOLOAD/pathogen.vim
if [ -e $PATHOGEN_AUTLOAD ]; then
  rm -rf $THE_HOME/.pathogen
  rm $PATHOGEN_AUTLOAD
fi

VIM_PLUG=$GIT_SOURCES/vim-plug/plug.vim
VIM_PLUG_TARGET=$VIM_AUTOLOAD/plug.vim
if [ ! -e $VIM_PLUG_TARGET ]; then
  ln -s $VIM_PLUG $VIM_PLUG_TARGET
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
    if [ $RET -eq 0 ]; then
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
  COLOR_CODED_PATH=$THE_HOME/.vim/bundle/color_coded 
  COLOR_CODED_BUILD_PATH=$COLOR_CODED_PATH/build
  cd $COLOR_CODED_PATH
  if [ -d $COLOR_CODED_BUILD_PATH ]; then
    rm -rf $COLOR_CODED_BUILD_PATH
  fi
  mkdir build && cd build || exit 1
  cmake ..
  if [ $? -eq 0 ]; then 
    make && make install
    RET=$?

      # Cleanup afterward; frees several hundred megabytes
      make clean && make clean_clang

    if [ $RET -eq 0 ]; then 
      touch $FEATURE
    fi
  fi

  cd $PREV_DIR

  stop_feature "color_coded1"
fi

# bashrc
BASHRC_FEATURE=$FEATURE_HOME/bashrc
if [ ! -e $BASHRC_FEATURE ]; then
  start_feature "bashrc"

  echo 'source ~/dotfiles/extrarc' >> ~/.bashrc

  touch $BASHRC_FEATURE
  stop_feature "bashrc"
fi

# .inputrc is the start-up file used by readline, the input related library used by bash and most other shells
DOTFILES_INPUTRC=$THE_HOME/dotfiles/inputrc
if [[ $(uname -s) =~ CYGWIN.* ]]; then
  echo '
# make ctrl+left/right navigate word by word
# default is not setup in cygwin
# ctrl + right
"\e[1;5C": forward-word
# ctrl + left
"\e[1;5D": backward-word

# shift+insert - paste
' > $DOTFILES_INPUTRC
else
  touch $DOTFILES_INPUTRC
fi

start_feature "update tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins
stop_feature "update tmux plugins"


echo "Enter sudo password"
sudo echo "start" || exit 1

# pip3

# update
start_feature "update pip"

#python3
install python || exit 1
install python-pip || exit 1

pip3_install --upgrade pip || exit 1
pip3_install keyring || exit 1

# pdftotext
install poppler
install poppler-util
install colordiff

install gnome-common
install gtk-doc-tool
install libglib2.0-de
install libgtk2.0-dev
install python-gtk
install python-gtk2-de
install python-vt
install glad
install python-glade2
install libgconf2-de
install python-appindicator
install python-vt
install python-gcon
install python-keybinder
install notify-osd
install libutempter0
install python-notify

stop_feature "update pip"
# apps

start_feature "apt-get update"
update_package_list

start_feature "apt-get install python"

install python-sqlite || exit 1
install python-vobject || exit 1
install python-gnomekeyring || exit 1
install python-dev || exit 1

start_feature "apt-get install tools"
install htop || exit 1
install rake || exit 1
install wget || exit 1
install curl || exit 1
# text terminal web browser
install ncurses-term || exit 1
install sqlite3 || exit 1
install sed || exit 1
install autoconf || exit 1

# xterm-256color support
install ncurses-term || exit 1
# for archives text
install atool || exit 1
# for syntax highlighting. text ranger
install highlight || exit 1
# for media file information.
install mediainfo || exit 1
install transmission-cli || exit 1


install libncurses5-de
install libgnome2-de
install libgnomeui-de
install libgtk2.0-de
install libatk1.0-de
install libbonoboui2-dev
install libcairo2-de
install libx11-de
install libxpm-de
install libxt-de
install python-dev

# vim things
install build-essential
install libclang-3.9-dev
install libncurses-dev
install libz-dev
install xz-utils
install libpthread-workqueue-dev
LUA_VIM_MINOR_VERSION=`vim --version | grep "\-llua" | sed -r "s/.*\-llua5.([0-9]*).*/\1/"`
install liblua5.$LUA_VIM_MINOR_VERSION-dev
install lua5.$LUA_VIM_MINOR_VERSION

start_feature "apt-get install libs"
install openssl || exit 1

start_feature "apt-get install gnu stuff"
# The package libreadline is for running applications using readline command
# and the package libreadline-dev is for compiling and building readline application.
install libreadline
install libreadline6-dev || exit 1

start_feature "apt-get install cpp stuff"
# cpp
install clang || exit 1
install cmake || exit 1
#TODO assert cmake version is greater than 2.8

start_feature "apt-get install perf"
install linux-tools-commo
install linux-tools-generi
install linux-tools-`uname -r` || exit 1

start_feature "pip install cpp"
pip3_install cpplint || exit 1

stop_feature "apt-get install"

start_feature "standalone"
install vlc
#newsbeuter 2.9
install newsbeuter
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
  is_arch
  if [ $? -eq 0 ]; then
    install python2-pip
  else
    # python2 -m pip uninstall pip setuptools
    PREV_DIR=`pwd`

    cd /tmp
    curl -O https://bootstrap.pypa.io/get-pip.py

    if [ $? -eq 0 ]; then
      sudo -H  python2.7 get-pip.py
    fi

    cd $PREV_DIR
  fi
fi
pip2_install --upgrade pip || exit 1

# mutt url viewer
pip2_install urlscan


#python format
pip2_install git+https://github.com/google/yapf.git
#python import sort
# pip2_install git+https://github.com/timothycrosley/isort.git
which npm
if [ $? -eq 0 ]; then
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
if [ ! $? -eq 0 ]; then
  cabal update
  cabal install $STYLEISH_HASKELL
fi

# should update powerline settings and scripts
PYTHON_PACKAGES=("${LIB_PYTHON2_PACKAGES}" "${LIB_PYTHON3_PACKAGES}")
for PACKAGES in "${PYTHON_PACKAGES[@]}"
do
  # install powerline tmux segments
  POWERLINE_SEGMENTS="${PACKAGES}/powerline/segments"
  if [ -e "${POWERLINE_SEGMENTS}" ]; then
   sudo cp "${THE_HOME}/.config/powerline/segments/spooky" "${POWERLINE_SEGMENTS}" -R
  fi
done

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

  if [ -e $STDMAN_ROOT ]; then
    cd $STDMAN_ROOT
    git pull --rebase origin master

    if [ -e $STDMAN_ROOT ]; then

      sudo make uninstall
      ./configure

      if [ $? -eq 0 ]; then
        make
        if [ $? -eq 0 ]; then
          sudo make install
          if [ $? -eq 0 ]; then
            sudo mandb
            if [ $? -eq 0 ]; then
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

     is_apt_get
     if [ $? -eq 0 ]; then
       # https://github.com/iovisor/bcc/blob/master/INSTALL.md
       echo "deb [trusted=yes] https://repo.iovisor.org/apt/xenial xenial-nightly main" | sudo tee /etc/apt/sources.list.d/iovisor.list
       update_package_list
     fi
     install bcc-tools

     if [ $? -eq 0 ]; then
       touch $BCC_FEATURE
     fi
     stop_feature "bcc"
  fi
fi

# keepass
FEATURE=$FEATURE_HOME/keepass1
if [ ! -e $FEATURE ]; then
  start_feature "keepass"

  is_apt_get
  if [ $? -eq 0 ]; then
    sudo apt-add-repository -y ppa:jtaylor/keepass
    sudo apt-get update
  fi
  install keepass2

  if [ $? -eq 0 ]; then
    touch $FEATURE
  fi
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

  if [ $? -eq 0 ]; then
    install libcrypto++9
    if [ $? -eq 0 ]; then
      sudo dpkg -y -i $MEGA_DEB
        if [ $? -eq 0 ]; then
          touch $FEATURE
        fi
    fi
  fi

  stop_feature "mega"
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
    if [ $? -eq 0 ]; then
      mkdir $TARGET
      tar -xzvf $CSCOPE_TAR_PATH -C $TARGET --strip-components=1
      if [ $? -eq 0 ]; then
        cd $TARGET
        ./configure --prefix=/usr
        if [ $? -eq 0 ]; then
          make
          if [ $? -eq 0 ]; then
            CURRENT=`pwd`
            if [ -e $CSOPE_LATEST ]; then
              # uninstall previous
              cd $CSOPE_LATEST
              sudo make uninstall
              cd $CURRENT
              rm -rf $CSOPE_LATEST
            fi
            sudo make install
            if [ $? -eq 0 ]; then
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

    if [ $? -eq 0 ]; then
      sudo make uninstall
      ./autogen.sh

      if [ $? -eq 0 ]; then
        ./configure --prefix=/usr/local

        if [ $? -eq 0 ]; then
          make
          if [ $? -eq 0 ]; then
            sudo make install
            if [ $? -eq 0 ]; then
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

  is_arch
  if [ $? -eq 0 ]; then
    install cppcheck
  else
    PREV_DIR=`pwd`

    CPPCHECK=cppcheck
    CPPCHECK_ROOT=$GIT_SOURCES/$CPPCHECK
    if [ ! -e $CPPCHECK_ROOT ]; then
      git clone https://github.com/danmar/$CPPCHECK.git $CPPCHECK_ROOT
      if [ ! $? -eq 0 ]; then
        rm -rf $CPPCHECK_ROOT
      fi
    fi

    if [ -e $CPPCHECK_ROOT ]; then
      cd $CPPCHECK_ROOT
      git pull --rebase origin master
      if [ $? -eq 0 ]; then
        cd $CPPCHECK
        if [ $? -eq 0 ]; then
            sudo make uninstall
            make
          if [ $? -eq 0 ]; then
            sudo make install
            if [ $? -eq 0 ]; then
              cppcheck --version
              touch $FEATURE
            fi
          fi
        fi
      fi
    fi

    cd $PREV_DIR
  fi

  stop_feature "cppcheck"
fi

# guake
FEATURE=$FEATURE_HOME/guake1
if [ ! -e $FEATURE ]; then
  start_feature "guake"

  is_arch
  if [ $? -eq 0 ]; then
    install guake
  else
    PREV_DIR=`pwd`

    GUAKE_ROOT=$GIT_SOURCES/guake
    if [ ! -e $GUAKE_ROOT ]; then
      git clone https://github.com/Guake/guake.git $GUAKE_ROOT
      if [ ! $? -eq 0 ]; then
        rm -rf $GUAKE_ROOT
      fi
    fi

    if [ -e $GUAKE_ROOT ]; then
      cd $GUAKE_ROOT

      git pull --rebase origin master

      if [ $? -eq 0 ]; then
        ./autogen.sh

        if [ $? -eq 0 ]; then
          ./configure

          if [ $? -eq 0 ]; then
            sudo make uninstall
            make

            if [ $? -eq 0 ]; then
              sudo make install

              if [ $? -eq 0 ]; then
                guake --help
                touch $FEATURE
              fi
            fi
          fi
        fi
      fi
    fi

    cd $PREV_DIR
  fi

  stop_feature "guake"
fi

# ranger
FEATURE=$FEATURE_HOME/ranger1
if [ ! -e $FEATURE ]; then
  start_feature "ranger"

  pip2_install git+https://github.com/ranger/ranger.git
  if [ $? -eq 0 ]; then
    touch $FEATURE
  fi

  stop_feature "ranger"
fi

# ensime scala vim support
FEATURE=$FEATURE_HOME/ensime
if [ ! -e $FEATURE ]; then
  start_feature "ensime"

  pip2_install websocket-client sexpdata 
  if [ $? -eq 0 ]; then
    touch $FEATURE
  fi

  stop_feature "ensime"
fi

# grep optimized for code used by vim ack plugin
which ack-grep
if [ ! $? -eq 0 ]; then
  start_feature "ack"

  is_apt_get
  if [ $? -eq 0 ]; then
    # manually install it because why not
    TEMP_DIR=`mktemp -d`
    ACK_SOURCE=$TEMP_DIR/ack-grep
    ACK_DESTINATION=/usr/bin/ack-grep
    curl http://beyondgrep.com/ack-2.14-single-file > $ACK_SOURCE
    if [ $? -eq 0 ]; then
      chmod 0755 $ACK_SOURCE
      sudo chown root:root $ACK_SOURCE
      sudo mv $ACK_SOURCE $ACK_DESTINATION
    fi
  else
    install -S ack
  fi

  stop_feature "ack"
fi

# jsonlint used by syntastic to check json
FEATURE=$FEATURE_HOME/jsonlint
if [ ! -e $FEATURE ]; then
  start_feature "jsonlint"

  JSONLINT=jsonlint
  NODE_LATEST=/opt/node-latest
  if [ -e $NODE_LATEST ]; then
    sudo npm -g install $JSONLINT
    if [ $? -eq 0 ]; then
      JSONLINT_BIN=$NODE_LATEST/bin/$JSONLINT
      JSONLINT_LINK=/opt/$JSONLINT
      sudo ln -s $JSONLINT_BIN $JSONLINT_LINK
      sudo update-alternatives --install /usr/bin/$JSONLINT $JSONLINT $JSONLINT_LINK 100
      if [ $? -eq 0 ]; then
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
        if [ $? -eq 0 ]; then
          make
          if [ $? -eq 0 ]; then
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
  if [ ! -e $ROOT ]; then
    mkdir $ROOT
  fi

  if [ ! -e $TARGET ]; then

    TAR_NAME="${NAME_VERSION}_linux.tar.gz"
    TAR=$ROOT/$TAR_NAME
    RET=1
        #https://sourceforge.net/projects/astyle/files/astyle/astyle%202.06/astyle_2.06_linux.tar.gz
    wget https://sourceforge.net/projects/astyle/files/astyle/astyle%20$VERSION/$TAR_NAME -O $TAR
    if [ $? -eq 0 ]; then
      mkdir $TARGET
      tar -xzf $TAR -C $TARGET --strip-components=1
      if [ $? -eq 0 ]; then 
        cd $TARGET/build/gcc
        if [ $? -eq 0 ]; then
          make
          if [ $? -eq 0 ]; then
            CURRENT=`pwd`
            if [ -e $LATEST ]; then
              # uninstall previous
              cd $LATEST
              sudo make uninstall
              cd $CURRENT
              rm -rf $LATEST
            fi
            sudo make install
            if [ $? -eq 0 ]; then
              RET=0
              ln -s $TARGET $LATEST
              echo "$NAME OK"
              touch $FEATURE
            fi
          fi
        fi
      fi
      if [ ! $RET -eq 0 ]; then
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

  is_arch
  if [ $? -eq 0 ]; then
    install tig
  else
    PREV_DIR=`pwd`

    ROOT=$GIT_SOURCES/tig
    if [ ! -e $ROOT ]; then
      git clone https://github.com/jonas/tig.git $ROOT
      if [ ! $? -eq 0 ]; then
        rm -rf $ROOT
      fi
    fi

    if [ -e $ROOT ]; then
      cd $ROOT

      git pull --rebase origin master

      if [ $? -eq 0 ]; then
        ./autogen.sh

        if [ $? -eq 0 ]; then
          ./configure --prefix=/usr/local

          if [ $? -eq 0 ]; then
            make

            if [ $? -eq 0 ]; then
              sudo make uninstall
              sudo make install

              if [ $? -eq 0 ]; then
                tig --help
                touch $FEATURE
              fi
            fi
          fi
        fi
      fi
    fi
    cd $PREV_DIR
  fi

  stop_feature "tig"
fi

# qutebrowser - browser with vim like binding
FEATURE=$FEATURE_HOME/qutebrowser
if [ ! -e $FEATURE ]; then
  start_feature "qutebrowser"

  is_arch
  if [ $? -eq 0 ]; then
    pacman -S qutebrowser
    touch $FEATURE
  else
    install python3-lxml python-tox python3-pyqt5 python3-pyqt5.qtwebkit
    install python3-pyqt5.qtquick python3-sip python3-jinja2 python3-pygments python3-yaml

    #TODO install
  fi
  stop_feature "qutebrowser"
fi

# mpv video player
which mpv
if [ ! $? -eq 0 ]; then
  is_apt_get
  if [ $? -eq 0 ]; then
    sudo add-apt-repository -y ppa:mc3man/mpv-tests
    update_package_list
  fi
  install mpv
fi
# allows mpv to download and play youtube videos
install youtube-dl

GDB_PP=$SOURCES_ROOT/gdb_pp
if [ ! -e $GDB_PP ]; then
  svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python $GDB_PP
  if [ ! $? -eq 0 ]; then
    rm -rf $GDB_PP
  fi
fi

## less colors
# FEATURE=$FEATURE_HOME/lesscolors
# if [ ! -e $FEATURE ]; then
#   start_feature "lesscolors"
#
#
#   touch $FEATURE
#   stop_feature "lesscolors"
# fi
