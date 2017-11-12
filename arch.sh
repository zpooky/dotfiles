#pacman update
sudo pacman -Syuw # download packages
sudo pacman -Su # install packages

#stuff
sudo pacman -Syyu # update package database
pacman -Ss python2 # search


yaourt -Syu --aur # aur upgrade

#list hardware
lspci
# eth interfaces
ip address
dhcpd *inteface*

#
# language
# https://wiki.archlinux.org/index.php/locale
#TODO /etc/locale.conf LC_ALL
vim /etc/locale.gen # en_US.UTF-8 UTF-8
#use sudo !!
sudo locale-gen
# current configuration
localectl status
localectl set-x11-keymap se
localectl set-locale LANG=en_US.UTF-8

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

# special keybindings
xmodmap -pke | less

printenv

#nvidia driver
lspci -k | grep -A 2 -E '(VGA|3D)'
# pacman -S nvidia nvidia-settings nvidia-libgl

# Display manager aka login manager
# is a user interface displayed at  the end of the boot process in place of the default shell.

# backlight
# light
ll /sys/class/backlight
echo 25 > /sys/class/backlight/intel_backlight/brightness

# acpid daemon to watch for acpi event like backligt power up/down
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
# turn of interface
sudo ip link set eth0 down
#network
ethtool enp61s0 # status
systemctl enable dhcpd@enp61s0
systemctl start dhcpd@enp61s0

#debug
journalctl -xe
dmesg

#battery
acpi

#x debug
# nvidia-xconfig --query-gpu-info
# pacman -Q | grep pacakge # search
# pacman -Qe | less #installed packages
# dmesg -H
# systemctl --type=service

#status of services
systemctl

#blacklist
example:
In` /boot/grub/grub.cfg` to blacklist nouveau
```cfg
linux	/vmlinuz-linux root=UUID=80b01856-8521-4ced-990f-0ec9e56fc92b rw  modprobe.blacklist=nouveau
```
# /etc/modprobe.d/nouveau.conf

#grub
##update
grub-mkconfig -o /boot/grub/groub.cfg

# bootloader
boot

#user
pacman -S sudo
adduser spooky
passwd spooky
groupadd sudo
usermod-a -G sudo spooky
visudo -f /etc/sudoers # uncomment sudo group access

#nfs
sudo mount 192.168.1.12:/i-data/0da29454/nfs/video /home/spooky/mount/video

