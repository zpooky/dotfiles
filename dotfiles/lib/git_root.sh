#!/usr/bin/env bash
# set -e

path="${PWD}"
# shift 1
# echo "|$path"
while [[ "$path" != "/" ]]; do
    git_path="$path/.git"
    ls "${git_path}" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo "$path"
      exit 0
    fi
    # echo "$git_path/$RET"
    #  make relative path absolute
    path=$(readlink -f "${path}/..")
done

echo "${PWD}"
