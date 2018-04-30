#!/bin/bash

source $HOME/dotfiles/lib/vimcpp/shared.sh

BODY="$1"
ARG=${@:2:99}

TEMP_file=`mktemp /tmp/entr.XXXXXXXXXXXXXX`
if [ ! $? -eq 0 ]; then
  echo "failed to gen tmp file"
  exit 1
fi

# {
cur_pwd="$(pwd)"
search_path_upwards "${cur_pwd}" ".git"
if [ $? -eq 0 ]; then
  echo "git root: '$search_RESULT'"
  # echo "cd ${search_RESULT}"

  cd "${search_RESULT}"
  if [ !  $? -eq 0 ]; then
    echo "failed to cd to '${search_RESULT}'"
    exit 1
  fi
fi

# ack --cpp -f 
ack -f --cpp --print0 | xargs -n 1 -0 -I {} -- echo "$(pwd)/{}" > $TEMP_file
if [ ! $? -eq 0 ]; then
  echo "failed to ack for cpp files"
  cd "${cur_pwd}"
  exit 1
fi

cd "${cur_pwd}"
# }

has_feature "entr"
if [ $? -eq 0 ]; then
  cat $TEMP_file | entr $BODY $ARG
else
  cat $TEMP_file | $HOME/dotfiles/lib/timestamp_make.sh $BODY $ARG
fi

rm $TEMP_file
