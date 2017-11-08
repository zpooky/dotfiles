#!/bin/bash

# $TMUX_PANE contains self
#  `tmux run "echo '#{pane_id}'"` contains active pane

source $HOME/dotfiles/lib/entr_shared.sh

cls
header

make -C test
if [ $? -eq 0 ]; then
  ./test/thetest $@
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
