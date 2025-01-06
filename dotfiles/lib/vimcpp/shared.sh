#!/usr/bin/env bash

#==================================================================
#=======GTEST=Stuff================================================
#==================================================================
# arg: path
# out: 0:true/1:false
# result: $test_EXECUTABLE
function find_test_executable() {
  local path=$1
  local path="$(dirname $path)"

  echo "path: ${path}"

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

  local regEx_TEST_F='^[[:space:]]*TEST_F\((.+)[[:space:]]*,[[:space:]]*(.+)\)'
  local regEx_TEST_P='^[[:space:]]*TEST_P\((.+)[[:space:]]*,[[:space:]]*(.+)\)'
  local regEx_TEST='^[[:space:]]*TEST\((.+)[[:space:]]*,[[:space:]]*(.+)\)'
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
  local in_SEARCH_line="$2"

  if [ ! -e "$in_FILE" ]; then
    return 1
  fi

  if [ ! -f "$in_FILE" ]; then
    return 1
  fi

  group_matches=()
  test_matches=()
  all_tests=1
  local line_cnt=1

  while IFS='' read -r line || [[ -n "$line" ]]; do
    # TODO count nested levels{} to figure out if we are in root(meaning all
    # tests should run) or that the cursor are inside a test function(meaning
    # only that test should be run(the last in the arrray))

    is_line_gtest "$line"
    if [ $? -eq 0 ]; then
      # echo "./test/thetest --gtest_filter=\"*${BASH_REMATCH[1]}.${BASH_REMATCH[2]}*\""
      # echo "$line_cnt: $line"
      # echo "${BASH_REMATCH[@]}"

      # echo "base[1]: ${BASH_REMATCH[1]}"
      # echo "base[2]: ${BASH_REMATCH[2]}"
      local exact_match="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
      # Default/ReadWriteLockThreadTest.threaded_TryPrepare/13 (5 ms)
      local param_match="*${BASH_REMATCH[1]}.${BASH_REMATCH[2]}/*"

      test_matches+=("${exact_match}:${param_match}")
      group_matches+=("${BASH_REMATCH[1]}")
    fi

    # if we are currently on the searched line
    if [ $in_SEARCH_line -eq $line_cnt ]; then
      # TODO if [ ! $nested_count -eq 0 ]; then
      # echo "matches ${#test_matches[@]}"
      # if there is more than zero tests
      if [ ${#test_matches[@]} -gt 0 ]; then
        # take the last found test
        test_matches=(${test_matches[-1]})
        group_matches=(${group_matches[-1]})
        all_tests=0
        # echo "constraint ${test_matches}"
        break
      fi
      # fi
    fi

    local line_cnt=$((line_cnt + 1))
  done <"$in_FILE"

  # unique
  group_matches=($(for v in "${group_matches[@]}"; do echo "$v";done| sort| uniq| xargs))

  return 0
}

# arg: file
# arg: line
function gtest_for_file_line() {
  local in_FILE="$1"
  local in_SEARCH="$2"

  if [ ! -e "$in_FILE" ]; then
    echo "file '${in_FILE}' does not exist"
    return 1
  fi

  if [ ! -f "$in_FILE" ]; then
    echo "is not a file '${in_FILE}'"
    return 1
  fi

  test_matcher=""
  local test_cnt=0
  local line_cnt=1

  while IFS='' read -r line || [[ -n "$line" ]]; do
    # TODO count nested levels{} to figure out if we are in root(meaning all
    # tests should run) or that the cursor are inside a test function(meaning
    # only that test should be run(the last in the array))

    # echo "${line}"
    is_line_gtest "${line}"
    if [ $? -eq 0 ]; then
      local exact_match="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
      # Default/ReadWriteLockThreadTest.threaded_TryPrepare/13 (5 ms)
      local param_match="*${BASH_REMATCH[1]}.${BASH_REMATCH[2]}/*"

      test_matcher="${exact_match}:${param_match}"

      local test_cnt=$((test_cnt + 1))
    fi

    # if we are currently on the searched line
    if [ $in_SEARCH -eq $line_cnt ]; then

      # if there is more than zero tests
      if [ $test_cnt -gt 0 ]; then
        break
      else
        echo "not tests found '${test_cnt}'"
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
  local path="${1}"
  local needle="${2}"

  if [ ! -d "${path}" ]; then
    # not a directory, goto parent
    local path="$(dirname $path)"
  fi

  while [[ "$path" != "/" ]]; do

    for needle in "${@}"; do
      local test_path="${path}/${needle}"

      if [ -e "${test_path}" ]; then
        search_RESULT="${path}"
        return 0
      fi
    done

    local path="$(readlink -f $path/..)"
  done

  return 1
}

function is_cygwin() {
  if [[ $(uname -s) =~ CYGWIN.* ]]; then
    return 0
  else
    return 1
  fi
}

function has_feature() {
  local feature="$1"

  # which $feature > /dev/null 2>&1
  # local which_feature=$?

  hash $feature > /dev/null 2>&1
  local hash_feature=$?

  # if [ $which_feature -eq $hash_feature ]; then
    if [ $hash_feature -eq 0 ]; then
      return 0
    fi
  # fi

  return 1
}

#==================================================================
#====TMUX==========================================================
#==================================================================

function tmux_new_window(){
  local name="${1}"

  local tmp_wid=$(mktemp ${TMPDIR}/tmp.XXXXXXXXXXXXXX -u)
  local comm="tmux display -p '#{window_id}' > $tmp_wid"

  tmux new-window -n "${name}" "${comm};${SHELL}"
  if [ ! $? -eq 0 ]; then
    return 1
  fi

  while [ ! -e "${tmp_wid}" ]; do
    sleep 0.1
  done

  window_id=$(cat ${tmp_wid})

  rm $tmp_wid
  return 0
}

# function is_tmux_window() {
#   local needle="${1}"
#   return 0
# }

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

function ppid_for_pid() {
  pid="${1}"

  is_cygwin
  if [ $? -eq 0 ]; then

    str=($(ps -p "${pid}" | tail -1))
    if [ !  $? -eq 0 ]; then
      echo "pid is not running"
      return 1
    fi

    ppid_out="${str[1]}"

  else

    str=($(ps -p "${pid}" o pid,ppid | tail -1))
    if [ !  $? -eq 0 ]; then
      echo "pid is not running"
      return 1
    fi

    ppid_out="${str[1]}"

  fi
  return 0
}

# function ppid_for_exe() {
#   local exe="${1}"
#
#   pids=($(pgrep "${exe}"))
#   if [ ! $? -eq 0 ]; then
#     echo "failed to pgrep"
#     return 1
#   fi
#
#   if [ ${#pids[@]} -eq 0 ]; then
#     echo "no running ${exe}"
#     return 1
#   fi
#
# }


# cygwin
# $ ps aux | grep 7528                                                                                                                                                                                                       [0][0.0s][]
#       PID    PPID    PGID     WINPID   TTY         UID    STIME COMMAND
#       228    7528     228       8756  pty4     1051816 15:19:31 /usr/bin/gdb
#      7528    4452    7528       7784  pty4     1051816 15:19:30 /usr/bin/zsh

function pid_for_pane_id() {
  local pane_id="${1}"
  local needle="[${pane_id}]"

  local str=$(tmux list-panes -t "${pane_id}" -F "[#{pane_id}] #{pane_pid}")
  if [ $? -eq 0 ]; then
    # local str=$(echo ${str} | grep "\[${pane_idx}\]")

    local arr=(${str})
    local next=false
    local set=false
    local id=""
    for current in "${arr[@]}"; do
      # echo "${current}:${next}"

      if [ "$next" = true ]; then
        local result="${current}"
        local set=true
        break
      fi

      if [ "${current}" = "${needle}" ]; then
        local next=true
      fi
    done

    # echo "_${result}_"
    # echo "|${str}|"

    if [ "$set" = true ]; then
      pid_out="${result}"
      return 0
    else
      echo "needle: '${needle}' was not found"
      return 1
    fi

  else
    echo "failed to: '${command}'"
    return 1
  fi
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
    echo "fauiled to tmux list-panes"
    return 1
  fi
}

# function pids_for_exe_and_ppid() {
# # ps aux                                                                                                                    [0][0.0s][]
# #       PID    PPID    PGID     WINPID   TTY         UID    STIME COMMAND
# #      8320    1804    8320       5488  pty6     1051816 11:43:37 /home/fredrik/bin/sshpass
# #       300    1512     300       9696  pty22    1051816 12:00:10 /home/fredrik/bin/vim
#   local exe="${1}"
#   local pane_pid="${2}"
#
#   is_cygwin
#   if [ $? -eq 0 ]; then
#     return 1
#   else
#     echo "no linux support"
#     exit 1
#   fi
# }

function is_exe_running_in_pane() {
  local session="${1}"
  local window="${2}"
  local pane_idx="${3}"
  local exe="${4}"

  tmux_pane_id_for "${session}" "${window}" "${pane_idx}"
  if [ ! $? -eq 0 ]; then
    echo "failed to find pane: ${session}:${window}.${pane_idx}"
    return 1
  fi

  pid_for_pane_id "${pane_id}"
  if [ ! $? -eq 0 ]; then
    echo "failed to get PPID from pid"
    return 1
  fi
  pane_pid="${pid_out}"

  # pids_for_exe_and_ppid "${exe}" "${pane_pid}"
  local pids=($(pgrep "${exe}"))
  if [ ! $? -eq 0 ]; then
    echo "failed to pgrep: ${exe}"
    return 1
  fi

  pids_cnt=${#pids[@]}
  # if [ ! ${pids_cnt} -eq 1 ]; then
  #   echo "'${pids_cnt}' is not 1, exe: '${exe}' ppid: '${pane_id}'"
  #   return 1
  # fi

  if [ ${pids_cnt} -eq 0 ]; then
    echo "number of pids: '${pids_cnt}', exe: '${exe}' ppid: '${pane_id}'"
    return 1
  fi

  for pid in "${pids[@]}"; do
    ppid_for_pid "${pid}"
    if [ $? -eq 0 ]; then
      # echo  "${ppid_out} = ${pane_pid}"
      if [ "${ppid_out}" = "${pane_pid}" ]; then
        # echo "pid: ${pid} match"
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
  local session=""
  local window="sp_gdb"
  local pane_idx="1"
  # TODO will not work when it is aliased
  local exe="$(which gdb)"
  is_exe_running_in_pane "${session}" "${window}" "${pane_idx}" "${exe}"
}
