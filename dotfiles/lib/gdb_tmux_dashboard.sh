#!/bin/bash

# BUG
# can not have multiple instance of gdb-dashboard at one time

# help
# >>> dashboard expressions watch *expression*

# TODO
# cheatsheet

echo "$@"
echo "$0 $1 $2 $3 $4 $5"

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
  echo "gdb is allready running"
  # exit 1
fi
#---------------------------------------
TEMP_DIR=`mktemp -d /tmp/tmp.XXXXXXXXXXXXXX`
FIFO_PIPE=$TEMP_DIR/fifo
# echo $FIFO_PIPE

mkfifo $FIFO_PIPE || exit 1

# (prefix+q) print "-t" id
# (prefix+&) close window

# do not grey out inactive window
tmux new-window -n "gdb"
tmux set-option window-style 'fg=colour250,bg=black'
tmux set-option window-active-style 'fg=colour250,bg=black'

# [memory][threads,expression]
tmux split-window -v -p 15
tmux send-keys "echo \"memory_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE" C-m

# [source][assembly]
tmux select-pane -t 1
tmux split-window -h -p 55
tmux send-keys "echo \"source_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE" C-m

# [registers]
tmux split-window -h -p 20
tmux send-keys "echo \"registers_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE" C-m
tmux send-keys "echo \"breakpoints_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE" C-m

# [assembly]
tmux split-window -v -p 25 -t 2
tmux send-keys "echo \"assembly_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE" C-m

# tmux select-pane -t 7
#'echo "s+h"' # [stack,history]
tmux split-window -v -t 1
tmux send-keys "echo \"history_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE" C-m
tmux send-keys "echo \"stack_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE" C-m

#'echo "s+h"' # [threads,expression]
tmux split-window -h -t 6
tmux send-keys "echo \"threads_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE" C-m
tmux send-keys "echo \"expression_TTY=\\\"\`tty\`\\\"\" > $FIFO_PIPE" C-m
#---------------------

tmux select-pane -t 1 || exit 1
# tmux send-keys "cat $FIFO_PIPE" C-m

# gdb!!
echo "gdb --args $@"
tmux send-keys "gdb --args '$1' '$2' '$3' '$4' '$5' '$6' '$7' '$8' '$9' '${10}'" C-m

#---configure-dashboard------------------
# source lines
tmux send-keys "dashboard source -style context 21" C-m
tmux send-keys "dashboard assembly -style context 6" C-m
tmux send-keys "dashboard stack -style locals True" C-m
tmux send-keys "dashboard stack -style limit 1" C-m
tmux send-keys "dashboard -style syntax_highlighting \"monokai\"" C-m
# dashboard -style syntax_highlighting "paraiso-dark"

tmux send-keys "b main" C-m

# save breakpoints to file
# >>> save breakpoints .gdb_breakpoints
# load breakpoints from file
# >>> source .gdb_breakpoints
BREAKPOINT_FILE='.gdb_breakpoints'
if [ -e $BREAKPOINT_FILE ]; then
  tmux send-keys "source $BREAKPOINT_FILE" C-m
fi

#---
REGIONS=("assembly" "history" "memory" "registers" "source" "stack" "threads" "expression" "breakpoints")

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

for REGION in "${REGIONS[@]}"; do
  eval "REGION_TTY=\$${REGION}_TTY"
  tmux send-keys "dashboard ${REGION}    -output $REGION_TTY" C-m
done

# gdb run!
tmux send-keys "r" C-m
