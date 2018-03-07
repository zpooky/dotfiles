#!/bin/bash

# $TMUX_PANE contains self
#  `tmux run "echo '#{pane_id}'"` contains active pane

source $HOME/dotfiles/lib/entr_shared.sh

cls
header

make_FILE="$1"
ARG=${@:2:99}

# make -C test
echo "#####make -C $make_FILE -j $(echo $NUMBER_OF_PROCESSORS)"
make -C $make_FILE # -j $(echo $NUMBER_OF_PROCESSORS)

if [ $? -eq 0 ]; then
  # clear
  # echo "./test/thetest $@"

  eval ${ARG[@]}
  if [ $? -eq 0 ]; then
    good "SUCCESS"
  else
    bad "test FAILED"
    if [ -v "TMUX" ]; then
      echo ""
      # TODO goto first failed test if in focus?
    fi
  fi

else

  bad "Compilation FAILED"
  if [ -v "TMUX" ]; then
    echo ""
    # TODO goto first error if in focus?
  fi
fi
