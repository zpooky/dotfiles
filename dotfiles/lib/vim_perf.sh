#!/bin/bash

#TODO support realse & debug version

in_FILE="${1}"
in_SEARCH="${2}"

function sp_perf_report() {
  perf report -n --stdio
}

function sp_perf() {
  local wasd="perf record -F 990 $(printf "%s " "${@}")"
  echo "$wasd"
  $wasd
}

source "${HOME}/dotfiles/lib/vimcpp/shared.sh"

gtest_for_file_line "${in_FILE}" "${in_SEARCH}"
if [ ! $? -eq 0 ]; then
  echo "failed to find gtest in '$in_FILE':'$in_SEARCH'"
  exit 1
fi

find_test_executable "${in_FILE}"

sp_perf "${test_EXECUTABLE}" "--gtest_filter="${test_matcher}""
sp_perf_report
