# we are in non interactive mode wehn for example in vim when :!ls
# if [[ ! -o interactive ]]; then
#   return 0
# fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# oh-my-zsh plugins
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions cabal gradle pip python sbt)

## zsh-users/zsh-autosuggestions
# bindkey '^ ' autosuggest-accept #bind (ctrl+space) to accept autosuggestion
##vi-mode
#increase vi-like functionality(https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins#vi-mode)

source $ZSH/oh-my-zsh.sh

# -------------------
# User configuration

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

# keybindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

sp-backward-kill-word(){
  local WORDCHARS=${WORDCHARS/\//}
  zle backward-delete-word
}
zle -N sp-backward-kill-word
bindkey '^W' sp-backward-kill-word

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

export SHELL=zsh

#history
HISTFILE="$HOME/.zhistory"
HISTSIZE=10000000
SAVEHIST=10000000

setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
