#!/bin/bash

source $HOME/dotfiles/shared.sh

# compile less settings from .lesskey into .less
lesskey -o $THE_HOME/.less $THE_HOME/.lesskey

GIT_CONFIG_FEATURE=$FEATURE_HOME/gitconfig4
if [ ! -e $GIT_CONFIG_FEATURE ]; then
  start_feature "git config"

  # TODO fetch from keychain
  git config --global user.name "Fredrik Olsson"
  git config --global user.email "spooky.bender@gmail.com"
  git config --global core.editor vim

  git config --global alias.st "status --ignore-submodules=dirty"
  git config --global alias.tree "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

  touch $GIT_CONFIG_FEATURE

  stop_feature "git config"
fi

# setup directory structure
if [ ! -e $USER_BIN ]; then
  mkdir $USER_BIN || exit 1
fi

# submodules
start_feature "git submodules"
git submodule sync --recursive
# recursivly pull in all submodule repos
git submodule update --init --recursive --remote
git submodule update --init --recursive

stop_feature "git submodules"
start_feature "vim"

VIM_AUTOLOAD=$THE_HOME/.vim/autoload
if [ ! -e $VIM_AUTOLOAD ]; then
  mkdir $VIM_AUTOLOAD
fi

PATHOGEN_AUTLOAD=$VIM_AUTOLOAD/pathogen.vim
if [ -e $PATHOGEN_AUTLOAD ]; then
  rm -rf $THE_HOME/.pathogen
  rm $PATHOGEN_AUTLOAD
fi

VIM_PLUG=$GIT_SOURCES/vim-plug/plug.vim
VIM_PLUG_TARGET=$VIM_AUTOLOAD/plug.vim
if [ ! -e $VIM_PLUG_TARGET ]; then
  ln -s $VIM_PLUG $VIM_PLUG_TARGET
fi

stop_feature "vim"

# git You Complete Me(YCM)
YCM_IT=3
YCM_FORKS=("OblitumYouCompleteMe" "YouCompleteMe")

for YCM in "${YCM_FORKS[@]}"
do
  FEATURE="$FEATURE_HOME/${YCM}${YCM_IT}"
  if [ ! -e $FEATURE ]; then
    start_feature "$YCM"

    # TODO should recompile when vim version changes
    PREV_DIR=`pwd`

    cd $THE_HOME/.vim/bundle/$YCM
    ./install.py --clang-completer
    RET=$?
    if [ $RET -eq 0 ]; then
      touch $FEATURE
    fi

    cd $PREV_DIR

    stop_feature "$YCM"
  fi
done

# vim color coded
FEATURE=$FEATURE_HOME/color_coded2
if [ ! -e $FEATURE ]; then
  start_feature "color_coded1"

  # TODO should recompile when vim version changes
  PREV_DIR=`pwd`
  COLOR_CODED_PATH=$THE_HOME/.vim/bundle/color_coded 
  COLOR_CODED_BUILD_PATH=$COLOR_CODED_PATH/build
  cd $COLOR_CODED_PATH
  if [ -d $COLOR_CODED_BUILD_PATH ]; then
    rm -rf $COLOR_CODED_BUILD_PATH
  fi
  mkdir build && cd build || exit 1
  cmake ..
  if [ $? -eq 0 ]; then 
    make && make install
    RET=$?

      # Cleanup afterward; frees several hundred megabytes
      make clean && make clean_clang

    if [ $RET -eq 0 ]; then 
      touch $FEATURE
    fi
  fi

  cd $PREV_DIR

  stop_feature "color_coded1"
fi

# bashrc
FEATURE=$FEATURE_HOME/bashrc
if [ ! -e $BASHRC_FEATURE ]; then
  start_feature "bashrc"

  echo 'source ~/dotfiles/extrarc' >> ~/.bashrc
  echo 'source ~/dotfiles/extrarc' >> ~/.zshrc

  touch $FEATURE
  stop_feature "bashrc"
fi

