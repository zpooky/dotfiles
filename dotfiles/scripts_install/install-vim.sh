
#!/bin/bash

# ~/vim/src/Makefile
# TODO 1 sed -i /prefix = $(HOME)

# TODO 2 add ~/bin to path


echo "you have to manually configure script by editing it"
#exit 1
PREV=`pwd`
VIM_ROOT=$HOME/sources/vim
TARGET=/usr/local
if [ ! -e $VIM_ROOT ]; then 
  git clone https://github.com/vim/vim.git $VIM_ROOT
  if [ ! $? -eq 0 ];then
    rm -rf $VIM_ROOT
  fi
fi
if [ -e $VIM_ROOT ]; then 
  cd $VIM_ROOT
  git pull --rebase origin master || exit 1

  make clean || exit 1
  # make uninstall --prefix=/home/`whoami`
  ./configure --with-features=huge --enable-multibyte --enable-rubyinterp --enable-pythoninterp --enable-luainterp --enable-gui=gtk2 --enable-cscope --prefix=$TARGET || exit 1

  make || exit 1 # VIMRUNTIMEDIR=/usr/share/vim/vim74

  sudo make install || exit 1

  vim --version | grep python

  cd $PREV
  echo "OK"
  echo "OK"
  echo "OK"
else
  echo "FAILED"
  echo "FAILED"
  echo "FAILED"
fi
