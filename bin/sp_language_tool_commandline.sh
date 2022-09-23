#!/bin/bash

# comma spearated
disabled="-d UPPERCASE_SENTENCE_START,PUNCTUATION_PARAGRAPH_END,EN_QUOTES,DASH_RULE,WORD_CONTAINS_UNDERSCORE,WHITESPACE_RULE,ARROWS,COMMA_PARENTHESIS_WHITESPACE,DOUBLE_PUNCTUATION,UNLIKELY_OPENING_PUNCTUATION,UNIT_SPACE,NUMBERS_IN_WORDS,EN_UNPAIRED_BRACKETS,NON_STANDARD_WORD"
# disabled=""

# echo "java -Dfile.encoding=UTF-8 -jar languagetool-commandline.jar ${disabled} -c UTF-8 $@" >> /tmp/ddad.txt

usr_jar="/usr/share/java/languagetool/languagetool-commandline.jar"
if [ -e "${usr_jar}" ]; then
  java -Dfile.encoding=UTF-8 -jar "${usr_jar}" ${disabled} -c UTF-8 "$@"
elif [ -e "$HOME/bin/languagetool-commandline.jar" ]; then
  java -Dfile.encoding=UTF-8 -jar $HOME/bin/languagetool-commandline.jar ${disabled} -c UTF-8 "$@"
elif [ -e "/snap/languagetool/35/usr/bin/languagetool-commandline.jar" ]; then
  echo "java -Dfile.encoding=UTF-8 -jar /snap/languagetool/35/usr/bin/languagetool-commandline.jar ${disabled} -c UTF-8 $@" >> /tmp/wasd
  java -Dfile.encoding=UTF-8 -jar /snap/languagetool/35/usr/bin/languagetool-commandline.jar ${disabled} -c UTF-8 "$@"
else
  exit 1
fi
