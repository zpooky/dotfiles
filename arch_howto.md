#sound
pavucontrol

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
PulseAudio serves as a proxy to sound applications using existing _kernel_ sound
module: ALSA(not libalsa)

###Debug
pulseaudio -vvv
http://www.pclinuxos.com/forum/index.php?topic=135912.30

###Application
- pavucontrol # mixer
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
#eth
dhcpd enp61s0
systemctl status dhcpcd@enp61s0.service                                                                          [0]

##networking service
##wifi
sudo wifi-menu
###turn on/off
###indicate if wifi is on

#bluetooth
##turn off/on
###indicate if bluethooth is on

#graphic
##intel
##nvidia

#i3
##status bar(i3)
/etc/i3status.conf
##keyboard mapping
~/.config/i3/config

# local
/etc/locale.gen:
```
sv_SE.UTF-8 UTF-8
en_US.UTF-8 UTF-8
```
/etc/locale.conf:
```
LANG=sv_SE.UTF-8
```
$ locale-gen

$ localectl status
$ localectl --no-convert set-x11-keymap se
/etc/X11/xorg.conf.d/00-keyboard.conf:
```
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "se"
        Option "XkbOptions" "caps:escape" # manually added
EndSection
```


# light
user needs to be part of video group in order to write the backlight sysfs file
sudo usermod -a -G video spooky
