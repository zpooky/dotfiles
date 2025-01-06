#!/usr/bin/env bash

if [ -z ${1} ]; then
  echo "no input -z"
  exit 1
fi
# if [ -n ${1} ]; then
#   echo "no input -n"
#   exit 1
# fi

the_ART=$1

TEAMCIL_yaml="$(mktemp -u ${TMPDIR}/teamcil_yaml.XXXXXXXXXXXXXX)"

name="$(mktemp -u XXXXXXXXXX)"
# echo $name

echo "windows:" >>$TEAMCIL_yaml
echo "  - name: ${name}" >>$TEAMCIL_yaml
echo "    root: $(pwd)" >>$TEAMCIL_yaml
echo "    layout: even-horizontal" >>$TEAMCIL_yaml
echo "    panes:" >>$TEAMCIL_yaml
# -cu  = comment unseen
echo "      - hn view ${the_ART} -cu | less -r" >>$TEAMCIL_yaml   # comment
echo "      - hn view ${the_ART} | fmt | less -r" >>$TEAMCIL_yaml #article

time teamocil --layout $TEAMCIL_yaml || exit 1

rm $TEAMCIL_yaml
