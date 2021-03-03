#!/bin/bash

# comma spearated
disabled="-d UPPERCASE_SENTENCE_START,PUNCTUATION_PARAGRAPH_END,EN_QUOTES,DASH_RULE,WORD_CONTAINS_UNDERSCORE,WHITESPACE_RULE,ARROWS"
# disabled=""

# echo "java -Dfile.encoding=UTF-8 -jar languagetool-commandline.jar ${disabled} -c UTF-8 $@" >> /tmp/ddad.txt

if [ -e "/usr/share/java/languagetool/languagetool-commandline.jar" ]; then
  java -Dfile.encoding=UTF-8 -jar "/usr/share/java/languagetool/languagetool-commandline.jar" ${disabled} -c UTF-8 "$@"
elif [ -e "$HOME/bin/languagetool-commandline.jar" ]; then
  java -Dfile.encoding=UTF-8 -jar $HOME/bin/languagetool-commandline.jar ${disabled} -c UTF-8 "$@"
else
  exit 1
fi
