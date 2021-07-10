#!/usr/bin/env bash

FIFO_pipe="$1"
if [ ! -e $FIFO_pipe ]; then
  echo "pipe does not exist"
  exit 1
fi

if [ ! -p $FIFO_pipe ]; then
  echo "is not a pipe"
  exit 1
fi

REGIONS=(${@:2:99})

for REGION in "${REGIONS[@]}"; do

  the_tty=$(tty)
  if [ ! $? -eq 0 ]; then
    echo "error"
  fi

  # echo "$REGION=\"`tty`\" > $FIFO_pipe"
  echo "$REGION=\"$(tty)\"" >$FIFO_pipe &
  # echo "$REGION=\"$(tty)\""
done
