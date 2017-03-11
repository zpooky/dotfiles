# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/spooky/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias ll="ls -alh"
alias nas540="sshfs admin@192.168.1.12:/i-data/ mount/nas540"

# if [[ $TERM = "" ]];then
  export TERM="xterm-256color"
# fi

export LANG=en_US.UTF-8

# prints announcements
alias pacman="pacmatic"
