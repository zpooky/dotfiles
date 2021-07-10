#!/usr/bin/env bash

PAWD="`cat $HOME/dotfiles/lib/passwd`"
HOST_USER="root"
HOST_ADDRS="172.16.1.113"

sshpass -p "$PAWD" ssh "$HOST_USER@$HOST_ADDRS" <<'ENDSSH'
cd /opt/compuverde/logs
cp Gateway-Traffic-*.log bak_GT_`date +"%H_%M_%S"`
ENDSSH
