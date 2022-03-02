#!/bin/bash
CHECK_FILE="./pw.sha512"

p() {
  printf '%b\n' "$1" >&2
}

bad() {
  p "\\e[31m[✘]\\e[0m ${1}"
}

good() {
  p "\\e[32m[✔]\\e[0m ${1}"
}

UPDATE=0
if [ "$#" -gt 0 ]; then
  if [ "$1" == "new" ]; then
    UPDATE=1
  else
    echo "unknown ${@}"
    exit 1
  fi
fi

if [ "${UPDATE}" -eq 1 ]; then
  echo "# Updating"
else
  echo "# Testing"
fi

echo -n 'Password: '
read -s password
echo

in=$(echo "${password}" | sha512sum)
if [ "${UPDATE}" -eq 1 ]; then
  echo "${in}" > "${CHECK_FILE}"
  good "Updated!"
else
  verify=$(cat "${CHECK_FILE}")
  if [ "${verify}" == "${in}" ]; then
    good "OK"
  else
    bad "FAILED"
    exit 1
  fi
fi

