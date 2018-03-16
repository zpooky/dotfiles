#!/bin/bash

if [ ! -e "${1}" ]; then
  echo "'$1' does not exist"
  exit 1
fi

if [[ ! -x "${1}" ]]; then
  echo "'$1' is not executable"
  exit 1
fi

ARGS_gdb=${@:1:99}

pgrep gdb
if [ $? -eq 0 ]; then
  if [[ $(uname -s) =~ CYGWIN.* ]]; then
    echo "gdb is allready running"
    # exit 1
  fi
fi

FIFO_pipe="`mktemp -u /tmp/gdb_fifo.XXXXXXXXXXXXXX`"
mkfifo $FIFO_pipe || exit 1

TEAMCIL_yaml="`mktemp -u /tmp/teamcil_yaml.XXXXXXXXXXXXXX`"


echo "windows:" >> $TEAMCIL_yaml
echo "  - name: wasd" >> $TEAMCIL_yaml
echo "    root: `pwd`" >> $TEAMCIL_yaml
echo "    layout: 1342,231x61,0,0[231x51,0,0{103x51,0,0[103x25,0,0,1,103x25,0,26,6],101x51,104,0[101x38,104,0,3,101x12,104,39,5],25x51,206,0,4},231x9,0,52{115x9,0,52,2,115x9,116,52,7}]" >> $TEAMCIL_yaml
echo "    panes:" >> $TEAMCIL_yaml
echo "      - ~/dotfiles/lib/tmuxgdb/main.sh $FIFO_pipe $ARGS_gdb" >> $TEAMCIL_yaml
echo "      - ~/dotfiles/lib/tmuxgdb/sub.sh $FIFO_pipe history_TTY stack_TTY" >> $TEAMCIL_yaml
echo "      - ~/dotfiles/lib/tmuxgdb/sub.sh $FIFO_pipe source_TTY" >> $TEAMCIL_yaml
echo "      - ~/dotfiles/lib/tmuxgdb/sub.sh $FIFO_pipe assembly_TTY" >> $TEAMCIL_yaml
echo "      - ~/dotfiles/lib/tmuxgdb/sub.sh $FIFO_pipe registers_TTY breakpoints_TTY" >> $TEAMCIL_yaml
echo "      - ~/dotfiles/lib/tmuxgdb/sub.sh $FIFO_pipe threads_TTY expression_TTY" >> $TEAMCIL_yaml
echo "      - ~/dotfiles/lib/tmuxgdb/sub.sh $FIFO_pipe memory_TTY" >> $TEAMCIL_yaml

cat $TEAMCIL_yaml

time teamocil --layout $TEAMCIL_yaml || exit 1

rm $TEAMCIL_yaml
