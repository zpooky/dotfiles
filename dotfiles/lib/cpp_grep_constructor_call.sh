#!/bin/bash

echo -e "# \e[1m\e[41m${1}\e[0m"
KEY="${1}"
VARIABLE_NAME="([a-zA-Z][0-9a-zA-Z]*)"
NAMESPACE="([a-zA-Z]+::)"
SCOPED_PARAMETER="[ \t]*\(.*\)[ \t]*"
# Class(),);
# TODO Class<Type>(),);
UNNAMED="${NAMESPACE}*${KEY}${SCOPED_PARAMETER}[),;]"
NAMED="${NAMESPACE}*${KEY}[ \t]+${VARIABLE_NAME}${SCOPED_PARAMETER};"
# NEWED="new ${UNNAMED}"
PARENT_CONSTRUCTOR="[:,][ \t]*${KEY}${SCOPED_PARAMETER}[ \t]*"

REG_MATCH="(${UNNAMED})|(${NAMED})|(${PARENT_CONSTRUCTOR})"
# REG_MATCH=$PARENT_CONSTRUCTOR

echo "regex: ${REG_MATCH}"

ack-grep "${REG_MATCH}" --cpp
