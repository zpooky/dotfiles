#!/bin/bash

source $HOME/dotfiles/shared.sh

# INSTALL_PREFIX=/usr/local
INSTALL_PREFIX=$HOME/.local
if [ ! -e $INSTALL_PREFIX ]; then
  mkdir $INSTALL_PREFIX || exit 1
fi

# tig - git terminal ncurses TUI
PACKAGE_NAME=tig
FEATURE=$FEATURE_HOME/$PACKAGE_NAME
if [ ! -e $FEATURE ]; then
  start_feature "$PACKAGE_NAME"

  is_arch
  if [ $? -eq 0 ]; then
    has_feature "tig"
    if [[ $? -eq 1 ]]; then
      install tig || exit 1
    fi

    if [ $? -eq 0 ]; then
      # tig --help
      touch $FEATURE
    fi
  else
    PREV_DIR=`pwd`

    ROOT=$GIT_SOURCES/$PACKAGE_NAME
    if [ ! -e $ROOT ]; then
      git clone https://github.com/jonas/$PACKAGE_NAME.git $ROOT
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
          ./configure --prefix=$INSTALL_PREFIX

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

# # artistic style(primarly java formatter)
# FEATURE=$FEATURE_HOME/artistic
# if [ ! -e $FEATURE ]; then
#   start_feature "artistic"
#
#   NAME=astyle
#   VERSION="2.06"
#   NAME_VERSION="${NAME}_${VERSION}"
#   ROOT=$SOURCES_ROOT/$NAME
#   TARGET=$ROOT/$NAME_VERSION
#   LATEST=$ROOT/$NAME-latest
#   if [ ! -e $ROOT ]; then
#     mkdir $ROOT
#   fi
#
#   if [ ! -e $TARGET ]; then
#
#     TAR_NAME="${NAME_VERSION}_linux.tar.gz"
#     TAR=$ROOT/$TAR_NAME
#     RET=1
#         #https://sourceforge.net/projects/astyle/files/astyle/astyle%202.06/astyle_2.06_linux.tar.gz
#     wget https://sourceforge.net/projects/astyle/files/astyle/astyle%20$VERSION/$TAR_NAME -O $TAR
#     if [ $? -eq 0 ]; then
#       mkdir $TARGET
#       tar -xzf $TAR -C $TARGET --strip-components=1
#       if [ $? -eq 0 ]; then 
#         cd $TARGET/build/gcc
#         if [ $? -eq 0 ]; then
#           make
#           if [ $? -eq 0 ]; then
#             CURRENT=`pwd`
#             if [ -e $LATEST ]; then
#               # uninstall previous
#               cd $LATEST
#               sudo make uninstall
#               cd $CURRENT
#               rm -rf $LATEST
#             fi
#             sudo make install
#             if [ $? -eq 0 ]; then
#               RET=0
#               ln -s $TARGET $LATEST
#               echo "$NAME OK"
#               touch $FEATURE
#             fi
#           fi
#         fi
#       fi
#       if [ ! $RET -eq 0 ]; then
#         rm -rf $TARGET
#       fi
#       rm $TAR
#     fi
#   fi
#   stop_feature "artistic"
# fi

# GNU global
FEATURE=$FEATURE_HOME/global
if [ ! -e $FEATURE ]; then
  start_feature "global"

  is_arch
  if [ $? -eq 0 ]; then
    has_feature global
    if [[ $? -eq 1 ]]; then
      # install global || exit 1
      echo ""
    fi
  else
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
          ./configure --prefix=$INSTALL_PREFIX
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
  fi

  stop_feature "global"
fi

# grep optimized for code used by vim ack plugin
has_feature ack-grep
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
    has_feature ack
    if [[ $? -eq 1 ]]; then
      install ack || exit 1
    fi
  fi

  stop_feature "ack"
fi

# jsonlint used by syntastic to check json
# TODO
# FEATURE=$FEATURE_HOME/jsonlint
# if [ ! -e $FEATURE ]; then
#   start_feature "jsonlint"
#
#   JSONLINT=jsonlint
#   NODE_LATEST=/opt/node-latest
#   if [ -e $NODE_LATEST ]; then
#     sudo npm -g install $JSONLINT
#     if [ $? -eq 0 ]; then
#       JSONLINT_BIN=$NODE_LATEST/bin/$JSONLINT
#       JSONLINT_LINK=/opt/$JSONLINT
#       sudo ln -s $JSONLINT_BIN $JSONLINT_LINK
#       sudo update-alternatives --install /usr/bin/$JSONLINT $JSONLINT $JSONLINT_LINK 100
#       if [ $? -eq 0 ]; then
#         touch $FEATURE
#       fi
#     fi
#   else
#     echo "NO $NODE_LATEST"
#   fi
#
#   stop_feature "jsonlint"
# fi

# ranger
# TODO
# FEATURE=$FEATURE_HOME/ranger1
# if [ ! -e $FEATURE ]; then
#   start_feature "ranger"
#
#   pip2_install git+https://github.com/ranger/ranger.git
#   if [ $? -eq 0 ]; then
#     touch $FEATURE
#   fi
#
#   stop_feature "ranger"
# fi

# guake
FEATURE=$FEATURE_HOME/guake1
if [ ! -e $FEATURE ]; then
  start_feature "guake"

  is_arch
  if [ $? -eq 0 ]; then
    has_feature guake
    if [[ $? -eq 1 ]]; then
      install guake || exit 1
    fi
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

STYLEISH_HASKELL=stylish-haskell
has_feature $STYLEISH_HASKELL
if [ $? -eq 1 ]; then
  cabal update
  cabal install $STYLEISH_HASKELL
fi

# should update powerline settings and scripts
LIB_ROOTS=("/lib" "/usr/lib" "/usr/local/lib")
for LIB_ROOT in "${LIB_ROOTS[@]}"
do
  PYTHON_VERSION=("python2.7" "python2.8" "python2.9" "python3.6" "python3.7" "python3.8")
  for PYTHON in "${PYTHON_VERSION[@]}"
  do
    PACKAGES=("dist-packages" "site-packages")
    for PACKAGE in "${PACKAGES[@]}"
    do
      # install powerline tmux segments
      POWERLINE_SEGMENTS="${LIB_ROOT}/${PYTHON}/${PACKAGE}/powerline/segments"

      if [ -e "${POWERLINE_SEGMENTS}" ]; then
        sudo cp "${THE_HOME}/.config/powerline/segments/spooky" "${POWERLINE_SEGMENTS}" -R
      fi
    done
  done
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
      ./configure --prefix=$INSTALL_PREFIX

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
  if [[ $KERNEL_VERSION != ^3.* ]]; then
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

  is_apt_get
  if [ $? -eq 0 ]; then
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
  fi

  stop_feature "mega"
fi

# csope bin. install to /usr/bin
FEATURE=$FEATURE_HOME/cscope
if [ ! -e $FEATURE ]; then
  start_feature "cscope"

  is_arch
  if [ $? -eq 0 ]; then
    echo ""
  else
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
  fi

  stop_feature "cscope"
fi

# ctags
FEATURE=$FEATURE_HOME/ctags_universal2
if [ ! -e $FEATURE ]; then
  start_feature "ctags"

  is_arch
  if [ $? -eq 0 ]; then
    echo ""
  else
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
  fi

  stop_feature "ctags"
fi

# cppcheck
FEATURE=$FEATURE_HOME/cppcheck1
if [ ! -e $FEATURE ]; then
  start_feature "cppcheck"

  is_arch
  if [ $? -eq 0 ]; then
    has_feature cppcheck
    if [[ $? -eq 1 ]]; then
      install cppcheck
    fi
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

#python format
pip2_install git+https://github.com/google/yapf.git

# code formatters
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

# haskell enviornment
FEATURE=$FEATURE_HOME/haskell8
if [ ! -e $FEATURE ]; then
  start_feature "haskell8"

  is_arch
  if [ $? -eq 0 ]; then
    echo ""
  else
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
  fi

  stop_feature "haskell8"
fi

