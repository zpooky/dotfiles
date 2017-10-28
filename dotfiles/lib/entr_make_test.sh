#!/bin/bash

clear
echo "=========================================================================="

make -C test
if [ $? -eq 0 ]; then
./test/thetest $@
fi
