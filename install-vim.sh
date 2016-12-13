#!/bin/bash

# git submodule update --init --recursive
# ~/.vim/bundle/YouCompleteMe/third_party/ycmd/build.py


# sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
#     libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
#     libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
#     python3-dev ruby-dev git


# sudo apt-get remove vim vim-runtime gvim
# sudo apt-get remove vim-tiny vim-common vim-gui-common vim-nox

# ~/vim/src/Makefile
# sed -i /prefix = $(HOME)

VIM_HOME=~/vim
if [ ! -e $VIM_HOME ]; then 
  cd ~
  git clone https://github.com/vim/vim.git $VIM_HOME || exit 1
fi
cd $VIM_HOME
git pull || exit 1

make clean || exit 1
make uninstall --prefix=/home/`whoami`
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-pythoninterp \
#            --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
#           --enable-python3interp \
#             --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
            --enable-luainterp \
            --enable-gui=gtk2 --enable-cscope --prefix=/home/`whoami` || exit 1
make || exit 1 # VIMRUNTIMEDIR=/usr/share/vim/vim74
make install || exit 1
vim --version | grep python
echo "OK"
echo "OK"
echo "OK"
#
# # set vim as default editor
# sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
# sudo update-alternatives --set editor /usr/bin/vim
# sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
# sudo update-alternatives --set vi /usr/bin/vim
