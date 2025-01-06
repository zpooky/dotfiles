#!/usr/bin/env bash

source $HOME/dotfiles/lib/vimcpp/shared.sh

BODY="$1"
ARG=${@:2:99}

TEMP_file="$(mktemp ${TMPDIR}/entr.XXXXXXXXXXXXXX)"
if [ ! $? -eq 0 ]; then
  echo "failed to gen tmp file"
  exit 1
fi

cur_pwd="$PWD"
wd="${cur_pwd}"

# echo "#####'${2}'"
if [ -e ${2} ] && [ ! "${2}" = "" ]; then
  # hacky we assume first arg is a fiel or path
  wd="${2}"
fi

# {
# TODO not use pwd instead file arg
search_path_upwards "${wd}" ".git"
if [ $? -eq 0 ]; then
  echo "git root: '$search_RESULT'"
  # echo "cd ${search_RESULT}"

  cd "${search_RESULT}"
  if [ ! $? -eq 0 ]; then
    echo "failed to cd to '${search_RESULT}'"
    exit 1
  fi
else
  echo "failed finding root"
  exit 2
fi

# ack --cpp -f 
ack -f --cpp --meson --make --cmake --rust --scala --java --print0 --ignore-dir=googletest | xargs -n 1 -0 -I {} -- echo "$(pwd)/{}" > $TEMP_file
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
