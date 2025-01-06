#!/usr/bin/env bash

working_dir="$(mktemp -d ${TMPDIR}/sp_gdb.XXXXXXXXXXXXXX)"
FIFO_pipe="$(mktemp -u ${working_dir}/pipe.XXXXXXXXXXXXXX)"
# echo $FIFO_pipe

mkfifo $FIFO_pipe || exit 1

linux_root="/home/spooky/sources/linux-shallow"
vmlinux="${linux_root}/vmlinux"

source $HOME/dotfiles/lib/vimcpp/shared.sh

function pipe_tty() {
  # memory_TTY
  local name="${1}"
  local fifo_pipe="${2}"
  pipe_cmd="echo \"${name}=\\\"\`tty\`\\\"\" > ${fifo_pipe} &;sh"
}

function pipe_tty2() {
  # memory_TTY
  local name1="${1}"
  local name2="${2}"
  local fifo_pipe="${3}"

  local pipe_cmd1="echo \"${name1}=\\\"\`tty\`\\\"\" > ${fifo_pipe} &"
  local pipe_cmd2="echo \"${name2}=\\\"\`tty\`\\\"\" > ${fifo_pipe} &"
  pipe_cmd="${pipe_cmd1};${pipe_cmd2};sh"
}

# TODO include repo name in window name
tmux_new_window "sp_gdb2"
if [ ! $? -eq 0 ]; then
  echo "failed to spawn window"
fi

# tmux set-option -t ${window_id} window-style 'fg=colour250,bg=black'
# tmux set-option -t ${window_id} window-active-style 'fg=colour250,bg=black'

# echo "m+te" # [memory][threads,expression]
pipe_tty "memory_TTY" "${FIFO_pipe}"
tmux split-window -v -p 15 -t "${window_id}" "${pipe_cmd}" || exit 1

# echo "s" # [source][assembly
pipe_tty "source_TTY" "${FIFO_pipe}"
tmux split-window -h -p 55 -t "${window_id}.1" "${pipe_cmd}" || exit 1

# echo "r+b" # [registers]
pipe_tty2 "registers_TTY" "breakpoints_TTY" "${FIFO_pipe}"
tmux split-window -h -p 20 -t "${window_id}" "${pipe_cmd}" || exit 1

# echo "a" # [assembly]
pipe_tty "assembly_TTY" "${FIFO_pipe}"
tmux split-window -v -p 25 -t "${window_id}.2" "${pipe_cmd}" || exit 1

# echo "s+h" # [stack,history]
pipe_tty2 "history_TTY" "stack_TTY" "${FIFO_pipe}"
tmux split-window -v -t "${window_id}.1" "${pipe_cmd}" || exit 1

# echo "t+e" # [threads,expression]
pipe_tty2 "threads_TTY" "expression_TTY" "${FIFO_pipe}"
tmux split-window -h -t "${window_id}.6" "${pipe_cmd}" || exit 1
#---------------------

# gdb!!
tmux send-keys -t "${window_id}.1" "gdb ${vmlinux}" C-m

#---configure-dashboard------------------
# source lines
tmux send-keys -t "${window_id}.1" "dashboard source -style context 21" C-m
tmux send-keys -t "${window_id}.1" "dashboard assembly -style context 6" C-m
tmux send-keys -t "${window_id}.1" "dashboard stack -style locals True" C-m
tmux send-keys -t "${window_id}.1" "dashboard stack -style limit 1" C-m
tmux send-keys -t "${window_id}.1" 'dashboard -style syntax_highlighting "monokai"' C-m
# dashboard -style syntax_highlighting "paraiso-dark"

breakpoint_FILE='.gdb_breakpoints'
grep "^break main$" "$breakpoint_FILE"
if [ ! $? -eq 0 ]; then
  tmux send-keys -t "${window_id}.1" "b main" C-m
fi

# save breakpoints to file
# >>> save breakpoints .gdb_breakpoints
# load breakpoints from file
# >>> source .gdb_breakpoints
if [ -e $breakpoint_FILE ]; then
  tmux send-keys -t "${window_id}.1" "source $breakpoint_FILE" C-m
fi

#---
# "history"
REGIONS=("assembly" "memory" "registers" "source" "stack" "threads" "expression" "breakpoints")

CONT=1
while [ $CONT -eq 1 ]; do
  let CONT=0
  eval $(cat $FIFO_pipe)
  for REGION in "${REGIONS[@]}"; do
    if [ ! -v "${REGION}_TTY" ]; then
      CONT=1
    fi
  done
done
rm $FIFO_pipe

#disable print history
tmux send-keys -t "${window_id}.1" "dashboard history -output /dev/null" C-m

for REGION in "${REGIONS[@]}"; do
  eval "REGION_TTY=\$${REGION}_TTY"
  tmux send-keys -t "${window_id}.1" "dashboard ${REGION}    -output $REGION_TTY" C-m
done

# gdb run!
tmux send-keys -t "${window_id}.1" "r" C-m
tmux select-pane -t "${window_id}.1"
