#!/bin/bash

l_pass="pass"
l_ip="192.168.0.90"
dir="/home/fredriol/dists/chanel24-beta"

tmp="$(mktemp -d)"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1

  scp fredriol@pc32557-1841:${dir}/builds/q3536-lve/workspace/sources/audiodevicecontrol-cgi/oe-workdir/package/usr/html/axis-cgi/audiodevicecontrol.cgi .
  if [ $? -eq 0 ]; then
    sshpass -p "${l_pass}" scp audiodevicecontrol.cgi root@${l_ip}:/usr/html/axis-cgi/audiodevicecontrol.cgi
    if [ ! $? -eq 0 ]; then
      echo " copy audiodevicecontrol failed"
      date
    fi
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi
