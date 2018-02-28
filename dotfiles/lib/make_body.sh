#!/bin/bash

source $HOME/dotfiles/lib/entr_shared.sh

cls
header

# make and discard everything from stdout(display only errors & warnings)
make  -j $(echo $NUMBER_OF_PROCESSORS) 1>/dev/null
if [ $? -eq 0 ]; then
  good "SUCCESS"

  # echo "$@"
  eval $@
else
  bad "Compilation FAILED"
fi
