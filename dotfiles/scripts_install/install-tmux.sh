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

# libevent(tmux)
FEATURE=$FEATURE_HOME/libevent
if [ ! -e $FEATURE ]; then

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

    if [ $? -eq 0 ]; then
      sudo make uninstall
      ./configure
      if [ $? -eq 0 ]; then
        make
        if [ $? -eq 0 ]; then
          sudo make install
          if [ $? -eq 0 ]; then
            touch $FEATURE
          fi
        fi
      fi
    fi
  fi

  cd $PREV_DIR
fi

# tmux
FEATURE=$FEATURE_HOME/tmux2
if [ ! -e $FEATURE ]; then
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
    git checkout master
    git pull --rebase origin master
    git checkout 2.3

    if [ $? -eq 0 ]; then 
      cd $TMUX
      sudo make uninstall
      ./autogen.sh

      if [ $? -eq 0 ]; then 
        ./configure --prefix=/usr

        if [ $? -eq 0 ]; then 
          make

          if [ $? -eq 0 ]; then 
            # sudo apt-get -y remove tmux
            sudo make install

            if [ $? -eq 0 ]; then 
              tmux -V
              touch $FEATURE
            fi
          fi
        fi
      fi
    fi
  fi

  cd $PREV_DIR
fi
