#!/usr/bin/env bash

source "$HOME/dotfiles/shared.sh"

p() {
  printf '%b\n' "$1" >&2
}

bad() {
  p "\\e[31m[✘]\\e[0m ${1}${2}"
}

good() {
  p "\\e[32m[✔]\\e[0m ${1}${2}"
}

function install_pkg() {
  has_feature "$1"
  if [ $? -eq 1 ]; then
    install "$1"
    RET=$?

    if [ $RET -eq 1 ]; then
      bad "$1" " was not installed"
      exit 1
    else
      good "$1" " was installed"
    fi
  else
    good "$1" " is already installed"
  fi
}

function install_graphic_pkg() {
  if [[ ! -n "${IS_DOCKER}" ]]; then
    install_pkg $@
  fi
}

function ins_yay_itself() {
  has_feature "yay"
  if [ $? -eq 1 ]; then
    pacman -Ss "^yay$" >/dev/null
    local ret=$?
    if [ ${ret} -eq 0 ]; then
      install_pkg yay
      return $?
    # elif [[ -n "${IS_DOCKER}" ]]; then
    #   #TODO create user+add sudo+clone+build+install
    #   # TODO yay has to run as non root
    #   #git clone https://aur.archlinux.org/yay.git
    #   # cd yay
    #   # makepkg -si
    #
    #   # https://github.com/Jguer/yay/issues/701
    #   return 1
    else
      install_pkg wget
      install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz"
      return $?
    fi
  fi

  return 0
}

update_package_list

# 1. Essentials
has_feature gawk
if [ $? -eq 1 ]; then
  install_pkg base-devel
fi
install_pkg make

# 2. Support AUR packages
ins_yay_itself

# 3. other
install_pkg awk

# gvim for xterm support
has_feature vim
if [ $? -eq 1 ]; then
  install_pkg gvim
fi

if ! has_feature python; then
  install_pkg python
  install_pkg python-neovim
  install_pkg python-jedi
  install_pkg jedi-language-server
fi
install_pkg npm
install_pkg curl
if ! has_feature zsh; then
  install_pkg zsh
  install_pkg zsh-completions
fi
install_pkg rake
install_pkg yarn
install_pkg tmux
if ! has_feature ag; then
  install_yay the_silver_searcher
fi
install_pkg tig
if ! has_feature aspell; then
  install_pkg aspell
  install_pkg aspell-en
  install_pkg aspell-sv
fi

install_pkg htop
if ! has_feature node; then
  install_pkg nodejs
  install_yay nodejs-neovim
fi

if ! has_feature ruby; then
  install_pkg ruby
  install_yay ruby-neovim
fi

if ! has_feature nvim; then
  install_pkg neovim
fi
install_pkg ctags
install_pkg tree
install_pkg languagetool

install_pkg bash-language-server
install_pkg shfmt
# install_pkg shellcheck

install_pkg xclip

#python formatter
install_pkg yapf
if ! has_feature cppcheck; then
  install_yay cppcheck
fi
install_pkg ccls
# json
install_pkg jq

if ! has_feature metals-vim; then
  install_pkg metals
fi

if ! has_feature lua-format; then
  install_yay lua-format
fi

# code format
install_pkg prettier

install_pkg ranger
install_pkg w3m # image preview in ranger
install_pkg wget
install_pkg sudo
install_pkg cmake
install_pkg clang
install_pkg autoconf
install_pkg perf
install_pkg patch

# --------------------
if ! has_feature jsonlint; then
  yay -S nodejs-jsonlint
fi
# wifi
if ! has_feature iwctl; then
  install_pkg iwd
fi

exit 0

# dev
install_pkg backward-cpp
install_pkg gtest

# Eclipse Java language server
install_yay jdtls

# An LSP server for Go
install_yay gopls-git

has_feature trans
if [ $? -eq 1 ]; then
  install_yay translate-shell
fi

#tmux
# https://github.com/remiprev/teamocil

# $HOME/source/teamocil
# has_feature teamocil
# if [ $? -eq 1 ]; then
#   install_yay teamocil
# fi

# https://github.com/tmux-python/tmuxp
# freeze serialized current session layout to a yaml file which can be used by teamocil
#pip install --user tmuxp
has_feature tmuxp
if [ $? -eq 1 ]; then
  install_yay tmuxp
fi

#spelling
# has_feature proselint
# if [ $? -eq 1 ]; then
#   install_yay proselint
# fi
# has_feature redpen
# if [ $? -eq 1 ]; then
#   install_yay redpen
# fi
# if ! has_feature cabal; then
#   install cabal-install || exit 1
#   cabal update
#   cabal install spellcheck
# fi

# has_feature afl-gcc
# if [ $? -eq 1 ]; then
#   install_pkg afl
#   install_pkg afl-utils
# fi

#video player
install_graphic_pkg mpv
install_pkg fakeroot

#
# install_pkg guake
install_graphic_pkg chromium

#
install_pkg ranger
install_graphic_pkg firefox

# compdb adds header to compile db
#pip2 install --user git+https://github.com/Sarcasm/compdb.git#egg=compdb

#tor-browser
# install_graphic_pkg tor-browser

#for wifi-menu
# install_graphic_pkg dialog
# install_graphic_pkg wpa_supplicant

#actively maintaned fork for newsbeuter
# install_pkg newsboat

