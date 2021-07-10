#!/usr/bin/env bash

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
    local path="${1}"

    search_path_upwards "${path}" "Makefile"
    if [ $? -eq 0 ]; then
      make_PATH="$search_RESULT"
      return 0
    else
      echo "Makefile was not found"
      exit 1
    fi
  }

  smart_gtest_test_cases "${in_FILE}" "${in_SEARCH}"
  if [ ! $? -eq 0 ]; then
    echo "smart_gtest_test_cases '${in_FILE}' '${in_SEARCH}': failed"
    exit 1
  fi

  # build command array
  find_test_executable "$in_FILE"
  command_arg="${test_EXECUTABLE} --gtest_filter=\""

  arg_first=1
  if [ $all_tests -eq 1 ]; then
    for current in "${group_matches[@]}"; do
      if [ $arg_first -eq 1 ]; then
        arg_first=0
      else
        command_arg="${command_arg}:"
      fi

      command_arg="${command_arg}${current}.*"
    done
  fi

  for current in "${test_matches[@]}"; do
    if [ $arg_first -eq 1 ]; then
      arg_first=0
    else
      command_arg="${command_arg}:"
    fi
    command_arg="${command_arg}${current}"
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
