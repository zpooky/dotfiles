#!/usr/bin/env bash

MAIL=`~/dotfiles/lib/keyring-helper.py $1 $2`

echo "http://localhost:1080/users/$MAIL/calendar"
