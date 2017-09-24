#!/bin/bash

clear

make -C test
./test/thetest $@
