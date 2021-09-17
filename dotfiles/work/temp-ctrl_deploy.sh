#!/bin/bash

l_pass="pass"
l_ip="192.168.0.90"

tmp="$(mktemp -d)"
dir="/home/fredriol/dists/chanel34"
product="q3536-lve"
# dir="/home/fredriol/dists/coco-1-mic_disable"
# product="q1656"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1



  scp fredriol@pc32557-1841:${dir}/builds/${product}/workspace/sources/temperature-ctrld/oe-workdir/package/usr/bin/temperature_ctrld .
  if [ $? -eq 0 ]; then
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl stop temperature-controller"
    if [ ! $? -eq 0 ]; then
      echo " stop temp-ctrl failed"
    fi
    sshpass -p "${l_pass}" scp temperature_ctrld root@${l_ip}:/usr/bin
    if [ ! $? -eq 0 ]; then
      echo " copy temp-ctrl failed"
    fi
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl start temperature-controller"
    if [ ! $? -eq 0 ]; then
      echo " start temp-ctrl failed"
    fi
  else
    echo "copy temp-ctrl from dev failed"
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi

