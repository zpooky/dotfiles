#=================== {
if [ "$(whoami)" = "fredriol" ]; then
  source $HOME/dotfiles/workrc
fi
# }

#=================== {
source $HOME/dotfiles/extrarc

export LANG=en_US.UTF-8
# locale - format dates according to Swedish standards (24h clock)
export LC_TIME=sv_SE.UTF-8

# keybindings
# ctrl+left/ctrl+right navigate word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# <del> delete char
bindkey "\e[3~" delete-char

# <alt+backspace> to delete word
autoload -U select-word-style && select-word-style bash

# Use modern completion system
if [ -e $HOME/sources/zsh-completions ]; then
  fpath=($HOME/sources/zsh-completions $fpath)
fi

autoload -U compinit && compinit -u
#

#
autoload -U colors
colors

# <ctrl+w> Kill line right
bindkey '^W' kill-line

# {{{
function preexec() {
  sp_zsh_timer_start=${sp_zsh_timer_start:-$SECONDS}
  # timer=$(($(date +%s%N)/1000000))
}

function precmd() {
  setopt prompt_subst
  local LAST_EXIT_CODE=$?
# https://stackoverflow.com/questions/33839665/multiline-prompt-formatting-incorrectly-due-to-date-command-in-zsh/33839913#33839913
  local sp_zsh_timer_show=0
  local sp_hostname=$(hostname)
  local sp_time=$(date "+%H:%M:%S")

  if [ $sp_zsh_timer_start ]; then
    # TODO ms
    # now=$(($(date +%s%N)/1000000))
    # elapsed=$(($now-$timer))

    sp_zsh_timer_show=$(($SECONDS - $sp_zsh_timer_start))
    sp_zsh_timer_show=$(printf '%.*fs' 1 $sp_zsh_timer_show)
    unset sp_zsh_timer_start
  fi

  local ret_code='{green}'
  if [ ! ${LAST_EXIT_CODE} -eq 0 ]; then
    ret_code='{red}'
  fi
  local preprompt_left='%B%~%{$fg[yellow]%}:%{$reset_color%}'
  local preprompt_right="[%F${ret_code}${LAST_EXIT_CODE}%f][%F{green}${sp_zsh_timer_show}%f]%F{red}%(1j.[⌘%j].)%f[${sp_time}][${sp_hostname}]"
  local preprompt_left_length=${#${(S%%)preprompt_left//(\%([KF1]|)\{*\}|\%[Bbkf])}}
  local preprompt_right_length=${#${(S%%)preprompt_right//(\%([KF1]|)\{*\}|\%[Bbkf])}}
  local num_filler_spaces=$((COLUMNS - preprompt_left_length - preprompt_right_length))
  print -Pr $'\n'"$preprompt_left${(l:$num_filler_spaces:)}$preprompt_right"
}

function set-prompt() {
  #PS
  # %d    - current directory
  # $'\n' - newline
  # %#    - promptchar
  # %B    - bold
  # %b    - bold end
  # %?    - return status of last command
  # %~    - cwd
  local RED="\e[0;31m"
  local NO_COLOR="\e[0m"
  local NEWLINE=$'\n'

  if [[ $EUID -eq 0 ]]; then
    local SUFFIX='#'
  else
    # local SUFFIX='>'
    local SUFFIX='»'
  fi
  local INTTERNAL_NBSP=$'\u00A0'
  PROMPT="%{$fg[red]%}%B${SUFFIX}%{$reset_color%}%b${INTTERNAL_NBSP}"

  # turnery styled %(1j.true.false)
  # this is displayed on the far right side
  # %S - standout start
  # %s - standout stop
  # %F{color} - foreground color
  # %f        - foreground color standard
  # %K{color} - background color
  # %k        - background color standard
  local sp_hostname=$(hostname)
}

set-prompt

unset -f set-prompt
# }}}

# }

HISTFILE="$HOME/.zhistory"
# The maximum number of events to save in the internal history.
HISTSIZE=10000000
# The maximum number of events to save in the history file.
SAVEHIST=10000000

#=================== {
setopt AUTO_CD                    # [default] .. is shortcut for cd .. (etc)
setopt INC_APPEND_HISTORY         # Add commands to history as they are entered, don't wait for shell to exit
setopt HIST_EXPIRE_DUPS_FIRST     # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS           # Do not record an entry that was just recorded again.
setopt HIST_REDUCE_BLANKS         # Remove superfluous blanks before recording entry.

setopt HIST_IGNORE_ALL_DUPS       # If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event). 

setopt noflowcontrol              # disable <ctrl+s>, <ctrl+q> flow control
setopt globdots                   # show directories starting with . when tabbing

# }




#=================== {
# TODO fi
function f(){
  # TODO if both ^$ then we can use -iname
  if [[ -z "${1}" ]]; then
    echo "missing param">&2
    return 1
  fi
  # [^/]* any not /

  local p="${1}"
  if [[ ! "${p}" =~ '^\^.*' ]]; then
    # $p does not start with ^
    local p="[^/]*${p}"

    # -regex matches the complete path limit to filename part by prefixing .*/
    local p=".*/${p}"
  else
    # strip `^`
    local x=${p:1:1000000}
    # create `^.*/${p}`
    local p="^.*/${x}"
    # `/` is start of filename aka regex: `^`
  fi

  if [[ ! "${p}" =~ '.*\$$' ]]; then
    local p="${p}[^/]*"
  fi

  # find . -type d \( -path dir1 -o -path dir2 -o -path dir3 \) -prune -o -print
  # local exclude="-path .git -prune -o"
  # local ex="-type d \( -name 'tmp' \) -prune -o"
  # local ex2=' -not -path "*/tmp/*"'
  local ex3='! -path "*/tmp/*" ! -path "*/.git/*" ! -path "*/.ccls-cache/*"'
  if [ "${PWD}" = "${HOME}" ]; then
    ex3="${ex3} ! -path '$HOME/dists/*' ! -path '~/dists/*' ! -path './dists/*'"
  fi

  local cmd="find . -regextype egrep -iregex \"${p}\" ${ex3}"
  echo "${cmd}">&2
  eval "${cmd}"

  # find . -regextype egrep -regex "\"${p}\"" ${ex3}
  #find -iname "*${p}*"
}

function agf(){
  local ft="${1}"
  shift
  echo "find . -name \"*.${ft}\" -print0 | xargs -0 -n1 grep \"$@\" /dev/null">&2
  # find . -name "*.${ft}" -print0 | xargs -0 -n1 echo

  find . -name "*.${ft}" -print0 | xargs -0 -n1 grep "$@" /dev/null
}

if [[ $TERM = "" ]] || [[ -z $TERM ]]; then
  # export TERM="xterm-256color"
fi


alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'

# Emacs mode
bindkey -e
# [Delete] - delete forward
bindkey -M emacs "^[[3~" delete-char
# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word
# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
# }

# # {{{
# function xxcopybuffer () {
#   if which clipcopy &>/dev/null; then
#     echo $BUFFER | clipcopy
#     # notify-send "${BUFFER}" "copy"
#   else
#     echo "clipcopy function not found. Please make sure you have Oh My Zsh installed correctly."
#   fi
# }
#
# zle -N xxcopybuffer
#
# # ^f12
# bindkey "^[[24;5~" xxcopybuffer
# #}}}

# TODO document
# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' menu select=2
#
# eval "$(dircolors -b)"
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#
# zstyle ':completion:*' menu select=long
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
#
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#=================== {
zstyle ':completion:*' special-dirs true  # to make `cd ..<tab>` work
# zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename "$HOME/.zshrc"
# }

if [ -e $HOME/sources/fzf/bin ]; then
  export FZF_BASE=$HOME/sources/fzf
  export PATH=$PATH:$FZF_BASE/bin
  # <ctrl+r> = history
  # <alt+c> = cd (dir) search
  source $FZF_BASE/shell/completion.zsh
  source $FZF_BASE/shell/key-bindings.zsh
fi

if [ -e $HOME/sources/zsh-autosuggestions ]; then
  source $HOME/sources/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
