#!/usr/bin/env bash

# source: https://gist.github.com/mikeboiko/b6e50210b4fb351b036f1103ea3c18a9

# other:
# https://gist.github.com/antonkratz/ebfcefdb5fdf266631e4985d65535322#copy-and-paste-with-vim-across-instances-ssh-borders-different-clipboards
# https://github.com/rjmccabe3701/linux_config/blob/master/scripts/update_display.sh

# The problem:
# When you `ssh -X` into a machine and attach to an existing tmux session, the session
# contains the old $DISPLAY env variable. In order the x-server/client to work properly,
# you have to update $DISPLAY after connection. For example, the old $DISPLAY=:0 and
# you need to change to DISPLAY=localhost:10.0 for the ssh session to
# perform x-forwarding properly.

# The solution:
# When attaching to tmux session, update $DISPLAY for each tmux pane in that session
# This is performed by using tmux send-keys to the shell.
# This script handles updating $DISPLAY within vim also
# If you're using Neovim, remove the :xrestore line

NEW_DISPLAY=$(tmux show-env | sed -n 's/^DISPLAY=//p')
tmux list-panes -s -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}" | \
while read -r pane_process; do
  IFS=' ' read -ra pane_process <<< "$pane_process"
  if [[ "${pane_process[1]}" == "zsh" || "${pane_process[1]}" == "bash" ]]; then
    # tmux send-keys -t "${pane_process[0]}" " export DISPLAY=$NEW_DISPLAY" Enter
    echo ""
  elif [[ "${pane_process[1]}" == *"vi"* ]]; then
# :xrestore
# Reinitializes the connection to the X11 server. Useful after the X server
# restarts, e.g. when running Vim for long time inside screen/tmux and
# connecting from different machines.
#
# [display] should be in the format of the $DISPLAY environment variable (e.g.
# "localhost:10.0") If [display] is omitted, then it reinitializes the
# connection to the X11 server using the same value as was used for the
# previous execution of this command.
#
# If the value was never specified, then it uses the value of $DISPLAY
# environment variable as it was when Vim was started.
    tmux send-keys -t "${pane_process[0]}" Escape
    tmux send-keys -t "${pane_process[0]}" ":let \$DISPLAY = \"${NEW_DISPLAY}\"" Enter
    tmux send-keys -t "${pane_process[0]}" ":xrestore" Enter
  fi
done
reset
