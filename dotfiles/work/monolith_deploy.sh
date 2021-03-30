#!/bin/bash

l_pass="pass"
l_ip="192.168.0.90"

tmp="$(mktemp -d)"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1

  scp fredriol@pc32557-1841:/home/fredriol/dists/chanel16-audio2/builds/q3536-lve/workspace/sources/monolith/monolith/oe-workdir/package/usr/bin/monolith .
  if [ $? -eq 0 ]; then
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl stop monolith"
    if [ ! $? -eq 0 ]; then
      echo " stop MONOLITH failed"
    fi
    ls -alh monolith
    sshpass -p "${l_pass}" scp monolith root@${l_ip}:/usr/bin
    if [ ! $? -eq 0 ]; then
      echo " copy MONOLITH failed"
    fi
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl start monolith"
    if [ ! $? -eq 0 ]; then
      echo " start MONOLITH failed"
    fi
  else
    echo "copy MONOLITH from dev failed"
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi
