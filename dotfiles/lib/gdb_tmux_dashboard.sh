#!/bin/bash

# BUG
# can not have multiple instance of gdb-dashboard at one time

# help
# >>> dashboard expressions watch *expression*

TEMP_FILE=`mktemp`
touch $TEMP_FILE

# (prefix+q) print "-t" id
# (prefix+&) close window

tmux new-window -n "gdb"
tmux set-option window-style 'fg=colour250,bg=black'
tmux set-option window-active-style 'fg=colour250,bg=black'

# [memory][threads,expression]
tmux split-window -v -p 15
tmux send-keys "echo \"MEMORY_TTY=\\\"\`tty\`\\\"\" >> $TEMP_FILE" C-m

# [source][assembly]
tmux select-pane -t 1
tmux split-window -h -p 55
tmux send-keys "echo \"SOURCE_TTY=\\\"\`tty\`\\\"\" >> $TEMP_FILE" C-m

# [registers]
tmux split-window -h -p 20
tmux send-keys "echo \"REGISTERS_TTY=\\\"\`tty\`\\\"\" >> $TEMP_FILE" C-m

# [assembly]
tmux split-window -v -p 25 -t 2
tmux send-keys "echo \"ASSEMBLY_TTY=\\\"\`tty\`\\\"\" >> $TEMP_FILE" C-m

# tmux select-pane -t 7
#'echo "s+h"' # [stack,history]
tmux split-window -v -t 1
tmux send-keys "echo \"HISTORY_TTY=\\\"\`tty\`\\\"\" >> $TEMP_FILE" C-m
tmux send-keys "echo \"STACK_TTY=\\\"\`tty\`\\\"\" >> $TEMP_FILE" C-m

#'echo "s+h"' # [threads,expression]
tmux split-window -h -t 6
tmux send-keys "echo \"THREADS_TTY=\\\"\`tty\`\\\"\" >> $TEMP_FILE" C-m
tmux send-keys "echo \"EXPRESSION_TTY=\\\"\`tty\`\\\"\" >> $TEMP_FILE" C-m
#---------------------

tmux select-pane -t 1 || exit 1
# tmux send-keys "cat $TEMP_FILE" C-m

#race condition
sleep 2
source $TEMP_FILE

# tmux send-keys "echo \$TTY_1" C-m

tmux send-keys "gdb $@" C-m
tmux send-keys "dashboard assembly -output $ASSEMBLY_TTY" C-m
tmux send-keys "dashboard history -output $HISTORY_TTY" C-m
tmux send-keys "dashboard memory -output $MEMORY_TTY" C-m
tmux send-keys "dashboard registers -output $REGISTERS_TTY" C-m
tmux send-keys "dashboard source -output $SOURCE_TTY" C-m
tmux send-keys "dashboard stack -output $STACK_TTY" C-m
tmux send-keys "dashboard threads -output $THREADS_TTY" C-m
tmux send-keys "dashboard expression -output $EXPRESSION_TTY" C-m


#---configure-dashboard------------------
# source lines
tmux send-keys "dashboard source -style context 21" C-m
tmux send-keys "dashboard assembly -style context 6" C-m
tmux send-keys "dashboard stack -style locals True" C-m
tmux send-keys "dashboard stack -style limit 1" C-m
tmux send-keys "dashboard -style syntax_highlighting \"monokai\"" C-m
# dashboard -style syntax_highlighting "paraiso-dark"

tmux send-keys "b main" C-m
tmux send-keys "r" C-m
