#!/bin/bash

SOURCE_FILES=()
EXECUTER_FILE="$1"
if [ ! -e "$EXECUTER_FILE" ]; then
  echo "missing executor '${EXECUTER_FILE}'"
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
        SOURCE_FILES+=("${file}")
      fi
    fi

  done
else
  echo "No piped files"
  return 1
fi

MOD_DATE=()
SOURCE_LENGTH=${#SOURCE_FILES[@]}
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
    file="${SOURCE_FILES[$COUNTER]}"
    # echo "${file}"

    # %Y - Time of last modification as seconds since Epoch
    NEW_DATE="`stat -c %Y $file`"

    # temp fix for vim mv bug?
    if [ ! -z $NEW_DATE ]; then

      if [ ${#MOD_DATE[@]} -eq $SOURCE_LENGTH ]; then
        if [ ${NEW_DATE} -gt ${MOD_DATE[$COUNTER]} ]; then
          # echo "$file is changed"
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
    $EXECUTER_FILE
    SLEEP_SEC=1
    REBUILD=false
  else
    if [ $SLEEP_SEC -lt 2 ]; then
      let SLEEP_SEC=SLEEP_SEC+1
    fi

    sleep $SLEEP_SEC
  fi

done
