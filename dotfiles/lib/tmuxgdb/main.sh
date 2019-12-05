#!/bin/bash

FIFO_pipe="${1}"
if [ ! -e "${FIFO_pipe}" ]; then
  echo "'${FIFO_pipe}' pipe does not exist"
  exit 1
fi

if [ ! -p "${FIFO_pipe}" ]; then
  echo "'${FIFO_pipe}' is not a pipe"
  exit 1
fi

GDB_CONFIG_file="$(mktemp /tmp/gdb_config_file.XXXXXXXXXXXXXX)"
BREAKPOINT_file='.gdb_breakpoints'

echo "\${SP_GDB_SOURCE}: ${SP_GDB_SOURCE}"
echo "\${SP_GDB_EXE}: ${SP_GDB_EXE}"

if [ "${SP_GDB_EXE}" = "" ]; then
  SP_GDB_EXE=gdb
fi

#---configure-dashboard------------------
# source lines
echo "dashboard source -style context 21" >>"${GDB_CONFIG_file}"
echo "dashboard assembly -style context 6" >>"${GDB_CONFIG_file}"
echo "dashboard stack -style locals True" >>"${GDB_CONFIG_file}"
echo "dashboard stack -style limit 1" >>"${GDB_CONFIG_file}"
echo "dashboard -style syntax_highlighting \"monokai\"" >>"${GDB_CONFIG_file}"
# dashboard -style syntax_highlighting "paraiso-dark"

grep "^break main$" "$BREAKPOINT_file"
if [ ! $? -eq 0 ]; then
  echo "b main" >>"${GDB_CONFIG_file}"
fi

# save breakpoints to file
# >>> save breakpoints .gdb_breakpoints
# load breakpoints from file
# >>> source .gdb_breakpoints
if [ -e $BREAKPOINT_file ]; then
  echo "source $BREAKPOINT_file" >>"${GDB_CONFIG_file}"
fi

#---
# "history"
regions=("assembly" "memory" "registers" "source" "stack" "threads" "expression" "breakpoints")

cont=1
while [ $cont -eq 1 ]; do
  cont=0
  eval $(cat "${FIFO_pipe}")
  for region in "${regions[@]}"; do
    if [ ! -v "${region}_TTY" ]; then
      cont=1
      # sleep 1s
    fi
  done
done

# tmux send-keys "echo \$TTY_1" C-m

#disable print history
echo "dashboard history -output /dev/null" >>"${GDB_CONFIG_file}"

for region in "${regions[@]}"; do
  eval "REGION_TTY=\$${region}_TTY"
  echo "dashboard ${region}    -output $REGION_TTY" >>"${GDB_CONFIG_file}"
done

if [ ! "${SP_GDB_SOURCE}" = "" ]; then
  if [ ! -e ${SP_GDB_SOURCE} ]; then
    exit 2
  fi
  cat ${SP_GDB_SOURCE} >> "${GDB_CONFIG_file}"
else
  # gdb run!
  echo "r" >>"${GDB_CONFIG_file}"
fi

cat "${GDB_CONFIG_file}"

# gdb_ARG=(${@:2:99})
# formated_gdb_args=""
# for current in "${gdb_ARG[@]}"; do
#   formated_gdb_args="${formated_gdb_args} \"${current}\""
# done

shift 1
echo "${SP_GDB_EXE} --silent --command=\"${GDB_CONFIG_file}\" --args $@"
${SP_GDB_EXE} --silent --command="${GDB_CONFIG_file}" --args "$@"

# rm "${GDB_CONFIG_file}"
