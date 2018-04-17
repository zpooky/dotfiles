#!/bin/bash

#==================================================================
#=======GTEST=Stuff================================================
#==================================================================

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
#==================================================================
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
