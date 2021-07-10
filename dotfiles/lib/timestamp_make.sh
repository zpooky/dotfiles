#!/usr/bin/env bash

source_files=()
executer_file="$1"
args=${@:2:99}

if [ ! -e "$executer_file" ]; then
  echo "missing executor '${executer_file}'"
  exit 1
fi

# Check to see if a pipe exists on stdin.
if [ -p /dev/stdin ]; then
  # Read line by line
  while IFS= read file; do
    if [ ! -e "${file}" ]; then
      echo "not existing ${file}"
    else
      if [[ ! ${file} =~ ^external.* ]]; then
        # echo "$file"
        source_files+=("${file}")
      fi
    fi

  done
else
  echo "No piped files"
  exit 1
fi

# echo "${source_files[@]}"

MOD_DATE=()
SOURCE_LENGTH=${#source_files[@]}
SLEEP_SEC=1

if [ $SOURCE_LENGTH -eq 0 ]; then
  echo "no files to watch"
  pwd
  exit 1
fi

REBUILD=true

while [ true ]; do

  COUNTER=0
  while [ $COUNTER -lt $SOURCE_LENGTH ]; do
    file="${source_files[$COUNTER]}"
    # echo "${file}"

    # %Y - Time of last modification as seconds since Epoch
    NEW_DATE="`stat -c %Y $file`"

    # temp fix for vim mv bug?
    if [ ! -z $NEW_DATE ]; then

      if [ ${#MOD_DATE[@]} -eq $SOURCE_LENGTH ]; then
        if [ ${NEW_DATE} -gt ${MOD_DATE[$COUNTER]} ]; then
          echo "$file is changed"
          REBUILD=true
        fi
        MOD_DATE[$COUNTER]=$NEW_DATE
      else
        # this is the first time we run the while true loop.
        # Therefore we only fill the compare are since there is
        # nothing to compare with
        MOD_DATE+=($NEW_DATE)
      fi
    else
      REBUILD=true
    fi

    let COUNTER=COUNTER+1
  done

  if [ $REBUILD = true ]; then
    echo "should rebuild"
    # echo "-----------------"
    $executer_file $args
    SLEEP_SEC=1
    REBUILD=false
  else
    if [ $SLEEP_SEC -lt 2 ]; then
      let SLEEP_SEC=SLEEP_SEC+1
    fi

    sleep $SLEEP_SEC
  fi

done
