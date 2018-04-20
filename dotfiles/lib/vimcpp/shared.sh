#!/bin/bash

#==================================================================
#=======GTEST=Stuff================================================
#==================================================================
# arg: path
# out: 0:true/1:false
# result: $test_EXECUTABLE
function find_test_executable() {
  local path=$1
  local path="$(dirname $path)"

  search_path_upwards "${path}" "TESTMARKER"
  if [ $? -eq 0 ]; then
    local test_MARKER="${search_RESULT}/TESTMARKER"
    local TEST_EXECUTABLE_NAME=`cat "${test_MARKER}"`
    test_EXECUTABLE="${search_RESULT}/${TEST_EXECUTABLE_NAME}"
    return 0
  else
    echo "thetest executable was not found"
    exit 1
  fi
}
# ======

function is_gtest_file() {
  return 0
}

# arg: strline
# out: 0:true/1:false
function is_line_gtest() {
  local line="$1"

  local regEx_TEST_F='^[ \t]*TEST_F\((.+)[ \t]*, (.+)\)'
  local regEx_TEST_P='^[ \t]*TEST_P\((.+)[ \t]*, (.+)\)'
  local regEx_TEST='^[ \t]*TEST\((.+)[ \t]*, (.+)\)'
  if [[ $line =~ $regEx_TEST || $line =~ $regEx_TEST_P || $line =~ $regEx_TEST_F ]]; then
    return 0
  else
    return 1
  fi

}

