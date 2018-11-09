#!/bin/bash

source "$HOME/dotfiles/shared.sh"

# compile less settings from .lesskey into .less
lesskey -o "$THE_HOME/.less" "$THE_HOME/.lesskey"

GIT_CONFIG_FEATURE=$FEATURE_HOME/gitconfig4
if [ ! -e "$GIT_CONFIG_FEATURE" ]; then
  has_feature git
  if [ $? -eq 0 ]; then
    start_feature "git config"

    # TODO fetch from keychain
    git config --global user.name ""
    git config --global user.email ""
    git config --global core.editor vim

    git config --global alias.st "status --ignore-submodules=dirty"
    git config --global alias.tree "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

    touch "$GIT_CONFIG_FEATURE"

    stop_feature "git config"
  fi
fi

# setup directory structure
if [ ! -e "${USER_BIN}" ]; then
  mkdir "${USER_BIN}" || exit 1
fi

# submodules
start_feature "git submodules"
# git submodule sync --recursive || exit 1
# recursivly pull in all submodule repos
git submodule update --init --recursive --remote || exit 1
# git submodule update --init --recursive || exit 1
stop_feature "git submodules"

start_feature "vim"
VIM_AUTOLOAD=$THE_HOME/.vim/autoload
if [ ! -e "$VIM_AUTOLOAD" ]; then
  mkdir "$VIM_AUTOLOAD"
fi

VIM_PLUG=$GIT_SOURCES/vim-plug/plug.vim
VIM_PLUG_TARGET=$VIM_AUTOLOAD/plug.vim
if [ ! -e "$VIM_PLUG_TARGET" ]; then
  ln -s "$VIM_PLUG" "$VIM_PLUG_TARGET"
fi
stop_feature "vim"


is_arch
if [ $? -eq 0 ]; then
  start_feature "arch"
  $HOME/dotfiles/arch_install.sh || exit 1
  stop_feature "arch"
fi


start_feature "update tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins
stop_feature "update tmux plugins"

start_feature "fzf"
$HOME/sources/fzf/install --key-bindings --completion --xdg --no-update-rc
stop_feature "fzf"

start_feature "zsh-autosuggestions"
zsh_custom_plugins=$HOME/.oh-my-zsh/custom/plugins
zsh_autosuggest=$zsh_custom_plugins/zsh-autosuggestions
if [ ! -e $zsh_autosuggest ]; then

  git clone https://github.com/zsh-users/zsh-autosuggestions.git "${zsh_autosuggest}"
  if [ ! $? -eq 0 ]; then
    rm -rf "${zsh_autosuggest}"
  fi
fi

if [ -e $zsh_autosuggest ]; then
  PREV_DIR=$(pwd)
  cd $zsh_autosuggest

  git pull --rebase origin master
  cd $PREV_DIR
fi
stop_feature "zsh-autosuggestions"


start_feature "zsh-completions"
zsh_custom_plugins=$HOME/.oh-my-zsh/custom/plugins
zsh_completions=$zsh_custom_plugins/zsh-completions
if [ ! -e $zsh_completions ]; then

  git clone  https://github.com/zsh-users/zsh-completions.git "${zsh_completions}"
  if [ ! $? -eq 0 ]; then
    rm -rf "${zsh_completions}"
  fi
fi

if [ -e $zsh_completions ]; then
  PREV_DIR=$(pwd)
  cd $zsh_completions

  git pull --rebase origin master
  cd $PREV_DIR
fi
stop_feature "zsh-completions"

# git You Complete Me(YCM)
YCM_IT=7
YCM_FORKS=("OblitumYouCompleteMe" "YouCompleteMe")

for YCM in "${YCM_FORKS[@]}"; do
  FEATURE="$FEATURE_HOME/${YCM}${YCM_IT}"
  if [ ! -e "$FEATURE" ]; then
    start_feature "$YCM"

    # TODO should recompile when vim version changes
    PREV_DIR=$(pwd)

    cd "$THE_HOME/.vim/bundle/$YCM"

    ./install.py --clang-completer --system-libclang # --go-completer --rust-completer --js-completer
    RET=$?
    if [ $RET -eq 0 ]; then
      touch "$FEATURE"
    fi

    cd "$PREV_DIR"

    stop_feature "$YCM"
  fi
done

# vim color coded {
if [ 1 -eq 0 ]; then
  FEATURE=$FEATURE_HOME/color_coded2
  if [ ! -e $FEATURE ]; then
    start_feature "color_coded1"

    # TODO should recompile when vim version changes
    PREV_DIR=$(pwd)
    COLOR_CODED_PATH=$THE_HOME/.vim/bundle/color_coded
    COLOR_CODED_BUILD_PATH=$COLOR_CODED_PATH/build
    cd $COLOR_CODED_PATH
    if [ -d $COLOR_CODED_BUILD_PATH ]; then
      rm -rf $COLOR_CODED_BUILD_PATH
    fi

    mkdir build && cd build || exit 1

    cmake ..

    if [ $? -eq 0 ]; then
      make -j && make install
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
fi
#}

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

# gdb formatter from gcc
GDB_PP="${SOURCES_ROOT}/gdb_pp"
if [ ! -e $GDB_PP ]; then
  svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python $GDB_PP
  if [ ! $? -eq 0 ]; then
    rm -rf $GDB_PP
  fi
fi

# rust
has_feature rustup
if [[ $? -eq 0 ]]; then
  rustup update stable
fi

is_arch
if [[ $? -eq 0 ]]; then
  exit 0
fi


exit 1

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

#has_feature pip
#if [[ $? -eq 1 ]]; then
#  install python-pip || exit 1
#fi
#
#pip3_install --upgrade pip || exit 1

# pip3_install keyring || exit 1

start_feature "update package database"
update_package_list

# pdftotext pdf lib + utils
has_feature pdftohtml
if [[ $? -eq 1 ]]; then
  install poppler || exit 1
fi
has_feature poppler-util
if [[ $? -eq 1 ]]; then
  is_apt_get
  if [ $? -eq 0 ]; then
    install poppler-util
  fi
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

# xterm-256color support
has_feature ncurses-term
if [[ $? -eq 1 ]]; then
  is_apt_get
  if [ $? -eq 0 ]; then
    install ncurses-term || exit 1
  fi
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

has_feature screenfetch
if [[ $? -eq 1 ]]; then
  install screenfetch
fi

start_feature "libraries"

start_feature "development"
has_feature build-essential
if [[ $? -eq 1 ]]; then

  is_apt_get
  if [ $? -eq 0 ]; then
    install build-essential || exit 1
  fi
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
  # pip3_install cpplint || exit 1
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
# has_feature pip2
# if [ ! $? -eq 0 ]; then
#   is_arch
#   if [ $? -eq 0 ]; then
#     install python2-pip
#   else
#     # python2 -m pip uninstall pip setuptools
#     PREV_DIR=$(pwd)
# 
#     cd /tmp
#     curl -O https://bootstrap.pypa.io/get-pip.py
# 
#     if [ $? -eq 0 ]; then
#       sudo -H python2.7 get-pip.py
#     fi
# 
#     cd $PREV_DIR
#   fi
# fi

# pip2_install --upgrade pip || exit 1
# # mutt url viewer
# has_feature urlscan
# if [[ $? -eq 1 ]]; then
#   pip2_install urlscan || exit 1
# fi

#python import sort
# pip2_install git+https://github.com/timothycrosley/isort.git

# qutebrowser - browser with vim like binding
has_feature qutebrowser
if [ $? -eq 1 ]; then
  start_feature "qutebrowser"

  install qutebrowser
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
