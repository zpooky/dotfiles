source $HOME/dotfiles/shared.sh

#video player
has_feature mpv
if [ $? -eq 1 ]; then
  install mpv || exit 1
fi

has_feature fakeroot
if [ $? -eq 1 ]; then
  install fakeroot || exit 1
fi

#
has_feature guake
if [ $? -eq 1 ]; then
  install guake || exit 1
fi
has_feature chromium
if [ $? -eq 1 ]; then
  install chromium || exit 1
fi
# to make install work
has_feature sudo
if [ $? -eq 1 ]; then
  install sudo || exit 1
fi
has_feature python2
if [ $? -eq 1 ]; then
  install python2 || exit 1
fi
has_feature cmake
if [ $? -eq 1 ]; then
  install cmake || exit 1
fi
has_feature clang
if [ $? -eq 1 ]; then
  install clang || exit 1
fi
has_feature python
if [ $? -eq 1 ]; then
  install python || exit 1
fi
has_feature make
if [ $? -eq 1 ]; then
  install make || exit 1
fi
has_feature htop
if [ $? -eq 1 ]; then
  install htop || exit 1
fi

# X display server
has_feature X
if [ $? -eq 1 ]; then
  install xorg-server || exit 1
fi

has_feature xinit
if [ $? -eq 1 ]; then
  install xorg-xinit || exit 1
fi

# window manager
has_feature dmenu
if [ $? -eq 1 ]; then
  install dmenu || exit 1
fi
has_feature i3
if [ $? -eq 1 ]; then
  install i3-wm || exit 1
fi

#
has_feature help2man
if [ $? -eq 1 ]; then
  install help2man || exit 1
fi

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
has_feature gnome-keyring
if [ $? -eq 1 ]; then
  install gnome-keyring || exit 1
fi
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

has_feature automake
if [ $? -eq 1 ]; then
  install automake || exit 1
fi

#battery
has_feature acpi
if [ $? -eq 1 ]; then
  install acpi  || exit 1
fi

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

has_feature xterm
if [ $? -eq 1 ]; then
  install xterm || exit 1
fi

has_feature zsh
if [ $? -eq 1 ]; then
  install zsh || exit 1
fi

#xclip
has_feature xclip
if [ $? -eq 1 ]; then
  install xclip || exit 1
fi

has_feature javac
if [ $? -eq 1 ]; then
  install jdk8-openjdk
fi

has_feature pkg-config
if [ $? -eq 1 ]; then
  install pkg-config
fi

has_feature keepassxc
if [ $? -eq 1 ]; then
  install keepassxc
fi

has_feature cscope
if [ $? -eq 1 ]; then
  install cscope
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