# .inputrc is the start-up file used by readline, the input related library used by bash and most other shells
DOTFILES_INPUTRC=$THE_HOME/dotfiles/inputrc
if [ ! -e $DOTFILES_INPUTRC ]; then
  if [[ $(uname -s) =~ CYGWIN.* ]]; then
    echo '
    # make ctrl+left/right navigate word by word
    # default is not setup in cygwin
    # ctrl + right
    "\e[1;5C": forward-word
    # ctrl + left
    "\e[1;5D": backward-word

    # shift+insert - paste
    ' > $DOTFILES_INPUTRC
  else
    touch $DOTFILES_INPUTRC
  fi
fi

start_feature "update tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins
stop_feature "update tmux plugins"

# gdb formatter from gcc
GDB_PP=$SOURCES_ROOT/gdb_pp
if [ ! -e $GDB_PP ]; then
  svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python $GDB_PP
  if [ ! $? -eq 0 ]; then
    rm -rf $GDB_PP
  fi
fi

echo "Enter sudo password"
sudo echo "start" || exit 1

# pip3

# update
start_feature "update pip"

#python3
has_feature python
if [[ $? -eq 1 ]]; then
  install python || exit 1
fi

has_feature python-pip
if [[ $? -eq 1 ]]; then
  install python-pip || exit 1
fi

pip3_install --upgrade pip || exit 1

pip3_install keyring || exit 1

start_feature "update package database"
update_package_list


# pdftotext
has_feature poppler
if [[ $? -eq 1 ]]; then
  install poppler || exit 1
fi

has_feature poppler-util
if [[ $? -eq 1 ]]; then
  install poppler-util || exit 1
fi

has_feature colordiff
if [[ $? -eq 1 ]]; then
  install colordiff || exit 1
fi

stop_feature "update pip"

start_feature "apt-get install tools"
has_feature htop
if [[ $? -eq 1 ]]; then
  install htop || exit 1
fi

has_feature rake
if [[ $? -eq 1 ]]; then
  install rake || exit 1
fi

has_feature tree
if [[ $? -eq 1 ]]; then
  install tree || exit 1
fi

has_feature wget
if [[ $? -eq 1 ]]; then
  install wget || exit 1
fi

has_feature curl
if [[ $? -eq 1 ]]; then
  install curl || exit 1
fi
# text terminal web browser

has_feature ncurses-term
if [[ $? -eq 1 ]]; then
  install ncurses-term || exit 1
fi

has_feature sqlite3
if [[ $? -eq 1 ]]; then
  install sqlite3 || exit 1
fi

has_feature "sed"
if [[ $? -eq 1 ]]; then
  install "sed" || exit 1
fi

has_feature autoconf
if [[ $? -eq 1 ]]; then
  install autoconf || exit 1
fi

# xterm-256color support
has_feature ncurses-term
if [[ $? -eq 1 ]]; then
  install ncurses-term || exit 1
fi

has_feature atool
if [[ $? -eq 1 ]]; then
# for archives text
  install atool || exit 1
fi

has_feature highlight
if [[ $? -eq 1 ]]; then
  # for syntax highlighting. text ranger
  install highlight
fi

has_feature mediainfo
if [[ $? -eq 1 ]]; then
  # for media file information.
  install mediainfo
fi

has_feature transmission-cli
if [[ $? -eq 1 ]]; then
  install transmission-cli
fi

has_feature openssl
if [[ $? -eq 1 ]]; then
  install openssl
fi

start_feature "libraries"
install libncurses5-dev || exit 1
install libgnome2-dev || exit 1
install libgnomeui-dev || exit 1
install libgtk2.0-dev || exit 1
install libatk1.0-dev || exit 1
install libbonoboui2-dev || exit 1
install libcairo2-dev || exit 1
install libx11-dev || exit 1
install libxpm-dev || exit 1
install libxt-dev || exit 1
install python-dev || exit 1

#
install linux-tools-common || exit 1
install linux-tools-generic || exit 1
install linux-tools-`uname -r` || exit 1

