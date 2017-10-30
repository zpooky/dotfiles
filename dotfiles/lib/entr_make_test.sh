#!/bin/bash

# $TMUX_PANE contains self
#  `tmux run "echo '#{pane_id}'"` contains active pane

p() {
    printf '%b\n' "$1" >&2
}

bad(){
    p "\e[31m[✘] ${1}${2}\e[0m"
}

good() {
  p "\e[32m[✔] ${1}${2}\e[0m"
}

if [ -v "TMUX" ]; then
  clear
  sleep .3s
  tmux clear-history

else
  clear
fi

echo '窷=========================================================================='

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
