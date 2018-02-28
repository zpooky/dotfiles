#!/bin/bash

# TODO support gdb debug mode
# TODO support running only the main executable
# TODO support running only the main executable+gdb
#TODO should after test run first tome we should watch for file chages and rerun the same precondition if new vimux command is issued recurse

# TODO should be in entr_loop -> vimux send interupt and pass new command
# TODO build lock

TEST_EXECUTABLE_NAME="thetest"

# if test file
if [ true ]; then
  function all_test_cases() {
    local file=$1
  }

  function line_is_gtest() {
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

  function find_test_executable() {
    local path=$1
    path="$(dirname $path)"

    while [[ "$path" != "/" ]]; do
      exe_path="$path/$TEST_EXECUTABLE_NAME"
      ls $exe_path >/dev/null 2>&1

      if [ $? -eq 0 ]; then
        test_EXECUTABLE="$exe_path"
        return 0
      fi

      path="$(readlink -f $path/..)"
    done

    echo "thetest executable was not found"
    exit 1
  }

  in_FILE=$1
  in_SEARCH=$2

  test_matches=()

  line_cnt=1
  while IFS='' read -r line || [[ -n "$line" ]]; do
    # TODO count nested levels{} to figure out if we are in root(meaning all tests should run) or that the cursor are inside a test function(meaning only that test should be run(the last in the arrray))

    line_is_gtest "$line"
    if [ $? -eq 0 ]; then
      # echo "./test/thetest --gtest_filter=\"*${BASH_REMATCH[1]}.${BASH_REMATCH[2]}*\""
      # echo "$line_cnt: $line"
      # echo "${BASH_REMATCH[@]}"

      exact_match="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
      # Default/ReadWriteLockThreadTest.threaded_TryPrepare/13 (5 ms)
      param_match="*${BASH_REMATCH[1]}.${BASH_REMATCH[2]}/*"
      test_matches+=("${exact_match}:${param_match}")
    fi

    if [ $in_SEARCH -eq $line_cnt ]; then
      # TODO if [ ! $nested_count -eq 0 ]; then
      echo "matches ${#test_matches[@]}"
      if [ ${#test_matches[@]} -gt 0 ]; then
        test_matches=(${test_matches[-1]})
        echo "constraint ${test_matches}"
        break
      fi
      # fi
    fi

    line_cnt=$((line_cnt + 1))
  done <"$in_FILE"

  # build command array
  find_test_executable "$in_FILE"
  command_arg="${test_EXECUTABLE} --gtest_filter=\""

  arg_first=0
  for current in "${test_matches[@]}"; do
    if [ $arg_first -eq 0 ]; then
      command_arg="${command_arg}${current}"
      arg_first=1
    else
      command_arg="${command_arg}:${current}"
    fi
  done
  command_arg="${command_arg}\""

  clear
  echo "$command_arg"
  # TODO eval "$HOME/dotfiles/lib/entr_cpp.sh $command_arg"
  eval "$command_arg"

fi
