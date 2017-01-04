#!/bin/bash

# ~/vim/src/Makefile
# TODO 1 sed -i /prefix = $(HOME)

# TODO 2 add ~/bin to path


echo "you have to manually configure script by editing it"
exit 1

VIM_HOME=~/vim
if [ ! -e $VIM_HOME ]; then 
  cd ~
  git clone https://github.com/vim/vim.git $VIM_HOME || exit 1
fi
cd $VIM_HOME
git pull || exit 1

make clean || exit 1
# make uninstall --prefix=/home/`whoami`
./configure --with-features=huge --enable-multibyte --enable-rubyinterp --enable-pythoninterp --enable-luainterp --enable-gui=gtk2 --enable-cscope --prefix=/home/`whoami` || exit 1

make || exit 1 # VIMRUNTIMEDIR=/usr/share/vim/vim74

make install || exit 1

vim --version | grep python
echo "OK"
echo "OK"
echo "OK"
