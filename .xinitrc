setxkbmap -option caps:escape
#setxkbmap -v sv -variant qwerty
setxkbmap -layout sv -variant qwerty

# start gnome keyring
/etc/X11/xinit/xinitrc.d/50-systemd-user.sh
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

exec i3
