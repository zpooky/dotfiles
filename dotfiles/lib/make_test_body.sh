#!/bin/bash

# $TMUX_PANE contains self
#  `tmux run "echo '#{pane_id}'"` contains active pane

source $HOME/dotfiles/lib/entr_shared.sh

make_FILE="$1"
ARG=${@:2:99}

# make -C test
TEMP_FILE=`mktemp /tmp/make_test-XXXXXXXX`
echo ""
echo "compiling..."
echo "make -C $make_FILE -j $(echo $NUMBER_OF_PROCESSORS) 1>/dev/null 2> $TEMP_FILE"
make -C $make_FILE -j $(echo $NUMBER_OF_PROCESSORS) 1>/dev/null 2> $TEMP_FILE
RET=$?

cls
header
if [ $RET -eq 0 ]; then
  cls
  # echo "./test/thetest $@"

  # eval ${ARG[@]} 1&2> $TEMP_FILE
  cls
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
  cat $TEMP_FILE

  bad "Compilation FAILED"
  if [ -v "TMUX" ]; then
    echo ""
    # TODO goto first error if in focus?
  fi
fi
