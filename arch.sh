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

# language
#TODO /etc/locale.conf LC_ALL
edit /etc/locale.gen # en_GB, sv_SE
#use sudo !!
sudo locale-gen
localectl status
'cat /etc/vconsole.conf
KEYMAP=sv-latin1'
`cat /etc/locale.conf
LANG=en_UK.UTF-8
LANGUAGE=en_UK.UTF-8`

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

