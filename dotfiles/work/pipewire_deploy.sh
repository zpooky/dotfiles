#!/bin/bash

l_pass="pass"
l_ip="192.168.0.90"

dir="/home/fredriol/dists/chanel24-beta"
tmp="$(mktemp -d)"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1

# oe-workdir/package/usr/lib/spa-0.2/alsa/libspa-alsa.so: FAILED
# oe-workdir/package/usr/lib/spa-0.2/alsa/.debug/libspa-alsa.so: FAILED
# oe-workdir/package/usr/bin/.debug/spa-acp-tool: FAILED
# : FAILED
# sha1sum: WARNING: 4 computed checksums did NOT match
#
# ~/dists/chanel24-beta/builds/q3536-lve/workspace/sources/pipewire:

  scp fredriol@pc32557-1841:${dir}/builds/q3536-lve/workspace/sources/pipewire/oe-workdir/package/usr/lib/spa-0.2/alsa/libspa-alsa.so .
  if [ ! $? -eq 0 ]; then
    exit 1
  fi
  scp fredriol@pc32557-1841:${dir}/builds/q3536-lve/workspace/sources/pipewire/oe-workdir/package/usr/bin/spa-acp-tool .
  if [ ! $? -eq 0 ]; then
    exit 1
  fi
  scp fredriol@pc32557-1841:${dir}/builds/q3536-lve/workspace/sources/pipewire/oe-workdir/package/usr/lib/alsa-lib/libasound_module_pcm_pipewire.so .
  if [ ! $? -eq 0 ]; then
    exit 1
  fi
  scp fredriol@pc32557-1841:${dir}/builds/q3536-lve/workspace/sources/pipewire/oe-workdir/package/usr/lib/alsa-lib/libasound_module_ctl_pipewire.so .
  if [ ! $? -eq 0 ]; then
    exit 1
  fi

    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl stop pipewire"
    if [ ! $? -eq 0 ]; then
      echo " stop PIPEWIRE failed"
      exit 1
    fi
    sshpass -p "${l_pass}" scp libspa-alsa.so root@${l_ip}:/usr/lib/spa-0.2/alsa/libspa-alsa.so
    if [ ! $? -eq 0 ]; then
      echo " copy libspa-alsa.so failed"
      exit 1
    fi

    sshpass -p "${l_pass}" scp spa-acp-tool root@${l_ip}:/usr/bin/spa-acp-tool
    if [ ! $? -eq 0 ]; then
      echo " copy spa-acp-tool failed"
      exit 1
    fi

    sshpass -p "${l_pass}" scp libasound_module_pcm_pipewire.so root@${l_ip}:/usr/lib/alsa-lib/libasound_module_pcm_pipewire.so
    if [ ! $? -eq 0 ]; then
      echo " copy spa-acp-tool failed"
      exit 1
    fi

    sshpass -p "${l_pass}" scp libasound_module_ctl_pipewire.so root@${l_ip}:/usr/lib/alsa-lib/libasound_module_ctl_pipewire.so
    if [ ! $? -eq 0 ]; then
      echo " copy spa-acp-tool failed"
      exit 1
    fi

    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl start pipewire"
    if [ ! $? -eq 0 ]; then
      echo " start PIPEWIRE failed"
      exit 1
    fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi

