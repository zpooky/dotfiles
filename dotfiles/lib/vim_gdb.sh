#!/bin/bash

# ./script <cpp_file> <line>

source $HOME/dotfiles/lib/vimcpp/shared.sh

# ppid_for_exe "sleep"

# is_sp_gdb_running
# if [ $? -eq 0 ]; then
#   echo "sp_gdb is running"
# else
#   echo "sp_gdb is not running"
# fi
# echo "--"

# tmux_pane_id_for "" "mywindow" "1"
# pid_for_pane_id "${pane_id}"
# echo "${pane_id}: pid[${pid_out}]"

is_exe_running_in_pane "" "mywindow" "1" "vim"
if [ $? -eq 0 ]; then
  echo "vim is running"
else
  echo "vim is NOT!"
fi

# echo "--$?|$pane_id"

is_sp_gdb_running
if [ $? -eq 0 ]; then
  echo "sp_gdb is running"
else
  echo "sp_gdb is NOT!"
fi
