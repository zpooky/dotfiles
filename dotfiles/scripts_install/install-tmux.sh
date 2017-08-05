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
  echo "##############################libevent"

  PREV_DIR=`pwd`

  LIBEVENT=libevent
  LIBEVENT_ROOT=$GIT_SOURCES/$LIBEVENT

  if [ ! -e $LIBEVENT_ROOT ]; then
    git clone https://github.com/libevent/libevent.git $LIBEVENT_ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $LIBEVENT_ROOT
      echo "failed to clone libevent"
      cd $PREV_DIR
      exit 1
    fi
  fi

  if [ -e $LIBEVENT_ROOT ]; then
    cd $LIBEVENT_ROOT
    git pull --rebase origin master
    if [ ! $? -eq 0 ]; then
      echo "failed to pull libevent"
      cd $PREV_DIR
      exit 1
    fi

    if [ $? -eq 0 ]; then
      sudo make uninstall
      ./autogen.sh
      if [ $? -eq 0 ]; then
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
  fi

  cd $PREV_DIR
fi

# tmux
FEATURE=$FEATURE_HOME/tmux2_5
if [ ! -e $FEATURE ]; then
  echo "##############################TMUX"
  PREV_DIR=`pwd`

  TMUX=tmux
  TMUX_ROOT=$GIT_SOURCES/$TMUX

  if [ ! -e $TMUX_ROOT ]; then
    git clone https://github.com/tmux/$TMUX.git $TMUX_ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $TMUX_ROOT
      echo "failed to clone tmux"
      cd $PREV_DIR
      exit 1
    fi
  fi

  if [ -e $TMUX_ROOT ]; then
    cd $TMUX_ROOT
    git checkout master
    if [ $? -ne 0 ]; then
      echo "failed to checkout tmux master"
      cd $PREV_DIR
      exit 1
    fi

    git pull
    if [ $? -ne 0 ]; then
      echo "failed to pull tmux"
      cd $PREV_DIR
      exit 1
    fi

    git checkout 2.5
    if [ $? -ne 0 ]; then
      echo "failed to checkout tmux target branch"
      cd $PREV_DIR
      exit 1
    fi

    if [ $? -eq 0 ]; then
      cd $TMUX
      sudo make uninstall
      ./autogen.sh

      if [ $? -eq 0 ]; then 
        ./configure --prefix=/usr/local

        if [ $? -eq 0 ]; then 
          make

          if [ $? -eq 0 ]; then 
            #  apt-get -y remove tmux
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
