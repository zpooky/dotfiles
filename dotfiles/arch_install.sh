source $HOME/dotfiles/shared.sh

screenfetch

p() {
    printf '%b\n' "$1" >&2
}

bad(){
    p "\e[31m[✘]\e[0m ${1}${2}"
}

good() {
  p "\e[32m[✔]\e[0m ${1}${2}"
}

function install_pkg(){
  has_feature $1
  if [ $? -eq 1 ]; then
    install $1
    RET=$?

    if [$RET -eq 1 ]; then
      bad $1 " was not installed"
      exit 1
    else
      good $1 " was installed"
    fi
  else
      good $1 " is already installed"
  fi
}

#video player
install_pkg mpv

install_pkg fakeroot

#
install_pkg guake
install_pkg chromium

# to make install work
install_pkg sudo
install_pkg python2
install_pkg cmake
install_pkg clang
install_pkg python
install_pkg make
install_pkg htop
install_pkg sshfs
install_pkg perf

# X display server
has_feature X
if [ $? -eq 1 ]; then
  install xorg-server || exit 1
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
install_pkg zsh
install_pkg zsh-completions
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
  install_aur  "https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz"
fi

has_feature lbdb-fetchaddr
if [ $? -eq 1 ]; then
  install_aur  "https://aur.archlinux.org/cgit/aur.git/snapshot/lbdb.tar.gz"
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

# has_feature alacritty
# if [ $? -eq 1 ]; then
#   install_aur "https://aur.archlinux.org/alacritty-git.git"
# fi
