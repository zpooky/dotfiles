#!/bin/bash

l_pass="pass"
l_ip="192.168.0.90"

tmp="$(mktemp -d)"
dir="/home/fredriol/dists/chanel28-portcast"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1

  io2d=io2d
  sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl stop $io2d"
  if [ ! $? -eq 0 ]; then
    echo " stop $io2d failed"
  fi

  scp fredriol@pc32557-1841:$dir/builds/q3536-lve/workspace/sources/io2d/oe-workdir/package/usr/bin/$io2d .
  if [ $? -eq 0 ]; then
    sha256sum $io2d
    sshpass -p "${l_pass}" scp $io2d root@${l_ip}:/usr/bin/$io2d
    if [ ! $? -eq 0 ]; then
      echo " copy alsa failed"
      date
    fi
  fi

  sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl start $io2d"
  if [ ! $? -eq 0 ]; then
    echo " start $io2d failed"
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi
