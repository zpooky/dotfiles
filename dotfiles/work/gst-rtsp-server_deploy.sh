l_pass="pass"
l_ip="192.168.0.90"

tmp="$(mktemp -d)"
dir="/home/fredriol/chanel31-latency"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1

  bin=libgstrtspclientsink.so
  scp fredriol@pc32557-1841:${dir}/builds/q3536-lve/workspace/sources/gstreamer1.0-rtsp-server/oe-workdir/package/usr/lib/gstreamer-1.0/${bin} .
  if [ $? -eq 0 ]; then
    service=monolith
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl stop ${service}"
    if [ ! $? -eq 0 ]; then
      echo " stop ${service} failed"
    fi

    ls -alh $bin
    sha256sum $bin
    sshpass -p "${l_pass}" scp ${bin} root@${l_ip}:/usr/lib/gstreamer-1.0
    if [ ! $? -eq 0 ]; then
      echo " DEPLOY ${bin} failed"
    else
      sshpass -p "${l_pass}" ssh -qt root@${l_ip} "sha256sum /usr/lib/gstreamer-1.0/${bin}"
    fi


    bin=libgstrtspserver-1.0.so.0.1803.0
    scp fredriol@pc32557-1841:${dir}/builds/q3536-lve/workspace/sources/gstreamer1.0-rtsp-server/oe-workdir/package/usr/lib/${bin} .
    if [ $? -eq 0 ]; then
      ls -alh $bin
      sha256sum $bin
      sshpass -p "${l_pass}" scp ${bin} root@${l_ip}:/usr/lib
      if [ ! $? -eq 0 ]; then
        echo " DEPLOY ${bin} failed"
      else
        sshpass -p "${l_pass}" ssh -qt root@${l_ip} "sha256sum /usr/lib/${bin}"
      fi
    else
      echo "DEPLOY ${bin} failed"
    fi

    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl start ${service}"
    if [ ! $? -eq 0 ]; then
      echo " start ${service} failed"
    fi
  else
    echo "DEPLOY ${bin} failed"
  fi

  rm -rf "${tmp}"
else
  echo "mktemp failed"
fi

