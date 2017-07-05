#sound
pavucontrol??

##ALSA
- built in kernel module
- Sound device drivers.
- api and library for userspace applications to acces sound devices
###config
system:/etc/asound.conf
user:~/.asoundrc

## Pulseaudio
PulseAudio serves as a proxy to sound applications using existing _kernel_ sound components: ALSA(not libalsa).

##keyboard shortcuts
##mixer
##3.5mm
##external sound card
##bluetooth sound card

#backlight
- shortcut: fn(windows)+page up/down
- application: light
- keymapping configured with i3


#networking
##networking service
##wifi
###turn on/off
###indicate if wifi is on

#bluetooth
##turn off/on
###indicate if bluethooth is on

#graphic
##intel
##nvidia

#i3 window manager
- fn key is rebound to windows and vice versa
#keymappings
- prefix: win(fn)
- reload i3status bar: prefix+shift+r
- worskapce: prefix(win(fn))+[0-9]
- exit app: prefix+shift+q
- change app focus: prefix+left/right
- fullscreen toogle: prefix+f

##status bar(i3)
/etc/i3status.conf
##keyboard mapping
~/.config/i3/config
