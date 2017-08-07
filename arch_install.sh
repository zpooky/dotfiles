$HOME/dotfiles/shared.sh

#video player
echo "#mpv"
has_feature mpv
if [ $? -eq 1 ]; then
  pacman -S mpv || exit 1
fi

#
has_feature guake
if [ $? -eq 1 ]; then
  pacman -S guake || exit 1
fi
has_feature chromium
if [ $? -eq 1 ]; then
  pacman -S chromium || exit 1
fi
# to make install work
has_feature sudo
if [ $? -eq 1 ]; then
  pacman -S sudo || exit 1
fi
has_feature python2
if [ $? -eq 1 ]; then
  pacman -S python2 || exit 1
fi
has_feature cmake
if [ $? -eq 1 ]; then
  pacman -S cmake || exit 1
fi
has_feature clang
if [ $? -eq 1 ]; then
  pacman -S clang || exit 1
fi
has_feature python
if [ $? -eq 1 ]; then
  pacman -S python || exit 1
fi
has_feature make
if [ $? -eq 1 ]; then
  pacman -S make || exit 1
fi
has_feature lua52
if [ $? -eq 1 ]; then
  pacman -S lua52 || exit 1
fi
has_feature htop
if [ $? -eq 1 ]; then
  pacman -S htop || exit 1
fi

# X display server
has_feature xorg-server
if [ $? -eq 1 ]; then
  pacman -S xorg-server || exit 1
fi
has_feature xorg-xinit
if [ $? -eq 1 ]; then
  pacman -S xorg-xinit || exit 1
fi

# window manager
has_feature dmenu
if [ $? -eq 1 ]; then
  pacman -S dmenu || exit 1
fi
has_feature i3-wm
if [ $? -eq 1 ]; then
  pacman -S i3-wm || exit 1
fi

#
has_feature help2man
if [ $? -eq 1 ]; then
  pacman -S help2man || exit 1
fi

# daemon to watch for acpi event like backligt power up/down
has_feature acpid
if [ $? -eq 1 ]; then
  pacman -S acpid || exit 1
  systemctl enable acpid
  systemctl start acpid
  systemctl status acpid
fi

# cron
has_feature cronie
if [ $? -eq 1 ]; then
  pacman -S cronie || exit 1
  systemctl enable cronie.service
  systemctl start cronie.service
fi

#keyring
has_feature gnome-keyring
if [ $? -eq 1 ]; then
  pacman -S gnome-keyring || exit 1
fi
has_feature seahorse
if [ $? -eq 1 ]; then
  pacman -S seahorse || exit 1
fi
has_feature python2-gnomekeyring
if [ $? -eq 1 ]; then
  pacman -S python2-gnomekeyring || exit 1
fi

#
has_feature ntp
if [ $? -eq 1 ]; then
  pacman -S ntp || exit 1
  systemctl enable ntpd.service
  systemctl start ntpd.service
  timedatectl
fi

has_feature automake
if [ $? -eq 1 ]; then
  pacman -S automake || exit 1
fi

#battery
has_feature acpi
if [ $? -eq 1 ]; then
  pacman -S acpi  || exit 1
fi

#haskell
has_feature ghc-static
if [ $? -eq 1 ]; then
  pacman -S ghc-static || exit 1
fi
has_feature ghc
if [ $? -eq 1 ]; then
  pacman -S ghc || exit 1
fi
has_feature cabal-install
if [ $? -eq 1 ]; then
  pacman -S cabal-install || exit 1
fi

#xclip

