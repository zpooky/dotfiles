#!/usr/bin/env bash

source "$HOME/dotfiles/shared.sh"

# compile less settings from .lesskey into .less
lesskey -o "$THE_HOME/.less" "$THE_HOME/.lesskey"

GIT_CONFIG_FEATURE=$FEATURE_HOME/gitconfig4
if [ ! -e "$GIT_CONFIG_FEATURE" ]; then
  if has_feature git; then
    start_feature "git config"

    # git config --global user.name ""
    git config --global user.email "spooky.bender@gmail.com"
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
echo "git submodule update --init --recursive --remote --jobs 8"
#git submodule update --init --recursive --remote --jobs 8 || exit 1
# git submodule update --init --recursive || exit 1
stop_feature "git submodules"

if has_feature pacman; then
  start_feature "arch"
  "${HOME}/dotfiles/arch_install.sh" || exit 1
  stop_feature "arch"
elif has_feature apt-get; then
  start_feature "apt-get"
  "${HOME}/dotfiles/ubuntu_installer.sh" || exit 1
  stop_feature "apt-get"
fi

if [ -e $HOME/sources/fzf ]; then
  make -C $HOME/sources/fzf bin/fzf
fi

# {
npm install -g npm
# sh
if has_feature pacman; then
  echo
  yay -S bash-language-server
else
  npm install -g bash-language-server
fi
# js
npm install -g typescript
npm install -g js-beautify # js format
npm install -g typescript-formatter # typescript format
if has_feature pacman; then
  echo
else
  npm install -g neovim
fi
# python3
if has_feature pacman; then
  yay -S python-pynvim python-jedi jedi-language-server
  echo
else
  pip3 install --user --upgrade jedi
  pip3 install --user --upgrade pynvim
  pip3 install --user --upgrade neovim
  pip3 install --user --upgrade jedi-language-server
fi
# ruby
if has_feature pacman; then
  echo
  gem install --user-install neovim
else
  gem install --user-install neovim
fi
# docker
npm install -g dockerfile-language-server-nodejs
# rust
if has_feature rustup; then
  rustup component add rustfmt
fi
# c++
if has_feature pacman; then
  # yay -S clang
  # clang based language server
  echo
else
  echo
fi
# scala language server
if has_feature pacman; then
  echo
else
  echo "TODO"
fi
# markdown
npm install -g remark # markdown format
# if has_feature pacman; then
#   yay -S redpen languagetool
# else
#   if [[ ! "$(uname -a)" =~ Microsoft ]]; then
#     if has_feature snap; then
#       sudo snap install redpen
#       sudo snap install languagetool
#     fi
#   else
#     echo "TODO"
#   fi
# fi

# npm install -g prettier

if has_feature pacman; then
  echo
else
  pip3 install --user --upgrade yapf
fi
npm install --global yarn

pip3 install --user --upgrade numpy
pip3 install --user --upgrade scipy
pip3 install --user --upgrade matplotlib

# }

start_feature "vim"
if has_feature nvim; then
  nvim +PlugUpdate +qall
fi

if has_feature vim; then
  vim +PlugUpdate +qall
fi

if [ -e ~/.vim/plugged/command-t ]; then
  PREV_DIR=$(pwd)

  if cd "$HOME/.vim/plugged/command-t"; then
    rake make
    cd "${PREV_DIR}"
  fi
fi

if [ -e ~/.config/nvim/plugged/command-t ]; then
  PREV_DIR=$(pwd)

  if cd "$HOME/.config/nvim/plugged/command-t"; then
    rake make
    cd "${PREV_DIR}"
  fi
fi

stop_feature "vim"

# if wm=gnome | https://github.com/deadalnix/pixel-saver

start_feature "update tmux plugins"
~/.tmux/plugins/tpm/bin/install_plugins
stop_feature "update tmux plugins"

# bashrc
FEATURE=$FEATURE_HOME/bashrc
if [ ! -e $FEATURE ]; then
  start_feature "bashrc"

  echo 'source ~/dotfiles/extrarc' >> ~/.bashrc

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
    ' >$DOTFILES_INPUTRC
  else
    touch $DOTFILES_INPUTRC
  fi
fi

exit 0

# rust
if has_feature rustup; then
  rustup update stable
fi

if has_feature pacman; then
  exit 0
fi
exit 0

# pdftotext pdf lib + utils
has_feature pdftohtml
if [[ $? -eq 1 ]]; then
  install poppler || exit 1
fi
has_feature poppler-util
if [[ $? -eq 1 ]]; then
  if has_feature apt-get; then
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

# xterm-256color support
has_feature ncurses-term
if [[ $? -eq 1 ]]; then
  if has_feature apt-get; then
    install ncurses-term || exit 1
  fi
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
  if has_feature apt-get; then
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

# $HOME/dotfiles/install_atomic.sh
