#!/bin/bash

is_meson(){
  if [ -e meson.build ]; then
    return 0
  fi
  return 1
}

build() {
  local res=0
  if is_meson; then

    if [ ! -e build ]; then
      mkdir build
      res=$?
    fi

    if [ $res -eq 0 ]; then
      cd build

      if [ ! -e meson-info ] || [ ! -e meson-info ] || [ ! -e meson-logs ]; then
        meson ..
        res=$?
      fi

      if [ $res -eq 0 ]; then
        ninja
        res=$?
      fi
    fi

  elif [ -e Makefile ]; then
    # make and discard everything from stdout(display only errors & warnings)
    make 1> /dev/null
    res=$?
  else
    echo "missing buld tool">&2
    exit 1
  fi

  return $res
}

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
