#!/bin/bash

l_pass="pass"
l_ip="192.168.0.90"

tmp="$(mktemp -d)"
dir="/home/fredriol/dists/chanel24-beta"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1

  scp fredriol@pc32557-1841:$dir/builds/q3536-lve/workspace/sources/mux-alsa-plugin/oe-workdir/package/usr/lib/alsa-lib/libasound_module_pcm_mux_alsa_plugin.so .
  if [ $? -eq 0 ]; then
    sshpass -p "${l_pass}" scp libasound_module_pcm_mux_alsa_plugin.so root@${l_ip}:/usr/lib/alsa-lib/libasound_module_pcm_mux_alsa_plugin.so
    if [ ! $? -eq 0 ]; then
      echo " copy alsa failed"
      date
    fi
  fi

  libasound=libasound.so.2.0.0
  scp fredriol@pc32557-1841:$dir/builds/q3536-lve/workspace/sources/alsa-lib/oe-workdir/package/usr/lib/$libasound .
  if [ $? -eq 0 ]; then
    sha256sum $libasound
    sshpass -p "${l_pass}" scp $libasound root@${l_ip}:/usr/lib/$libasound
    if [ ! $? -eq 0 ]; then
      echo " copy alsa failed"
      date
    fi
  fi

  libatopology=libatopology.so.2.0.0
  scp fredriol@pc32557-1841:$dir/builds/q3536-lve/workspace/sources/alsa-lib/oe-workdir/package/usr/lib/$libatopology .
  if [ $? -eq 0 ]; then
    sha256sum $libatopology
    sshpass -p "${l_pass}" scp $libatopology root@${l_ip}:/usr/lib/$libatopology
    if [ ! $? -eq 0 ]; then
      echo " copy alsa failed"
      date
    fi
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi
