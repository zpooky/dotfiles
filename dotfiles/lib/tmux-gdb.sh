#!/bin/bash

LEFT_TP=`tty`
tmux split-window -h
RIGHT_TP=`tty`
tmux split-window -v
RIGHT_BT=`tty`

tmux select-pane -t 0

tmux split-window -v
LEFT_BT=`tty`

tmux select-pane -t 0

echo "RIGHT_TP ${RIGHT_TP}"
echo "RIGHT_BT ${RIGHT_BT}"

echo "LEGT_TP ${LEFT_TP}"
echo "LEFT_BT ${LEFT_BT}"
gdb $1 -iex "dashboard source -output ${RIGHT_TP}"
