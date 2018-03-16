#!/bin/bash

FIFO_pipe="$1"
if [ ! -e $FIFO_pipe ]; then
  echo "pipe does not exist"
  exit 1
fi

if [ ! -p $FIFO_pipe ]; then
  echo "is not a pipe"
  exit 1
fi

REGIONS=( ${@:2:99} )

for REGION in "${REGIONS[@]}"; do

  echo "$REGION=\"`tty`\" > $FIFO_pipe"
  echo "$REGION=\"`tty`\"" > $FIFO_pipe &
done
