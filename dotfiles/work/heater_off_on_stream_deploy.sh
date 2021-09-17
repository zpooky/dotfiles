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

  # scp fredriol@pc32557-1841:${dir}/builds/${product}/workspace/sources/eventlistener/heater_off_on_stream.conf .
  # if [ $? -eq 0 ]; then
  #   sshpass -p "${l_pass}" scp heater_off_on_stream.conf root@${l_ip}:/etc/sysconfig/heater_off_on_stream.conf
  #   if [ ! $? -eq 0 ]; then
  #     echo " copy heater_off_on_stream.conf failed"
  #   fi
  # else
  #   echo "copy devices.json from dev failed"
  # fi

  scp fredriol@pc32557-1841:${dir}/builds/${product}/workspace/sources/eventlistener/oe-workdir/package/usr/bin/heater_off_on_stream .
  if [ $? -eq 0 ]; then
    sshpass -p "${l_pass}" scp heater_off_on_stream root@${l_ip}:/usr/bin
    if [ ! $? -eq 0 ]; then
      echo " copy heater_off_on_stream failed"
    fi
  else
    echo "copy heater_off_on_stream from dev failed"
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi
