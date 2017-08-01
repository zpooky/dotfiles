#!/bin/bash

while true;
do
  eval "$@"
  RET=$?
  #test if '$1' has been interrupted. if so then break
  test $RET -gt 128 && break;
  test $RET -ne 0 && echo "ret:${RET}" && break;
done
