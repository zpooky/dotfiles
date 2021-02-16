#!/bin/bash

source $HOME/dotfiles/shared.sh

# pipe to/from clipboard
FEATURE=$FEATURE_HOME/xclip
if [ ! -e $FEATURE ]; then
  start_feature "xclip"

  if has_feature pacman; then
    install xclip
    if [ $? -eq 0 ];then
      touch $FEATURE
    fi

  else
    PREV_DIR=`pwd`

    XCLIP_ROOT="${GIT_SOURCES}/xclip"
    if [ ! -e $XCLIP_ROOT ]; then 
      git clone https://github.com/astrand/xclip.git $XCLIP_ROOT
      if [ ! $? -eq 0 ]; then
        rm -rf $XCLIP_ROOT
      fi
    fi

    if [ -e $XCLIP_ROOT ];then
      cd $XCLIP_ROOT
      git pull --rebase origin master
      install libxcb-util-dev
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
  fi
  stop_feature "xclip"
fi

# clipster cliboard manager
FEATURE=$FEATURE_HOME/clipster
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
      if [ $? -eq 0 ]; then
        touch $FEATURE
      fi

    fi
  fi
  cd $PREV_DIR

  stop_feature "clipster"
fi
