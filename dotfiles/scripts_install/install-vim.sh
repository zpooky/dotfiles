
#!/bin/bash

# ~/vim/src/Makefile
# TODO 1 sed -i /prefix = $(HOME)

# TODO 2 add ~/bin to path

$HOME/dotfiles/shared.sh

echo "you have to manually configure script by editing it"
PREV=`pwd`
VIM_ROOT=$HOME/sources/vim
TARGET=$HOME
if [ ! -e $VIM_ROOT ]; then 
  git clone https://github.com/vim/vim.git $VIM_ROOT
  if [ ! $? -eq 0 ]; then
    rm -rf $VIM_ROOT
  fi
fi
# exit 1

if [ -e $VIM_ROOT ]; then 
  cd $VIM_ROOT
  git pull --rebase origin master

  if [ $? -eq 0 ]; then
    # vim things
    install libclang-3.9-dev || exit 1
    install libncurses-dev || exit 1
    install libz-dev || exit 1
    install xz-utils || exit 1
    install libpthread-workqueue-dev || exit 1
    LUA_VIM_MINOR_VERSION=`vim --version | grep "\-llua" | sed -r "s/.*\-llua5.([0-9]*).*/\1/"`
    install liblua5.$LUA_VIM_MINOR_VERSION-dev || exit 1
    install lua5.$LUA_VIM_MINOR_VERSION || exit 1

    # development files
    sudo apt-get install lua5.2 || exit 1
    sudo apt-get install ruby-dev
    sudo apt-get install ruby
    sudo apt-get install python-dev
    sudo apt-get install libperl-dev

    # X support for clipboard
    sudo apt-get install libx11-dev
    sudo apt-get install libxtst-dev


    # make uninstall --prefix=/home/`whoami`
    make uninstall

    make clean || exit 1
    make distclean
    ./configure --with-features=huge --enable-rubyinterp --enable-multibyte --enable-perlinterp=yes --enable-pythoninterp --enable-luainterp --enable-gui=gtk2 --enable-cscope --prefix=$TARGET --with-x || exit 1

    make || exit 1 # VIMRUNTIMEDIR=/usr/share/vim/vim74

    make install || exit 1

    echo "python:"
    vim --version | grep python
    echo "ruby:"
    vim --version | grep ruby
    echo "perl:"
    vim --version | grep perl
    echo "clipboard:"
    vim --version | grep clipboard

  fi

  echo "OK"
  echo "OK"
  echo "OK"
else
  echo "FAILED"
  echo "FAILED"
  echo "FAILED"
fi

cd $PREV