# X display server
if [[ ! -n "${IS_DOCKER}" ]]; then
  has_feature X
  if [ $? -eq 1 ]; then
    install xorg-server || exit 1
    install xorg-xrandr || exit 1
  fi
  has_feature xinit
  if [ $? -eq 1 ]; then
    install xorg-xinit || exit 1
  fi

  has_feature nslookup
  if [ $? -eq 1 ]; then
    install dnsutils
  fi

  install_pkg xsel

  # window manager
  install_pkg dmenu
  has_feature i3
  if [ $? -eq 1 ]; then
    install i3-wm || exit 1
  fi

  #xclip

  # has_feature ipfs
  # if [ $? -eq 1 ]; then
  #   install_yay go-ipfs
  # fi

  has_feature light
  if [ $? -eq 1 ]; then
    # install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/light.tar.gz"
    install_pkg light
  fi
  #
  # has_feature dropbox
  # if [ $? -eq 1 ]; then
  #   # install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/dropbox.tar.gz"
  #   install_yay dropbox
  #   systemctl start dropbox --user
  #   systemctl enable dropbox --user
  # fi
  #
  #
  # has_feature dropbox-cli
  # if [ $? -eq 1 ]; then
  #   install_yay dropbox-cli
  # fi

  has_feature spotify
  if [ $? -eq 1 ]; then
    #install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/spotify.tar.gz"
    install_yay spotify
  fi

  has_feature tixati
  if [ $? -eq 1 ]; then
    #install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/tixati.tar.gz"
    install_yay tixati
  fi

  # screensaver
  # install_pkg xscreensaver
  # has_feature electricsheep
  # if [ $? -eq 1 ]; then
  #   #install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/electricsheep-svn.tar.gz"
  #   install_yay electricsheep
  # fi

  has_feature syncthing
  if [ $? -eq 1 ]; then
    install_yay -S syncthing
    install_yay -S syncthing-gtk

    systemctl enable --user syncthing.service
    systemctl start --user syncthing.service
  fi

  #rtags
  # has_feature rdm
  # if [ $? -eq 1 ]; then
  #   install_yay rtags
  #   systemctl --user enable rdm.socket
  #   systemctl --user start rdm.socket
  #
  #   systemctl --user enable rdm
  #   systemctl --user start rdm
  # fi

  has_feature bibtex
  if [ $? -eq 1 ]; then
    install_pkg texlive-bin
    install_pkg texlive-core
    install_pkg texlive-bibtexextra
    install_pkg texlive-latexextra
  fi
fi # if IS_DOCKER

#
# install_pkg help2man

# daemon to watch for acpi event like backligt power up/down
has_feature acpid
if [ $? -eq 1 ]; then
  install acpid || exit 1
  systemctl enable acpid
  systemctl start acpid
  systemctl status acpid
fi

# cron
has_feature crond
if [ $? -eq 1 ]; then
  install cronie || exit 1
  systemctl enable cronie.service
  systemctl start cronie.service
fi

#keyring
# install_pkg gnome-keyring
# has_feature seahorse
# if [ $? -eq 1 ]; then
#   install seahorse || exit 1
#   install python2-gnomekeyring || exit 1
# fi

#
# has_feature ntpd
# if [ $? -eq 1 ]; then
#   install ntp || exit 1
#   systemctl enable ntpd.service
#   systemctl start ntpd.service
#   timedatectl
# fi

install_pkg automake

#battery
install_pkg acpi

#haskell
# has_feature ghc
# if [ $? -eq 1 ]; then
#   install ghc || exit 1
#   install ghc-static || exit 1
# fi

# install_pkg xterm
# install_pkg termite
# install_pkg fzf

# has_feature javac
# if [ $? -eq 1 ]; then
#   install jdk10-openjdk
# fi

# misc
install_pkg pkg-config
install_pkg keepass
# install_pkg cscope

# has_feature lbdb-fetchaddr
# if [ $? -eq 1 ]; then
#   #install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/lbdb.tar.gz"
#   install_yay lbdb
# fi
#
# has_feature davmail
# if [ $? -eq 1 ]; then
#   #install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/davmail.tar.gz"
#   install_yay davmail
# fi

has_feature megasync
if [ $? -eq 1 ]; then
  #install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/megasync.tar.gz"
  install_yay megasync
fi

# watch directory for file changes
install_pkg entr

# has_feature global
# if [ $? -eq 1 ]; then
#   #install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/global.tar.gz"
#   install_yay global
# fi

# install_pkg ack

has_feature bear
if [ $? -eq 1 ]; then
  #install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/bear.tar.gz"
  install_yay bear
fi

# has_feature khal
# if [ $? -eq 1 ]; then
#   #   #TODO multiarch
#   #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/python-tzlocal.tar.gz" || exit 1
#   #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/python-icalendar.tar.gz" || exit 1
#   #
#   #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/khal.tar.gz"
#   #pip3.6 install --user khal
#   install_yay khal
# fi
#
# # # vdirsyncer
# has_feature vdirsyncer
# if [ $? -eq 1 ]; then
#   #   #TODO multiarch
#   #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/python-atomicwrites.tar.gz"|| exit 1
#   #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/python-click-threading.tar.gz"|| exit 1
#   #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/python-click-log.tar.gz" || exit 1
#   #
#   #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/vdirsyncer.tar.gz"
#
#   #pip3.6 install --user vdirsyncer
#   install_yay vdirsyncer
# fi

# install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/libtinfo5.tar.gz"
# yay -S libtinfo5

# has_feature eatmydata
# if [ $? -eq 1 ]; then
#   install_yay libeatmydata
#   # #any arch
#   # install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/libeatmydata.tar.gz"
# fi

# install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/fbterm-git.tar.gz"

# has_feature rtv
# if [ $? -eq 1 ]; then
#   install_yay rtv
# fi

install_pkg alacritty

has_feature shfmt
if [ $? -eq 1 ]; then
  install_yay shfmt
fi

install_pkg bison
install_pkg flex
install_pkg strace

install_pkg fd

# echo "/lib/modules/$(uname -r)/build/include"
# if [ ! -e "/lib/modules/$(uname -r)/build/include" ]; then
# install_pkg linux-headers
# fi
