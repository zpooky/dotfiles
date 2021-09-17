l_pass="pass"
l_ip="192.168.0.90"

tmp="$(mktemp -d)"
dir="/home/fredriol/dists/chanel29-gyro"
if [ $? -eq 0 ]; then
  cd "${tmp}" || exit 1

  bin=imagine-lua
  scp fredriol@pc32557-1841:${dir}/builds/q3536-lve/workspace/sources/imagine-lua/oe-workdir/package/usr/bin/${bin} .
  if [ $? -eq 0 ]; then
    service=vipd@0
    sshpass -p "${l_pass}" ssh -qt root@${l_ip} "systemctl stop ${service}"
    if [ ! $? -eq 0 ]; then
      echo " stop ${service} failed"
    fi

    ls -alh $bin
    sshpass -p "${l_pass}" scp ${bin} root@${l_ip}:/usr/bin
    if [ ! $? -eq 0 ]; then
      echo " DEPLOY ${bin} failed"
    fi

    bin="libbootblock_interface.so"
    scp fredriol@pc32557-1841:"${dir}/builds/q3536-lve/workspace/sources/imagine-lua/oe-workdir/package/usr/lib/imagine-lua/${bin}" .
    if [ $? -eq 0 ]; then
      ls -alh $bin
      sshpass -p "${l_pass}" scp ${bin} root@${l_ip}:/usr/lib/imagine-lua
      if [ ! $? -eq 0 ]; then
        echo " DEPLOY ${bin} failed"
      fi
    else
      echo " copy ${bin} failed"
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
