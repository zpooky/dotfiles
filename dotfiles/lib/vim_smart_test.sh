#!/bin/bash

source $HOME/dotfiles/lib/vimcpp/shared.sh

# TODO support running only the main executable
# TODO support running only the main executable+gdb
# TODO build lock

# ./script <cpp_file> <line>

in_FILE="${1}"
in_SEARCH="${2}"

# if test file
if [ true ]; then

  function find_test_make() {
    local path=$1
    local path="$(dirname $path)"

    search_path_upwards "${path}" "Makefile"
    if [ $? -eq 0 ]; then
      make_PATH="$search_RESULT"
      return 0
    else
      echo "Makefile was not found"
      exit 1
    fi
  }

  test_matches=()

  line_cnt=1
  while IFS='' read -r line || [[ -n "$line" ]]; do
    # TODO count nested levels{} to figure out if we are in root(meaning all
    # tests should run) or that the cursor are inside a test function(meaning
    # only that test should be run(the last in the arrray))

    is_line_gtest "$line"
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

  find_test_make "$in_FILE"

  # clear

  # TODO make entr run in the root where it finds the .git dir
  # echo "$command_arg"
  # echo ""
  # echo ""
  # echo ""
  # echo ""
  # echo "$HOME/dotfiles/lib/entr_cpp.sh $HOME/dotfiles/lib/make_test_body.sh $make_PATH $command_arg"
  # exit 1

  #     <script that detects changes>  <what to execute on change>          <arguements to on chane script>
  eval "$HOME/dotfiles/lib/entr_cpp.sh $HOME/dotfiles/lib/make_test_body.sh $make_PATH $command_arg"
  # eval "$command_arg"

fi
