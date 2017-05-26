#!/bin/bash

while true;
do
 $1
 #test if '$1' has been interrupted. if so then break
 test $? -gt 128 && break;
done
