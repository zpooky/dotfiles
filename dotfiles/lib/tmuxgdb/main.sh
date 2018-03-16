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

gdb_ARG=${@:2:99}

GDB_CONFIG_file="`mktemp /tmp/gdb_config_file.XXXXXXXXXXXXXX`"
BREAKPOINT_file='.gdb_breakpoints'

#---configure-dashboard------------------
# source lines
echo "dashboard source -style context 21"               >> $GDB_CONFIG_file
echo "dashboard assembly -style context 6"              >> $GDB_CONFIG_file
echo "dashboard stack -style locals True"               >> $GDB_CONFIG_file
echo "dashboard stack -style limit 1"                   >> $GDB_CONFIG_file
echo "dashboard -style syntax_highlighting \"monokai\"" >> $GDB_CONFIG_file
# dashboard -style syntax_highlighting "paraiso-dark"

grep "^break main$" "$BREAKPOINT_file"
if [ ! $? -eq 0 ]; then
  echo "b main" >> $GDB_CONFIG_file
fi

# save breakpoints to file
# >>> save breakpoints .gdb_breakpoints
# load breakpoints from file
# >>> source .gdb_breakpoints
if [ -e $BREAKPOINT_file ]; then
  echo "source $BREAKPOINT_file" >> $GDB_CONFIG_file
fi

#---
# "history"
REGIONS=("assembly" "memory" "registers" "source" "stack" "threads" "expression" "breakpoints")

CONT=1
while [ $CONT -eq 1 ]; do
  let CONT=0
  eval `cat $FIFO_pipe`
  for REGION in "${REGIONS[@]}"; do
    if [ ! -v "${REGION}_TTY" ]; then
      CONT=1
      # sleep 1s
    fi
  done
done

# tmux send-keys "echo \$TTY_1" C-m

#disable print history
echo "dashboard history -output /dev/null" >> $GDB_CONFIG_file

for REGION in "${REGIONS[@]}"; do
  eval "REGION_TTY=\$${REGION}_TTY"
  echo "dashboard ${REGION}    -output $REGION_TTY" >> $GDB_CONFIG_file
done

# gdb run!
echo "r" >> $GDB_CONFIG_file

# cat $GDB_CONFIG_file

echo "gdb --args $gdb_ARG --command=$GDB_CONFIG_file"
gdb --command="$GDB_CONFIG_file" --args ${gdb_ARG[@]}

rm $GDB_CONFIG_file
