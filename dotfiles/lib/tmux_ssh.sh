#!/bin/bash

HOST_USER="root"
HOST_ADDRS=( "172.16.1.113" "172.16.1.114" "172.16.1.115" "172.16.1.116" )

PAWD="`cat passwd`"

# cp scripts
for CURRENT in "${HOST_ADDRS[@]}"; do
  SCRIPT_ROOT="$HOME/work/log_cleanup"
  if [ -e $SCRIPT_ROOT ]; then
    SCRIPTS=( "hourly.sh" "log_cleanup.sh" )
    SCRIPT_DEST="/opt/compuverde/logs"

    for CS in "${SCRIPTS[@]}"; do
      # echo "sshpass -p $PAWD scp $SCRIPT_ROOT/$CS $HOST_USER@$CURRENT:$SCRIPT_DEST || exit $?"
      sshpass -p "$PAWD" scp "$SCRIPT_ROOT/$CS" "$HOST_USER@$CURRENT:$SCRIPT_DEST" || exit $?
    done
  fi
done

# run scripts
# ps aux | grep "\./hourly\.sh \./clean_log\.sh$"

# tmux display-message -p "#{pane_id}"

# start dashboard
tmux new-window -n "CV" || exit $?
for CURRENT in "${HOST_ADDRS[@]}"; do
  tmux split-window "sshpass -p "$PAWD" ssh $HOST_USER@$CURRENT" || exit $?
done

tmux select-layout tiled
