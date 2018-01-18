#!/bin/bash

# BUG
# can not have multiple instance of gdb-dashboard at one time

# help
# >>> dashboard expressions watch *expression*

# TODO
# cheatsheet

# echo "$@"
# echo "$0 $1 $2 $3 $4 $5"

if [ ! -e "${1}" ]; then
  echo "'$1' does not exist"
  exit 1
fi

if [[ ! -x "${1}" ]]; then
  echo "'$1' is not executable"
  exit 1
fi

pgrep gdb
if [ $? -eq 0 ]; then
  if [[ $(uname -s) =~ CYGWIN.* ]]; then
    echo "gdb is allready running"
    # exit 1
  fi
fi
#---------------------------------------
TEMP_DIR=`mktemp -d /tmp/tmp.XXXXXXXXXXXXXX`
FIFO_PIPE=$TEMP_DIR/fifo
# echo $FIFO_PIPE

mkfifo $FIFO_PIPE || exit 1

# (prefix+q) print "-t" id
# (prefix+&) close window

# do not grey out inactive window
# TODO split window without creating a shell

BASH_NO_HIST="unset HISTFILE"
ZSH_NO_HIST="${BASH_NO_HIST}"
NO_HIST="if [[ \${SHELL} =~ bash$ ]]; then ${BASH_NO_HIST}; else ${ZSH_NO_HIST}; fi"

tmux new-window -n "gdb"
# tmux set-option window-style 'fg=colour250,bg=black'
# tmux set-option window-active-style 'fg=colour250,bg=black'

# echo "m+te" # [memory][threads,expression]
tmux split-window -v -p 15
tmux send-keys "${NO_HIST}; echo \"memory_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE &" C-m

# echo "s" # [source][assembly
tmux select-pane -t 1
tmux split-window -h -p 55
tmux send-keys "${NO_HIST}; echo \"source_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE &" C-m

# echo "r+b" # [registers]
tmux split-window -h -p 20
tmux send-keys "${NO_HIST}; echo \"registers_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE &" C-m
tmux send-keys "${NO_HIST}; echo \"breakpoints_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE &" C-m

# echo "a" # [assembly]
tmux split-window -v -p 25 -t 2
echo "asplit"
tmux send-keys "${NO_HIST}; echo \"assembly_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE &" C-m

# tmux select-pane -t 7
# echo "s+h" # [stack,history]
tmux split-window -v -t 1
tmux send-keys "${NO_HIST}; echo \"history_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE &" C-m
tmux send-keys "${NO_HIST}; echo \"stack_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE &" C-m

# echo "t+e" # [threads,expression]
tmux split-window -h -t 6
tmux send-keys "${NO_HIST}; echo \"threads_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE &" C-m
tmux send-keys "${NO_HIST}; echo \"expression_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE &" C-m
#---------------------

tmux select-pane -t 1 || exit 1
# tmux send-keys "cat $FIFO_PIPE" C-m

# gdb!!
tmux send-keys "${NO_HIST}; gdb --args '$1' '$2' '$3' '$4' '$5' '$6' '$7' '$8' '$9' '${10}'" C-m

#---configure-dashboard------------------
# source lines
tmux send-keys "dashboard source -style context 21" C-m
tmux send-keys "dashboard assembly -style context 6" C-m
tmux send-keys "dashboard stack -style locals True" C-m
tmux send-keys "dashboard stack -style limit 1" C-m
tmux send-keys "dashboard -style syntax_highlighting \"monokai\"" C-m
# dashboard -style syntax_highlighting "paraiso-dark"

BREAKPOINT_FILE='.gdb_breakpoints'
grep "^break main$" "$BREAKPOINT_FILE"
if [ ! $? -eq 0 ]; then
  tmux send-keys "b main" C-m
fi

# save breakpoints to file
# >>> save breakpoints .gdb_breakpoints
# load breakpoints from file
# >>> source .gdb_breakpoints
if [ -e $BREAKPOINT_FILE ]; then
  tmux send-keys "source $BREAKPOINT_FILE" C-m
fi

#---
# "history" 
REGIONS=("assembly" "memory" "registers" "source" "stack" "threads" "expression" "breakpoints")

CONT=1
while [ $CONT -eq 1 ]; do
  let CONT=0
  eval `cat $FIFO_PIPE`
  for REGION in "${REGIONS[@]}"; do
    if [ ! -v "${REGION}_TTY" ]; then
      CONT=1
    fi
  done
done

# tmux send-keys "echo \$TTY_1" C-m

#disable print history
tmux send-keys "dashboard history -output /dev/null" C-m

for REGION in "${REGIONS[@]}"; do
  eval "REGION_TTY=\$${REGION}_TTY"
  tmux send-keys "dashboard ${REGION}    -output $REGION_TTY" C-m
done

# gdb run!
tmux send-keys "r" C-m
