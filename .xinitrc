setxkbmap -option caps:escape
setxkbmap -layout se

# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto

# start gnome keyring
# seahorse gui
#http://unix.stackexchange.com/questions/265503/how-do-i-fix-no-such-secret-collection-at-path-for-gnome-keyring-and-arch-l
# /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
#eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

#enviornment variables
# TODO not working
export EDITOR='vim'

dbus-update-activation-environment --systemd DISPLAY

# exec i3
exec i3 -V > ~/i3.log 2>&1
# exec firefox  > ~/chrome.log 2>&1
