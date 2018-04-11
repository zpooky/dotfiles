source $HOME/dotfiles/shared.sh

p() {
  printf '%b\n' "$1" >&2
}

bad() {
  p "\e[31m[✘]\e[0m ${1}${2}"
}

good() {
  p "\e[32m[✔]\e[0m ${1}${2}"
}

function install_pkg() {
  has_feature $1
  if [ $? -eq 1 ]; then
    install $1
    RET=$?

    if [ $RET -eq 1 ]; then
      bad $1 " was not installed"
      exit 1
    else
      good $1 " was installed"
    fi
  else
    good $1 " is already installed"
  fi
}

install_pkg screenfetch

screenfetch

install_pkg vim

#nvim
has_feature nvim
if [ $? -eq 1 ]; then
  install_pkg neovim
fi
install_pkg ruby
# install_pkg npm

gem install neovim
npm install -g neovim
pip2 install --user neovim
pip3 install --user neovim

#tmux
# https://github.com/remiprev/teamocil
gem install teamocil

# https://github.com/tmux-python/tmuxp
# freeze serialized current session layout to a yaml file which can be used by teamocil
pip install --user tmuxp

#video player
install_pkg mpv
install_pkg fakeroot

#
install_pkg guake
install_pkg chromium

#
install_pkg firefox
install_pkg wget
install_pkg sudo
install_pkg python2
install_pkg cmake
install_pkg clang
install_pkg python
install_pkg make
install_pkg htop
install_pkg autoconf
install_pkg sshfs
install_pkg perf
install_pkg patch

# compdb adds header to compile db
pip2 install --user git+https://github.com/Sarcasm/compdb.git#egg=compdb

#
pip2 install --user jedi
pip3 install --user jedi
pip install --user jedi

#python formatter
install_pkg yapf

#tor-browser
yaourt -S tor-browser

#for wifi-menu
install_pkg dialog
install_pkg wpa_supplicant

#actively maintaned fork for newsbeuter
install_pkg newsboat [0]

# X display server
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

# window manager
install_pkg dmenu
has_feature i3
if [ $? -eq 1 ]; then
  install i3-wm || exit 1
fi
install_pkg i3lock

#
install_pkg help2man

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
install_pkg gnome-keyring
has_feature seahorse
if [ $? -eq 1 ]; then
  install seahorse || exit 1
  install python2-gnomekeyring || exit 1
fi

#
has_feature ntpd
if [ $? -eq 1 ]; then
  install ntp || exit 1
  systemctl enable ntpd.service
  systemctl start ntpd.service
  timedatectl
fi

install_pkg automake

#battery
install_pkg acpi

#haskell
has_feature ghc
if [ $? -eq 1 ]; then
  install ghc || exit 1
  install ghc-static || exit 1
fi
has_feature cabal
if [ $? -eq 1 ]; then
  install cabal-install || exit 1
fi

install_pkg xterm
has_feature zsh
if [ $? -eq 1 ]; then
  install_pkg zsh
  install_pkg zsh-completions
fi
install_pkg termite

#xclip
install_pkg xclip

has_feature javac
if [ $? -eq 1 ]; then
  install jdk8-openjdk
fi

# misc
install_pkg pkg-config
install_pkg keepassxc
install_pkg cscope

has_feature ipfs
if [ $? -eq 1 ]; then
  yaourt -S go-ipfs
fi

has_feature package-query
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz"
fi

has_feature light
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/light.tar.gz"
fi

has_feature dropbox
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/dropbox.tar.gz"
  systemctl start dropbox --user
  systemctl enable dropbox --user
fi

has_feature spotify
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/spotify.tar.gz"
fi

has_feature yaourt
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz"
fi

has_feature lbdb-fetchaddr
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/lbdb.tar.gz"
fi

has_feature davmail
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/davmail.tar.gz"
fi

has_feature megasync
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/megasync.tar.gz"
fi

has_feature ctags
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/universal-ctags-git.tar.gz"
fi

# watch directory for file changes
has_feature entr
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/entr.tar.gz"
fi

has_feature global
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/global.tar.gz"
fi

has_feature bear
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/bear.tar.gz"
fi

has_feature tixati
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/tixati.tar.gz"
fi

# screensaver
install_pkg xscreensaver
has_feature electricsheep
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/electricsheep-svn.tar.gz"
fi

has_feature khal
if [ $? -eq 1 ]; then
  #   #TODO multiarch
  #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/python-tzlocal.tar.gz" || exit 1
  #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/python-icalendar.tar.gz" || exit 1
  #
  #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/khal.tar.gz"
  pip3.6 install --user khal
fi

# # vdirsyncer
has_feature vdirsyncer
if [ $? -eq 1 ]; then
  #   #TODO multiarch
  #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/python-atomicwrites.tar.gz"|| exit 1
  #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/python-click-threading.tar.gz"|| exit 1
  #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/python-click-log.tar.gz" || exit 1
  #
  #   install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/vdirsyncer.tar.gz"

  pip3.6 install --user vdirsyncer
fi

# install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/libtinfo5.tar.gz"
yaourt -S libtinfo5

has_feature eatmydata
if [ $? -eq 1 ]; then
  yaourt -S libeatmydata
  # #any arch
  # install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/libeatmydata.tar.gz"
fi

# install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/fbterm-git.tar.gz"

has_feature rtv
if [ $? -eq 1 ]; then
  pip3.6 install --user rtv
fi

has_feature alacritty
if [ $? -eq 1 ]; then
  sudo yaourt -S alacritty-git
  #   install_aur "https://aur.archlinux.org/alacritty-git.git"
fi

#rtags
has_feature rdm
if [ $? -eq 1 ]; then
  yaourt -S rtags
  systemctl --user enable rdm.socket
  systemctl --user start rdm.socket

  systemctl --user enable rdm
  systemctl --user start rdm
fi

has_feature shfmt
if [ $? -eq 1 ]; then
  yaourt -S shfmt
fi
