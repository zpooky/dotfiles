#!/usr/bin/env bash

echo -e "# \e[1m\e[41m${1}\e[0m"

# ack-grep "([ \t]+)|(\.[ \t]*)|(->[ \t]*)${1}\("
# ack-grep "(([ \t]+)|(\.[ \t]*)|(->[ \t]*))${1}[ \t]*\(.*\);"
# REG_MATCH="((=|(return)[ \t]+)|(\.[ \t]*)|(->[ \t]*))${1}[ \t]*\(.*\);"
# REG_MATCH="(((=[ \t]*)|(return)[ \t]+)|(\.[ \t]*)|(->[ \t]*))${1}[ \t]*\(.*\)[ \t]*;"
REG_MATCH="((([a-zA-Z]+::)|(=[ \t]*)|(return)[ \t]+)|(\.[ \t]*)|(->[ \t]*))${1}[ \t]*\(.*\)[ \t]*;"
echo "regex: ${REG_MATCH}"

ack-grep "${REG_MATCH}" --cpp


#TODO
#   Receive(recievedData, 0, 512, 0, &receivedBytes);