# arg: file
# out: 0:true/1:false
# result: ...
function smart_gtest_test_cases() {
  local in_FILE="$1"
  local in_SEARCH="$2"

  if [ ! -e "$in_FILE" ]; then
    return 1
  fi

  if [ ! -f "$in_FILE" ]; then
    return 1
  fi

  test_matches=()
  local line_cnt=1

  while IFS='' read -r line || [[ -n "$line" ]]; do
    # TODO count nested levels{} to figure out if we are in root(meaning all tests should run) or that the cursor are inside a test function(meaning only that test should be run(the last in the arrray))

    is_line_gtest "$line"
    if [ $? -eq 0 ]; then
      # echo "./test/thetest --gtest_filter=\"*${BASH_REMATCH[1]}.${BASH_REMATCH[2]}*\""
      # echo "$line_cnt: $line"
      # echo "${BASH_REMATCH[@]}"

      local exact_match="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
      # Default/ReadWriteLockThreadTest.threaded_TryPrepare/13 (5 ms)
      local param_match="*${BASH_REMATCH[1]}.${BASH_REMATCH[2]}/*"

      test_matches+=("${exact_match}:${param_match}")
    fi

    # if we are currently on the searched line
    if [ $in_SEARCH -eq $line_cnt ]; then
      # TODO if [ ! $nested_count -eq 0 ]; then
      echo "matches ${#test_matches[@]}"
      # if there is more than zero tests
      if [ ${#test_matches[@]} -gt 0 ]; then
        # take the last found test
        test_matches=(${test_matches[-1]})
        echo "constraint ${test_matches}"
        break
      fi
      # fi
    fi

    local line_cnt=$((line_cnt + 1))
  done <"$in_FILE"

  return 0
}

# arg: file
# arg: line
function gtest_for_file_line() {
  local in_FILE="$1"
  local in_SEARCH="$2"

  if [ ! -e "$in_FILE" ]; then
    return 1
  fi

  if [ ! -f "$in_FILE" ]; then
    return 1
  fi

  test_matcher=""
  local line_cnt=1

  while IFS='' read -r line || [[ -n "$line" ]]; do
    # TODO count nested levels{} to figure out if we are in root(meaning all tests should run) or that the cursor are inside a test function(meaning only that test should be run(the last in the arrray))

    is_line_gtest "$line"
    if [ $? -eq 0 ]; then
      local exact_match="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
      # Default/ReadWriteLockThreadTest.threaded_TryPrepare/13 (5 ms)
      local param_match="*${BASH_REMATCH[1]}.${BASH_REMATCH[2]}/*"

      test_matcher="${exact_match}:${param_match}"
    fi

    # if we are currently on the searched line
    if [ $in_SEARCH -eq $line_cnt ]; then

      # if there is more than zero tests
      if [ ! -z "${test_matcher}" ]; then
        break
      else
        return 1
      fi
    fi

    local line_cnt=$((line_cnt + 1))
  done <"$in_FILE"

  # echo "constraint ${test_matcher}"

  return 0
}

#==================================================================
#====UTILS=========================================================
#==================================================================

# if true set global variable search_RESULT to result path not containing the
# needle
#
# arg: str path
# arg: file searh
# out: 0:true/1:false
# result: search_RESULT
function search_path_upwards() {
  local path=${1}
  local needle=${2}
  # local path="$(dirname $path)"

  while [[ "$path" != "/" ]]; do
    local test_path="${path}/${needle}"
    ls $test_path >/dev/null 2>&1

    if [ $? -eq 0 ]; then
      search_RESULT="${path}"
      return 0
    fi

    local path="$(readlink -f $path/..)"
  done

  return 1
}

#==================================================================
#====TMUX==========================================================
#==================================================================

function is_tmux_window() {
  local needle="${1}"
  return 0
}

function switch_tmux_window() {
  # an empty session means the current session
  local session="${1}"
  local window="${2}"
  tmux select-window -t "${session}":"${window}"
}

function tmux_list_clients() {
  tmux list-clients
}

function tmux_list_sessions() {
  tmux list-sessions
}

function tmux_list_windows() {
  tmux list-windows
}

function tmux_list_panes() {
  # in current window
  tmux list-panes

  # # in window 4
  # tmux list-panes -t :4
}

function tmux_send_keys() {
  # an empty session means the current session
  local session="${1}"
  local window="${2}"
  local pane_idx="${3}"
  local command="${4}"
  tmux send-keys -t "${session}":"${window}"."${pane_idx}" "$command" C-m
}

function tmux_send_keys_id() {
  local pane_id="${1}"
  # %38 is pane_id
  # tmux send-keys -t %38 "ls" C-m
  # TODO
}

# function tty_for_pid() {
#   echo ""
# }
#
# function tty_for_exe() {
#   local exe="${1}"
#   pids=( $(pgrep "${exe}") )
#   if [ ! $? -eq 0 ]; then
#     echo "pgrep failed"
#     return 1
#   fi
#
#   if [ ${#pids[@]} -gt 1 ]; then
#     echo "ambigous pids"
#     return 1
#   fi
#
#   if [ ! ${#pids[@]} -eq 1 ]; then
#     return 1
#   fi
#
#   tty_for_pid "${pids[0]}"
#
#   # snap=$(ps aux | grep "${exe}")
#   # echo "snap: $snap"
#   # if [ ! -z "${snap}" ]; then
#   #
#   #   exe_tty=""
#   #   return 0
#   # else
#   #   return 1
#   # fi
# }


# » ll /proc/10120/fd
# lrwxrwxrwx 1 fredrik Domain Users 0 Apr 20 15:18 0 -> /dev/pty17
# lrwxrwxrwx 1 fredrik Domain Users 0 Apr 20 15:18 1 -> /dev/pty17
# lrwxrwxrwx 1 fredrik Domain Users 0 Apr 20 15:18 10 -> /dev/pty17
# lrwxrwxrwx 1 fredrik Domain Users 0 Apr 20 15:18 2 -> /dev/pty17

# function tmux_pane_tty() {
#   local session="${1}"
#   local window="${2}"
#   local pane_idx="${3}"
#   # tmux list-panes -t :gdb.1 -F "#{pane_id} #{pane_index} #{pane_tty}"
#   pane_tty=""
#   return 1
#   # TODO
# }

function ppid_for_exe() {
  ppid_out=""
}


# cygwin
# $ ps aux | grep 7528                                                                                                                                                                                                       [0][0.0s][]
#       PID    PPID    PGID     WINPID   TTY         UID    STIME COMMAND
#       228    7528     228       8756  pty4     1051816 15:19:31 /usr/bin/gdb
#      7528    4452    7528       7784  pty4     1051816 15:19:30 /usr/bin/zsh

function ppid_for_pid() {
  ppid_out=""
}

function pid_for_pane_id() {
  pid_out=""
}

function tmux_pane_id_for() {
  local session="${1}"
  local window="${2}"
  local pane_idx="${3}"

  # echo "tmux list-panes -t ${session}:${window} -F \"[#{pane_index}] #{pane_id}\""
  local str=$(tmux list-panes -t "${session}":"${window}" -F "[#{pane_index}] #{pane_id}")
  if [ $? -eq 0 ]; then
    # local str=$(echo ${str} | grep "\[${pane_idx}\]")

    local arr=($str)
    local next=false
    local set=false
    local id=""
    for c in "${arr[@]}"; do
      # echo "${c}:${next}"

      if [ "$next" = true ]; then
        local id="${c}"
        local set=true
        break
      fi

      if [ "${c}" = "[${pane_idx}]" ]; then
        local next=true
      fi
    done

    # echo "_${id}_"
    # echo "|${str}|"

    if [ "$set" = true ]; then
      pane_id="${id}"
      return 0
    else
      return 1
    fi
  else
    return 1
  fi
}

function is_exe_running_in_pane() {
  #TODO 
  # 1. find gdb window and PID for pane 1
  # 2. find PPID for all *exe*
    # 2.1 compare pane.PID with exe.PPID
    # ... profit

  local session="${1}"
  local window="${2}"
  local pane_idx="${3}"
  local exe="${4}"

  tmux_pane_id_for "${session}" "${window}" "${pane_idx}"
  if [ ! $? -eq 0 ]; then
    echo "failed to find pane: ${session}:${window}.${pane_idx}"
    return 1
  fi


  local pids=($(pgrep "${exe}"))
  if [ ! $? -eq 0 ]; then
    echo "failed to pgrep: ${exe}"
    return 1
  fi

  if [ ${#pids[@]} -eq 0 ]; then
    echo "did not find any pids for ${exe}"
    return 1
  fi

  pid_for_pane_id "${pane_id}"
  if [ ! $? -eq 0 ]; then
    echo "failed to get PPID from pid"
    return 1
  fi

  for pid in "${pids[@]}"; do
    ppid_for_pid "${pid}"
    if [ $? -eq 0 ]; then
      if [ "$ppid" = "$pid" ]; then
        echo "pid: ${pid} match"
        return 0
      fi
    fi
  done

  return 1

    # tmux_pane_tty "${session}" "${window}" "${pane_idx}"
    # if [ $? -eq 0 ]; then
    #   if [ "${exe_tty}" = "${pane_tty}" ]; then
    #     return 0
    #   else
    #     echo "${exe_tty} != ${pane_tty}"
    #     return 1
    #   fi
    # else
    #   echo "failed to find pane ${session}:${window}.${pane_idx}"
    #   return 1
    # fi

  # elif [ $? -eq 2 ]; then
  #   echo "ambiguous: multiple running: '${exe}'"
  #   return 1
  # else
  #   echo "not running: '${exe}'"
  #   return 1



  # gdb:
  # file /home/fredrik/development/sputil/exe
  # run
}

function is_sp_gdb_running() {
  pane_idx="1"
  is_exe_running_in_pane "" "sp_gdb" "${pane_idx}" "$(which gdb)"
}
