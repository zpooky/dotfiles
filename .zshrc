# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# oh-my-zsh plugins
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions cabal pip python fzf docker)

DISABLE_AUTO_UPDATE="true"

source $ZSH/oh-my-zsh.sh

function preexec() {
  sp_zsh_timer_start=${sp_zsh_timer_start:-$SECONDS}
  # timer=$(($(date +%s%N)/1000000))
}

function precmd() {
  if [ $sp_zsh_timer_start ]; then
    # TODO ms
    # now=$(($(date +%s%N)/1000000))
    # elapsed=$(($now-$timer))

    sp_zsh_timer_show=$(($SECONDS - $sp_zsh_timer_start))
    sp_zsh_timer_show=$(printf '%.*fs' 1 $sp_zsh_timer_show)
    unset sp_zsh_timer_start
  fi
}

export LANG=en_US.UTF-8

# keybindings
# ctrl+left/ctrl+right navigate word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# <del> delete char
bindkey "\e[3~" delete-char

# <alt+backspace> to delete word
autoload -U select-word-style
select-word-style bash

# <ctrl+w> Kill line right
bindkey '^W' kill-line

#PS
# %d    - current directory
# $'\n' - newline
# %#    - promptchar
# %B    - bold
# %b    - bold end
# %?    - return status of last command
# %~    - cwd
RED="\e[0;31m"
NO_COLOR="\e[0m"
NEWLINE=$'\n'
autoload -U colors && colors

if [[ $EUID -eq 0 ]]; then
  local SUFFIX='#'
else
  # local SUFFIX='>'
  local SUFFIX='»'
fi

local INTTERNAL_NBSP=$'\u00A0'
PROMPT="%B${NEWLINE}%~%{$fg[yellow]%}:%{$reset_color%}${NEWLINE}%{$fg[red]%}%B$SUFFIX%{$reset_color%}%b${INTTERNAL_NBSP}"

# turnery styled %(1j.true.false)
# this is displayed on the far right side
RPROMPT='[%F{yellow}%?%f][%F{green}$sp_zsh_timer_show%f][%F{red}%(1j.⌘%j.)%f]'

## Set up the prompt
#autoload -Uz promptinit
#promptinit
#prompt walters
# }

HISTFILE="$HOME/.zhistory"
# The maximum number of events to save in the internal history.
HISTSIZE=10000000
# The maximum number of events to save in the history file.
SAVEHIST=10000000

#=================== {
setopt HIST_EXPIRE_DUPS_FIRST    	# Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS 					# Do not record an entry that was just recorded again.
setopt HIST_REDUCE_BLANKS         # Remove superfluous blanks before recording entry.
# }

# disable <ctrl+s>, <ctrl+q> flow control
setopt noflowcontrol

# Use modern completion system
autoload -Uz compinit
compinit

#=================== {
alias ll="ls -alh --color=tty"
alias pacman="pacmatic "

if [[ $TERM = "" || -z $TERM ]]; then
  export TERM="xterm-256color"
fi

# Emacs mode
bindkey -e

# }

# TODO document
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2

eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#=================== {
zstyle ':completion:*' special-dirs true  # to make `cd ..<tab>` work
# zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "$HOME/.zshrc"
# }

#
source ~/dotfiles/extrarc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
