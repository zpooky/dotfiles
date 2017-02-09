#!/bin/bash

# based on https://github.com/gpakosz/.newsbeuter/blob/master/bookmark.sh

BOOKMARK_FILE=~/.newsbeuter/bookmarks.txt

[ "$#" -eq 0 ] && exit 1
if [ -n $(command -v curl) ]; then
  url=$(curl -sIL -o /dev/null -w '%{url_effective}' "$1")
else
  url="$1"
fi


grep -q "${url}" $BOOKMARK_FILE || echo "${url}" >> $BOOKMARK_FILE
