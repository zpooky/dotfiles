# eth interfaces
ip address
dhcpd *inteface*

#stuff
sudo pacman -Syyu # update package database
pacman -Ss python2 # search

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
LANG=en_UK.UTF-8
LANGUAGE=en_UK.UTF-8`

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
sudo pacman -S xorg-xbacklight
xbacklight -set 50 # brightness to 50%
xbacklight -inc 10 # increment %
ll /sys/class/backlight

# install aur
# PKGBUILD
makepkg -Acs
sudo pacman -U clipster-git-0.211.dfa75b5-1-any.pkg.tar.xz
su root
echo 25 > /sys/class/backlight/intel_backlight/brightness

# font
# "Monospace" is an alias for another font.  To see what font will be used when an application calls for the "Monospace" font, try
fc-match monospace
# list instaleld fonts
ll /etc/fonts/conf.avail
# installed a monospace font
sudo pacman -S ttf-dejavu

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
systemctl start bluetooth.service
