#!/bin/bash

source $HOME/dotfiles/shared.sh

# powerline
FEATURE=$FEATURE_HOME/powerline1
if [ ! -e $FEATURE ]; then
  is_arch
  if [ $? -eq 0 ]; then
    install python2-powerline
    install python-powerline
    install powerline-fonts
    install powerline
    install powerline-common
  else
    # http://askubuntu.com/questions/283908/how-can-i-install-and-use-powerline-plugin
    # TODO add system wide font install base on answer above

    PREV_DIR=`pwd`

    pip2_install powerline-status
    RET=$?
    if [ $RET -eq 0 ]; then

      FONTS_DIR=$THE_HOME/.fonts
      if [ ! -e $FONTS_DIR ]; then
        mkdir $FONTS_DIR
      fi

      POWERLINE_FONT=$FONTS_DIR/PowerlineSymbols.otf
      if [ ! -e $POWERLINE_FONT ]; then
        cd $FONTS_DIR

        wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf
        RET=$?

        fc-cache -vf $FONTS_DIR || exit 1
      fi
      if [ $RET -eq 0 ]; then
        FONTCONFIG_DIR=$THE_HOME/.config/fontconfig/conf.d
        if [ ! -e $FONTCONFIG_DIR ]; then
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
  fi
fi

