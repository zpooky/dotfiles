#!/usr/bin/env bash

echo -e "# \e[1m\e[41m${1}\e[0m"

# ack does not support multiline grep
KEY="${1}"
# REGEXP_PATTERN="([ \t]*:[ \t]*public[ \t]*${1})|([ \t]*:[ \t]*protected[ \t]*${1})|([ \t]*:[ \t]*private[ \t]*${1})|(class[ \t]*[a-zA-Z0-9_]+[ \t]*:[ \t]*${1})"
NAMESPACE="([a-zA-Z0-9_]+::)"
REGEXP_PATTERN="(:[ \t]*((public)|(protected)|(private))[ \t]+${NAMESPACE}*${KEY})|(class[ \t]+[a-zA-Z0-9_]+[ \t]*:[ \t]*${NAMESPACE}*${KEY})"
echo "pattern: ${REGEXP_PATTERN}"
ack-grep "${REGEXP_PATTERN}" --cpp

# grep "public[ \t\n\r]*${1}" . -ir -Pzo --color --include=\*.{cpp,h}

#-o, --only-matching
#      Print only the matched (non-empty) parts of a matching line,
#      with each such part on a separate output line.
#
#-P, --perl-regexp
#      Interpret PATTERN as a Perl compatible regular expression (PCRE)
#
#-z, --null-data
#      Treat the input as a set of lines, each terminated by a zero byte (the ASCII 
#      NUL character) instead of a newline. Like the -Z or --null option, this option 
#      can be used with commands like sort -z to process arbitrary file names.
