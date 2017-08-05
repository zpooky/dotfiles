
#!/bin/bash

# ~/vim/src/Makefile
# TODO 1 sed -i /prefix = $(HOME)

# TODO 2 add ~/bin to path

source $HOME/dotfiles/shared.sh

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

    # development files
    sudo apt-get install lua5.2 || exit 1
    sudo apt-get install ruby-dev
    sudo apt-get install ruby
    sudo apt-get install python-dev
    sudo apt-get install libperl-dev

    # make uninstall --prefix=/home/`whoami`
    make uninstall

    make clean || exit 1
    ./configure --with-features=huge --enable-rubyinterp --enable-multibyte --enable-perlinterp=yes --enable-pythoninterp --enable-luainterp --enable-gui=gtk2 --enable-cscope --prefix=$TARGET || exit 1

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
