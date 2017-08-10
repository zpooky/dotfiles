#pacman update
sudo pacman -Syuw # download packages
sudo pacman -Su # install packages

#stuff
sudo pacman -Syyu # update package database
pacman -Ss python2 # search


yaourt -Syu --aur # aur upgrade

#video player
pacman -S mpv

#keepass
pacman -S keepassxc

#list hardware
lspci
# eth interfaces
ip address
dhcpd *inteface*

# to make install work
pacman -S sudo
pacman -S python2
pacman -S cmake
pacman -S clang
pacman -S python
pacman -S make
pacman -S lua52
pacman -S htop

# language
#TODO /etc/locale.conf LC_ALL
edit /etc/locale.gen # en_GB, sv_SE
#use sudo !!
sudo locale-gen
# current configuration
localectl status
'cat /etc/vconsole.conf
KEYMAP=sv-latin1'

`cat /etc/locale.conf
LANG=en_GB.UTF-8
LANGUAGE=en_GB.UTF-8`

# list available keymaps
localectl list-keymaps
find /usr/share/kbd/keymaps -type f | grep sv

`cat /etc/vconsole.conf
KEYMAP=sv-latin1`
# ! configure x
localectl set-keymap se
localectl set-x11-keymap se

xmodmap -pke | less

printenv

#nvidia driver
lspci -k | grep -A 2 -E '(VGA|3D)'
pacman -S nvidia nvidia-settings nvidia-libgl

# X display server
sudo pacman -S xorg-server
sudo pacman -S xorg-xinit

# window manager
sudo pacman -S dmenu i3

# Display manager aka login manager
# is a user interface displayed at  the end of the boot process in place of the default shell.

# backlight
ll /sys/class/backlight
sudo pacman -S help2man
https://aur.archlinux.org/packages/light
echo 25 > /sys/class/backlight/intel_backlight/brightness

# daemon to watch for acpi event like backligt power up/down
sudo pacman -S acpid
sudo systemctl enable acpid
sudo systemctl start acpid
sudo systemctl status acpid
## debug
acpi_listen # press on keyboard baclkigt power up/down

# install aur
# PKGBUILD
makepkg -Acs
sudo pacman -U clipster-git-0.211.dfa75b5-1-any.pkg.tar.xz
#

# font
# "Monospace" is an alias for another font.  To see what font will be used when an application calls for the "Monospace" font, try
fc-match monospace
# list instaleld fonts
ll /etc/fonts/conf.avail
# installed a monospace font
sudo pacman -S ttf-dejavu
# how it works
vim /etc/fonts/conf.d/README

#audio (ALSA-kernel component providing device drivers and lowest-level support for audio hardware)
sudo pacman -S alsa-utils
## sudo alsamixer
M - toggle mute
+/- volume up/down

# bluetooth audio
sudo pacman -S pulseaudio
sudo pacman -S pulseaudio-alsa
sudo pacman -S pulseaudio-bluetooth
sudo pacman -S bluez
sudo pacman -S bluez-libs
sudo pacman -S bluez-utils
sudo pacman -S bluez-firmware
systemctl status bluetooth.service
systemctl enable bluetooth.service
systemctl start bluetooth.service

#
sudo pacman -S pulseaudio-equalizer
sudo pacman -S pavucontrol
#Load equalizer module and dbus control

pactl load-module module-equalizer-sink
#TODO

# cron
sudo pacman -S cronie
systemctl enable cronie.service
systemctl start cronie.service
#keyring
sudo pacman -S gnome-keyring
sudo pacman -S seahorse
sudo pacman -S python2-gnomekeyring

# dropbox AUR
https://aur.archlinux.org/packages/dropbox/
sudo systemctl enable dropbox@spooky.service
# spotify
https://aur.archlinux.org/packages/spotify/
# yaourt
https://aur.archlinux.org/packages/yaourt/
sudo pacman -S ntp
systemctl enable ntpd.service
timedatectl
#wireless
dmesg | grep ath10k
ll /lib/firmware/ath10k/QCA6174/hw3.0
#wireless-config
netctl
sudo wifi-menu
pacman -S linux-firmware
iw dev #list wireless interfaces
iw dev wlp62s0 link # status of interface
ll /etc/netctl/ # db of connection data
sudo ip link set eth0 down # turn of interface
#network
ethtool enp61s0 # status
systemctl enable dhcpd@enp61s0
systemctl start dhcpd@enp61s0

#
pacman -S automake
#debug
!!TODO journalctl -xe

#battery
pacman -S acpi 
acpi

nvidia-xconfig --query-gpu-info
pacman -Q | grep pacakge # search
pacman -Qe | less #installed packages
dmesg -H
systemctl --type=service

#status of services
systemctl

#haskell
sudo pacman -S ghc-static
sudo pacman -S ghc
sudo pacman -S cabal

#blacklist
/etc/modprobe.d/nouveau.conf

#grub
##update
grub-mkconfig -o /boot/grub/groub.cfg

# bootloader
boot

#user
adduser spooky
passwd spooky
groupadd sudo
usermod-a -G sudo spooky
visudo -f /etc/sudoers # uncomment sudo group access
