#!/bin/bash

source $HOME/dotfiles/lib/entr_shared.sh

cls
header

# make and discard everything from stdout
make 1>/dev/null
if [ $? -eq 0 ]; then
  good "SUCCESS"
else
  bad "Compilation FAILED"
fi

eval $@
