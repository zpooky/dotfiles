source $HOME/dotfiles/shared.sh

#video player
has_feature mpv
if [ $? -eq 1 ]; then
  sudo pacman -S mpv || exit 1
fi

#
has_feature guake
if [ $? -eq 1 ]; then
  sudo pacman -S guake || exit 1
fi
has_feature chromium
if [ $? -eq 1 ]; then
  sudo pacman -S chromium || exit 1
fi
# to make install work
has_feature sudo
if [ $? -eq 1 ]; then
  sudo pacman -S sudo || exit 1
fi
has_feature python2
if [ $? -eq 1 ]; then
  sudo pacman -S python2 || exit 1
fi
has_feature cmake
if [ $? -eq 1 ]; then
  sudo pacman -S cmake || exit 1
fi
has_feature clang
if [ $? -eq 1 ]; then
  sudo pacman -S clang || exit 1
fi
has_feature python
if [ $? -eq 1 ]; then
  sudo pacman -S python || exit 1
fi
has_feature make
if [ $? -eq 1 ]; then
  sudo pacman -S make || exit 1
fi
has_feature htop
if [ $? -eq 1 ]; then
  sudo pacman -S htop || exit 1
fi

# X display server
has_feature X
if [ $? -eq 1 ]; then
  sudo pacman -S xorg-server || exit 1
fi

has_feature xinit
if [ $? -eq 1 ]; then
  sudo pacman -S xorg-xinit || exit 1
fi

# window manager
has_feature dmenu
if [ $? -eq 1 ]; then
  sudo pacman -S dmenu || exit 1
fi
has_feature i3
if [ $? -eq 1 ]; then
  sudo pacman -S i3-wm || exit 1
fi

#
has_feature help2man
if [ $? -eq 1 ]; then
  sudo pacman -S help2man || exit 1
fi

# daemon to watch for acpi event like backligt power up/down
has_feature acpid
if [ $? -eq 1 ]; then
  sudo pacman -S acpid || exit 1
  systemctl enable acpid
  systemctl start acpid
  systemctl status acpid
fi

# cron
has_feature crond
if [ $? -eq 1 ]; then
  sudo pacman -S cronie || exit 1
  systemctl enable cronie.service
  systemctl start cronie.service
fi

#keyring
has_feature gnome-keyring
if [ $? -eq 1 ]; then
  sudo pacman -S gnome-keyring || exit 1
fi
has_feature seahorse
if [ $? -eq 1 ]; then
  sudo pacman -S seahorse || exit 1
  sudo pacman -S python2-gnomekeyring || exit 1
fi

#
has_feature ntpd
if [ $? -eq 1 ]; then
  sudo pacman -S ntp || exit 1
  systemctl enable ntpd.service
  systemctl start ntpd.service
  timedatectl
fi

has_feature automake
if [ $? -eq 1 ]; then
  sudo pacman -S automake || exit 1
fi

#battery
has_feature acpi
if [ $? -eq 1 ]; then
  sudo pacman -S acpi  || exit 1
fi

#haskell
has_feature ghc
if [ $? -eq 1 ]; then
  sudo pacman -S ghc || exit 1
  sudo pacman -S ghc-static || exit 1
fi
has_feature cabal
if [ $? -eq 1 ]; then
  sudo pacman -S cabal-install || exit 1
fi

has_feature xterm
if [ $? -eq 1 ]; then
  sudo pacman -S xterm || exit 1
fi

has_feature zsh
if [ $? -eq 1 ]; then
  sudo pacman -S zsh || exit 1
fi

#xclip
has_feature xclip
if [ $? -eq 1 ]; then
  sudo pacman -S xclip || exit 1
fi

has_feature light
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/light.tar.gz"
fi

has_feature dropbox
if [ $? -eq 1 ]; then
  install_aur "https://aur.archlinux.org/cgit/aur.git/snapshot/dropbox.tar.gz"
fi

has_feature spotify
if [ $? -eq 1 ]; then
  install  "https://aur.archlinux.org/cgit/aur.git/snapshot/spotify.tar.gz"
fi

has_feature yaourt
if [ $? -eq 1 ]; then
  install  "https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz"
fi

has_feature lbdb
if [ $? -eq 1 ]; then
  install  "https://aur.archlinux.org/cgit/aur.git/snapshot/lbdb.tar.gz"
fi

has_feature davmail
if [ $? -eq 1 ]; then
  install  "https://aur.archlinux.org/cgit/aur.git/snapshot/davmail.tar.gz"
fi
