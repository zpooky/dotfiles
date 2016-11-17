#!/bin/sh

count=$(ls ~/.mail/work/inbox/new/ | wc -l)

if [[ -n "$count"  && "$count" -gt 0 ]]; then
  echo "┃ ✉ ${count} "
fi
