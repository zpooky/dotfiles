#!/bin/bash

l_pass="pass"
l_ip="192.168.0.90"

tmp="$(mktemp -d)"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1

  scp fredriol@pc32557-1841:/home/fredriol/dists/chanel16-audio2/builds/q3536-lve/workspace/sources/mux-alsa-plugin/oe-workdir/package/usr/lib/alsa-lib/libasound_module_pcm_mux_alsa_plugin.so .
  if [ $? -eq 0 ]; then
    sshpass -p "${l_pass}" scp libasound_module_pcm_mux_alsa_plugin.so root@${l_ip}:/usr/lib/alsa-lib/libasound_module_pcm_mux_alsa_plugin.so
    if [ ! $? -eq 0 ]; then
      echo " copy alsa failed"
      date
    fi
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi
