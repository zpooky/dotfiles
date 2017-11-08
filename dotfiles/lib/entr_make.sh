#!/bin/bash

source $HOME/dotfiles/lib/entr_shared.sh

cls
header

make
if [ $? -eq 0 ]; then
  good "SUCCESS"
else
  bad "Compilation FAILED"
fi

eval $@
