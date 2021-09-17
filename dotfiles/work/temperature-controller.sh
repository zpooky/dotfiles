#!/bin/bash

l_pass="pass"
l_ip="192.168.0.90"

tmp="$(mktemp -d)"
dir="/home/fredriol/dists/chanel29-idd"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1
  echo "${PWD}"

  scp fredriol@pc32557-1841:${dir}/builds/q3536-lve/workspace/sources/temperature-ctrld/oe-workdir/package/usr/bin/temperature_ctrld .
  if [ $? -eq 0 ]; then
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl stop temperature-controller"
    if [ ! $? -eq 0 ]; then
      echo " stop temperature-controller failed"
    fi
    sha256sum temperature_ctrld

    sshpass -p "${l_pass}" scp temperature_ctrld root@${l_ip}:/usr/bin
    if [ ! $? -eq 0 ]; then
      echo " copy temperature-controller failed"
    fi
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl start temperature-controller"
    if [ ! $? -eq 0 ]; then
      echo " start temperature-controller failed"
    fi
  else
    echo "copy temperature_ctrld from dev failed"
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi
