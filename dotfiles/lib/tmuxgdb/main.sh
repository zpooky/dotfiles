#!/usr/bin/env bash

FIFO_pipe="${1}"
if [ ! -e "${FIFO_pipe}" ]; then
  echo "'${FIFO_pipe}' pipe does not exist"
  exit 1
fi

if [ ! -p "${FIFO_pipe}" ]; then
  echo "'${FIFO_pipe}' is not a pipe"
  exit 1
fi

if [[ -z "${TMPDIR}" ]]; then
  TMPDIR=/tmp
fi

GDB_CONFIG_file="$(mktemp ${TMPDIR}/gdb_config_file.XXXXXXXXXXXXXX)"
BREAKPOINT_file='.gdb_breakpoints'

echo "\${SP_GDB_SOURCE}: ${SP_GDB_SOURCE}"
echo "\${SP_GDB_EXE}: ${SP_GDB_EXE}"

if [ "${SP_GDB_EXE}" = "" ]; then
  SP_GDB_EXE=gdb
fi

#---configure-dashboard------------------
# source lines
echo "source ~/sources/gdb-dashboard/.gdbinit" >>"${GDB_CONFIG_file}"
echo "dashboard source -style height 39" >>"${GDB_CONFIG_file}"
# echo "dashboard assembly -style context 6" >>"${GDB_CONFIG_file}"
echo "dashboard variables -style compact False" >>"${GDB_CONFIG_file}"

echo "dashboard stack -style locals True" >>"${GDB_CONFIG_file}"
echo "dashboard stack -style limit 1" >>"${GDB_CONFIG_file}"

echo "dashboard assembly -style function False" >>"${GDB_CONFIG_file}"

echo "dashboard -style syntax_highlighting \"monokai\"" >>"${GDB_CONFIG_file}"
# dashboard -style syntax_highlighting "paraiso-dark"
cat >>"${GDB_CONFIG_file}" <<EOF
# refresh dashboard [gdb hooks]
# define - a new hook
# hookpost - means post execution of command
# -*command* - the command to hook for
# dashboard - refreshes the gdb-dashboard

# define hookpost-run
# dashboard
# end

# refresh on moving up a stack frame
define hookpost-up
dashboard
end

# refresh on moving down a stack frame
define hookpost-down
dashboard
end

# refresh on change thread
define hookpost-thread
dashboard
end

# refresh on change stack frame
define hookpost-frame
dashboard
end

# refresh on new breakpoint
define hookpost-break
dashboard
end

# refresh active breakpoints
define hookpost-clear
dashboard
end

# save active breakpoints on gdb quit
define hook-quit
save breakpoints .gdb_breakpoints
end
EOF

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
regions=("assembly" "memory" "registers" "source" "threads" "expression" "breakpointz" "variables")

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
echo "dashboard breakpoints -output /dev/null" >>"${GDB_CONFIG_file}"
echo "dashboard stack -output /dev/null" >>"${GDB_CONFIG_file}"

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
