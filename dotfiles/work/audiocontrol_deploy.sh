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

  scp fredriol@pc32557-1841:${dir}/meta-axis-bsp/conf/machine/product-config/audiocontrol-conf/${product}/devices.json .
  if [ $? -eq 0 ]; then
    sshpass -p "${l_pass}" scp devices.json root@${l_ip}:/usr/share/audiocontrol
    if [ ! $? -eq 0 ]; then
      echo " copy devices.json failed"
    fi
  else
    echo "copy devices.json from dev failed"
  fi

  scp fredriol@pc32557-1841:${dir}/builds/${product}/workspace/sources/audiocontrol/oe-workdir/package/usr/bin/audiocontrol .
  if [ $? -eq 0 ]; then
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl stop audiocontrol"
    if [ ! $? -eq 0 ]; then
      echo " stop AUDICONTROL failed"
    fi
    sshpass -p "${l_pass}" scp audiocontrol root@${l_ip}:/usr/bin
    if [ ! $? -eq 0 ]; then
      echo " copy AUDICONTROL failed"
    fi
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "rm /etc/audiocontrol/device_settings.json"
    if [ ! $? -eq 0 ]; then
      echo " rm AUDICONTROL SETTINGS failed"
    fi
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl start audiocontrol"
    if [ ! $? -eq 0 ]; then
      echo " start AUDICONTROL failed"
    else
      sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl restart monolith"
      if [ ! $? -eq 0 ]; then
        echo " restart MONOLITH failed"
      fi
    fi
  else
    echo "copy AUDICONTROL from dev failed"
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi