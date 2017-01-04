#!/bin/bash

count=$(ls ~/.mail/work/inbox/new/ | wc -l)

if [ "$count" -gt 0 ]; then
  echo "┃ ✉ ${count} "
fi
