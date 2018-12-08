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

## headset
rfkill list
rfkill unblock bluetooth
systemctl status bluetooth
systemctl start bluetooth.service

-- has to run before
pulseaudio --start

bluetoothctl
  power on
  agent on
  default-agent
  scan on
  pair 00:1B:66:81:01:60
  connect 00:1B:66:81:01:60
  trust 00:1B:66:81:01:60
  scan off

[CHG] Controller 9C:B6:D0:14:3F:64 Discovering: yes
[NEW] Device 00:1B:66:81:01:60 00-1B-66-81-01-60
[CHG] Device 00:1B:66:81:01:60 LegacyPairing: no
[CHG] Device 00:1B:66:81:01:60 Name: MOMENTUM M2 AEBT
[CHG] Device 00:1B:66:81:01:60 Alias: MOMENTUM M2 AEBT
[CHG] Device 00:1B:66:81:01:60 LegacyPairing: yes

#graphic
##intel
##nvidia

#i3
##status bar(i3)
/etc/i3status.conf
##keyboard mapping
~/.config/i3/config
