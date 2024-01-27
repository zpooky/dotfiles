#!/usr/bin/env bash

source $HOME/dotfiles/lib/vimcpp/shared.sh

is_meson(){
  if [ -e meson.build ]; then
    return 0
  fi
  return 1
}

is_cmake(){
  if [ -e CMakeLists.txt ]; then
    return 0
  fi
  return 1
}

is_gradle(){
  if [ -e build.gradle ]; then
    return 0
  fi
  return 1
}

is_maven(){
  if [ -e pom.xml ]; then
    return 0
  fi
  return 1
}

build() {
  local res=0
  if [ -e Cargo.toml ]; then
    cargo build
    res=$?
  elif is_meson; then
    echo "is meson"

    if [ ! -e build ]; then
      mkdir build
      res=$?
    fi

    if [ $res -eq 0 ]; then
      cd build

      if [ ! -e meson-info ] || [ ! -e meson-info ] || [ ! -e meson-logs ]; then
        meson setup ..
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
  elif is_cmake; then
    if [ ! -e build ]; then
      mkdir build
      res=$?
    fi
    if [ $res -eq 0 ]; then
      cd build

      if [ ! -e CMakeCache.txt ] || [ ! -e CMakeFiles ] || [ ! -e cmake_install.cmake ]; then
        cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
        res=$?
      fi

      if [ $res -eq 0 ]; then
        make
        res=$?
      fi
    fi

  elif is_gradle; then
    gradle build
  elif is_maven; then
    mvn compile
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
  if command -v clear 2>&1 > /dev/null; then
    clear
  else
    printf "\033[H\033[2J"
  fi
  if [ -v "TMUX" ]; then
    sleep .3s
    tmux clear-history
  fi
}

header() {
  echo '窷=========================================================================='
}
