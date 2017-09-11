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
zstyle ':completion:*' special-dirs true  # to make `cd ..<tab>` work
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "$HOME/.zshrc"

# enable autocompletion
autoload -Uz compinit
compinit
# End of lines added by compinstall

alias ll="ls -alh"

if [[ $TERM = "" || -z $TERM ]];then
  export TERM="xterm-256color"
fi

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
#this is displayed on the far right side
# RPROMPT='[%F{yellow}%?%f]'

export SHELL=zsh

#history
HISTFILE="$HOME/.zhistory"
# The maximum number of events to save in the internal history.
HISTSIZE=10000000
# The maximum number of events to save in the history file.
SAVEHIST=10000000

setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_IGNORE_DUPS          # Do not record an entry that was just recorded again.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.

setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
