#!/usr/bin/env bash

source $HOME/dotfiles/lib/entr_shared.sh

cls
header

search_path_upwards "${PWD}" ".git" "Makefile"
if [ $? -eq 0 ]; then
  cd "${search_RESULT}"
  if [ ! $? -eq 0 ]; then
    echo "failed to cd to '${search_RESULT}'"
    exit 1
  fi
else
  echo "failed finding root"
  exit 2
fi

build
res=$?

# make -j 1>/dev/null
if [ $res -eq 0 ]; then
  good "SUCCESS"

  # echo "$@"
  eval $@
else
  bad "Compilation FAILED"
fi
