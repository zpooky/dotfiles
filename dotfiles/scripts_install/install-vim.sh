
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

  # development files
  sudo apt-get -y install ruby-dev
  sudo apt-get -y install python-dev
  sudo apt-get -y install libperl-dev

  # make uninstall --prefix=/home/`whoami`
  sudo make uninstall

  make clean || exit 1
  ./configure --with-features=huge --enable-rubyinterp --enable-multibyte --enable-perlinterp=yes --enable-pythoninterp --enable-luainterp --enable-gui=gtk2 --enable-cscope --prefix=$TARGET || exit 1

  make || exit 1 # VIMRUNTIMEDIR=/usr/share/vim/vim74

  sudo make install || exit 1

  vim --version | grep python

  echo "OK"
  echo "OK"
  echo "OK"
else
  echo "FAILED"
  echo "FAILED"
  echo "FAILED"
fi

cd $PREV
