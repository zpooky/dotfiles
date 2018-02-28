#!/bin/bash

function sp_has_feature() {
  local FEATURE="$1"

  which $FEATURE > /dev/null 2>&1
  local WHICH_FEATURE=$?
  hash $FEATURE > /dev/null 2>&1
  local HASH_FEATURE=$?

  if [ $WHICH_FEATURE -eq $HASH_FEATURE ]; then
    if [ $WHICH_FEATURE -eq 0 ]; then
      return 0
    fi
  fi
  return 1
}

BODY="$1"
ARG=${@:2:99}

sp_has_feature entr
if [ $? -eq 0 ]; then
  ack --cpp -f | entr $BODY $ARG
else
  ack --cpp -f | $HOME/dotfiles/lib/timestamp_make.sh $BODY $ARG
fi

