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

# Emacs mode
bindkey -e

# Vi mode
# bindkey -v
## reduce command/insert mode toogle to 0.1seconds
# export KEYTIMEOUT=1

export LANG=en_US.UTF-8

# prints announcements
alias pacman="pacmatic"

source $HOME/dotfiles/extrarc

#
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

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
PROMPT="%B${NEWLINE}%d%{$fg[yellow]%}:%{$reset_color%}${NEWLINE}%{$fg[red]%}%B>%{$reset_color%} %b"