# The package libreadline is for running applications using readline command
# and the package libreadline-dev is for compiling and building readline application.
install libreadline6 || exit 1
install libreadline6-dev || exit 1

start_feature "junk"
install gnome-common
install gtk-doc-tool
install libglib2.0-de
install libgtk2.0-dev
install python-gtk
install python-gtk2-de
install python-vt
install glad
install python-glade2
install libgconf2-de
install python-appindicator
install python-vt
install python-gcon
install python-keybinder
install notify-osd
install libutempter0
install python-notify

start_feature "apt-get install python"

install python-sqlite || exit 1
install python-vobject || exit 1
install python-gnomekeyring || exit 1
install python-dev || exit 1


start_feature "development"
has_feature build-essential
if [[ $? -eq 1 ]]; then
  install build-essential || exit 1
fi

has_feature clang
if [[ $? -eq 1 ]]; then
  install clang
fi

has_feature gdb
if [[ $? -eq 1 ]]; then
  install gdb || exit 1
fi

has_feature cmake
if [[ $? -eq 1 ]]; then
  install cmake
fi

has_feature svn
if [[ $? -eq 1 ]]; then
  install svn || exit 1
fi

has_feature git
if [[ $? -eq 1 ]]; then
  install git || exit 1
fi

has_feature cpplint
if [[ $? -eq 1 ]]; then
  start_feature "pip install cpp"
  pip3_install cpplint || exit 1
fi

has_feature newsbeuter
if [[ $? -eq 1 ]]; then
  install newsbeuter
fi

# keyring
## work host <outlook.office365.com>
## work port <993>
## work username <>
## work email <>
## work password <>
## work domain <> mail_name@*domain*.com
## work realname <> firstname surname
## work mail_name *mail_name*@domain.com

## personal password
## personal email
## personal realname <> firstname surname
## personal mail_name *mail_name*@domain.com
#not used: personal cal_ical #gmail > settings > ... > copy private cal url

# pip2 for python2.7
has_feature pip2
if [ ! $? -eq 0 ]; then
  is_arch
  if [ $? -eq 0 ]; then
    install python2-pip
  else
    # python2 -m pip uninstall pip setuptools
    PREV_DIR=`pwd`

    cd /tmp
    curl -O https://bootstrap.pypa.io/get-pip.py

    if [ $? -eq 0 ]; then
      sudo -H  python2.7 get-pip.py
    fi

    cd $PREV_DIR
  fi
fi

pip2_install --upgrade pip || exit 1
# mutt url viewer
has_feature urlscan
if [[ $? -eq 1 ]]; then
  pip2_install urlscan || exit 1
fi

#python import sort
# pip2_install git+https://github.com/timothycrosley/isort.git

# qutebrowser - browser with vim like binding
has_feature qutebrowser
if [ $? -eq 1 ]; then
  start_feature "qutebrowser"

  is_arch
  if [ $? -eq 0 ]; then
    install qutebrowser
  else
    install python3-lxml python-tox python3-pyqt5 python3-pyqt5.qtwebkit
    install python3-pyqt5.qtquick python3-sip python3-jinja2 python3-pygments python3-yaml

    #TODO install
  fi
  stop_feature "qutebrowser"
fi

# mpv video player
has_feature mpv
if [ $? -eq 1 ]; then
  is_apt_get
  if [ $? -eq 0 ]; then
    sudo add-apt-repository -y ppa:mc3man/mpv-tests
    update_package_list
  fi
  install mpv
fi

has_feature youtube-dl
if [[ $? -eq 1 ]]; then
  # allows mpv to download and play youtube videos
  install youtube-dl || exit 1
fi

## less colors
# FEATURE=$FEATURE_HOME/lesscolors
# if [ ! -e $FEATURE ]; then
#   start_feature "lesscolors"
#
#
#   touch $FEATURE
#   stop_feature "lesscolors"
# fi

$HOME/dotfiles/install_atomic.sh
