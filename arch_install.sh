#video player
echo "#mpv"
pacman -S mpv || exit 1

#
pacman -S guake || exit 1
pacman -S chromium || exit 1
# to make install work
pacman -S sudo || exit 1
pacman -S python2 || exit 1
pacman -S cmake || exit 1
pacman -S clang || exit 1
pacman -S python || exit 1
pacman -S make || exit 1
pacman -S lua52 || exit 1
pacman -S htop || exit 1

# X display server
sudo pacman -S xorg-server || exit 1
sudo pacman -S xorg-xinit || exit 1

# window manager
sudo pacman -S dmenu i3-wm || exit 1

#
sudo pacman -S help2man || exit 1

# daemon to watch for acpi event like backligt power up/down
sudo pacman -S acpid || exit 1
sudo systemctl enable acpid
sudo systemctl start acpid
sudo systemctl status acpid

# cron
sudo pacman -S cronie || exit 1
systemctl enable cronie.service
systemctl start cronie.service

#keyring
sudo pacman -S gnome-keyring || exit 1
sudo pacman -S seahorse || exit 1
sudo pacman -S python2-gnomekeyring || exit 1

#
sudo pacman -S ntp || exit 1
systemctl enable ntpd.service
systemctl start ntpd.service
timedatectl

pacman -S automake || exit 1

#battery
pacman -S acpi  || exit 1

#haskell
sudo pacman -S ghc-static || exit 1
sudo pacman -S ghc || exit 1
sudo pacman -S cabal-install || exit 1

#xclip

