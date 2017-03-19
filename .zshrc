# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias ll="ls -alh"
alias nas540="sshfs admin@192.168.1.12:/i-data/ $HOME/mount/nas540"

# if [[ $TERM = "" ]];then
  export TERM="xterm-256color"
# fi

export LANG=en_US.UTF-8

# prints announcements
alias pacman="pacmatic"

source $HOME/dotfiles/extrarc

#PS
# %d    - current directory
# $'\n' - newline
# %#    - promptchar
# %B    - bold
# %b    - bold end
RED="\e[0;31m"
NO_COLOR="\e[0m"
NEWLINE=$'\n'
autoload -U colors && colors
PROMPT="%B${NEWLINE}%d%{$fg[yellow]%}:%{$reset_color%}${NEWLINE}%{$fg[red]%}>%{$reset_color%} %b"
