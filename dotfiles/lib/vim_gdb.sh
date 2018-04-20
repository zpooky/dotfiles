#!/bin/bash

# ./script <cpp_file> <line>

source $HOME/dotfiles/lib/vimcpp/shared.sh

tty_for_exe "sleep"

is_sp_gdb_running
if [ $? -eq 0 ]; then
  echo "sp_gdb is running"
else
  echo "sp_gdb is not running"
fi
echo "--"

tmux_pane_id_for "" "mywindow" "1"
echo "--$?|$pane_id"
