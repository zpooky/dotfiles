#sound
pavucontrol??

##ALSA
- built in kernel module
- Sound device drivers.
- api and library for userspace applications to acces sound devices

###Installation
sudo pacman -S alsa-utils

###Application
- alsamixer

###mute/unmute/toggle
amixer sset Master unmute
amixer sset Master mute
amixer set Master toggle

###config
system:/etc/asound.conf
user:~/.asoundrc

###test audio
speaker-test -c 2 # test 2.0

## Pulseaudio
PulseAudio serves as a proxy to sound applications using existing _kernel_ sound module: ALSA(not libalsa).

###Installation
sudo pacman -S pulseaudio pavucontrol pulseaudio-alsa pulseaudio-equalizer
--bluetooth headset
sudo pacman -S pulseaudio-bluetooth bluez bluez-lib bluez-utils

###Debug
pulseaudio -vvv
http://www.pclinuxos.com/forum/index.php?topic=135912.30

###Application
- pavucontrol
- pactl
- pacmd     #configure a server during runtime

##keyboard shortcuts
##mixer
- pavucontrol
##external sound card
- pavucontrol
##bluetooth sound card
TODO
##restart default mute
TODO
## lower application sound level
TODO
## heaphones disable speakers
TODO

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
## window
- prefix+*number* - goto workspace
- ctrl+prefix+*number* - send current active program to *number*

##status bar(i3)
/etc/i3status.conf
##keyboard mapping
~/.config/i3/config
