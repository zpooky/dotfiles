#!/bin/bash

p() {
  printf '%b\n' "$1" >&2
}

bad(){
  p "\e[31m[✘] ${1}${2}\e[0m"
}

good() {
  p "\e[32m[✔] ${1}${2}\e[0m"
}

cls() {
  if [ -v "TMUX" ]; then
    clear
    sleep .3s
    tmux clear-history

  else
    clear
  fi
}

header() {
  echo '窷=========================================================================='
}
