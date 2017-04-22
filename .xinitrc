setxkbmap -option caps:escape
#setxkbmap -v sv -variant qwerty
setxkbmap -layout sv -variant qwerty

# start gnome keyring
# seahorse gui
#http://unix.stackexchange.com/questions/265503/how-do-i-fix-no-such-secret-collection-at-path-for-gnome-keyring-and-arch-l
/etc/X11/xinit/xinitrc.d/50-systemd-user.sh
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

#enviornment variables
# TODO not working
export EDITOR='vim'

exec i3
