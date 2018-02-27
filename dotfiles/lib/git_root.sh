#!/bin/bash
# set -e
path="`pwd`"
# shift 1
# echo "|$path"
while [[ "$path" != "/" ]];
do
    GIT_PATH="$path/.git" 
    ls $GIT_PATH > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "$path"
      exit 0
    fi
    # echo "$GIT_PATH/$RET"
    #  make relative path absolute
    path="$(readlink -f $path/..)"
done
echo "`pwd`"
