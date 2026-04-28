#!/bin/bash

# comma spearated
disabled="-d UPPERCASE_SENTENCE_START,PUNCTUATION_PARAGRAPH_END,EN_QUOTES,DASH_RULE,WORD_CONTAINS_UNDERSCORE,WHITESPACE_RULE,ARROWS,COMMA_PARENTHESIS_WHITESPACE,DOUBLE_PUNCTUATION,UNLIKELY_OPENING_PUNCTUATION,UNIT_SPACE,NUMBERS_IN_WORDS,EN_UNPAIRED_BRACKETS,NON_STANDARD_WORD"
# disabled=""

# echo "java -Dfile.encoding=UTF-8 -jar languagetool-commandline.jar ${disabled} -c UTF-8 $@" >> /tmp/ddad.txt

# strip code scope (```) {
file="${@: -1}" # last arg is the file
tmp=$(mktemp -u)
if md_strip_code_block.py "${file}" "${tmp}"; then
  file="$tmp"
fi
last_cnt=$(( $# - 1))
set -- "${@: 1: $last_cnt}" "${file}"
# }

usr_jar="/usr/share/java/languagetool/languagetool-commandline.jar"
local_jar="$HOME/bin/languagetool-commandline.jar"
use_snap="/snap/languagetool/current/usr/bin/languagetool-commandline.jar"
if [ -e "${usr_jar}" ]; then
  java -Dfile.encoding=UTF-8 -jar "${usr_jar}" ${disabled} -c UTF-8 "$@"
elif [ -e "${local_jar}" ]; then
  java -Dfile.encoding=UTF-8 -jar "${local_jar}" ${disabled} -c UTF-8 "$@"
elif [ -e "${use_snap}" ]; then
  # echo "java -Dfile.encoding=UTF-8 -jar "${use_snap}" ${disabled} -c UTF-8 --mothertongue en-GB --autoDetect $@" >> /tmp/wasd
  java -Dfile.encoding=UTF-8 -jar "${use_snap}" ${disabled} -c UTF-8 --mothertongue en-GB --autoDetect "$@"
else
  exit 1
fi

# TODO limit autodetct language
# en-GB 
# sv

# TODO gitcommit... not working
