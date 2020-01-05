#!/bin/bash

source $HOME/dotfiles/lib/entr_shared.sh

cls
header

build
res=$?

# make -j 1>/dev/null
if [ $res -eq 0 ]; then
  good "SUCCESS"

  # echo "$@"
  eval $@
else
  bad "Compilation FAILED"
fi
