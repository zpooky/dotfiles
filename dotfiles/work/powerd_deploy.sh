#!/bin/bash

l_pass="pass"
l_ip="192.168.0.90"

tmp="$(mktemp -d)"
dir="/home/fredriol/dists/chanel29-idd"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1

  scp fredriol@pc32557-1841:$dir/builds/q3536-lve/workspace/sources/powerd/oe-workdir/package/usr/bin/powerd .
  if [ $? -eq 0 ]; then

    service=power-controller
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl stop ${service}"
    if [ ! $? -eq 0 ]; then
      echo " stop ${service} failed"
    fi

    sshpass -p "${l_pass}" scp powerd root@${l_ip}:/usr/bin/
    if [ ! $? -eq 0 ]; then
      echo " copy powerd failed"
      date
    fi

    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl start ${service}"
    if [ ! $? -eq 0 ]; then
      echo " start ${service} failed"
    fi
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi

