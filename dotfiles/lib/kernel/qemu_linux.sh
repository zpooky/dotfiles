#!/bin/bash

function linux() {
  echo "linux"
  local linux_root="$HOME/sources/linux-shallow"

  if [ ! -e $linux_root ]; then
    echo "clone"

    git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git $linux_root
    if [ $? -eq 0 ]; then
      # CONFIG_DEBUG_INFO=y

      cd $linux_root
      if [ $? -eq 0 ]; then
        make x86_64_defconfig
        make kvmconfig
        eatmydata make -j 4
      fi
    else
      rm -rf $linux_root
      exit 1
    fi

  fi
}

function mk_rootfs() {
  echo "rootfs"
  # IMG=qemu-image.img
  # DIR=mount-point.dir
  # qemu-img create $IMG 1g
  # mkfs.ext2 $IMG
  # mkdir $DIR
  # sudo mount -o loop $IMG $DIR
  # sudo debootstrap --arch amd64 jessie $DIR
  # sudo umount $DIR
  # rmdir $DIR
}

function mk_chroot() {
  echo "chroot"
  # change root passwd
}

function setup() {
  echo "setup"
  linux
  mk_rootfs
  mk_chroot

  # https://www.collabora.com/news-and-blog/blog/2017/01/16/setting-up-qemu-kvm-for-kernel-development/
}

# In output/build/linux-3.10 is the downloaded kernel source code
# The output/images/bzImage is the built and compressed kernel image
# The output/images/rootfs.ext2 is the built root filesystem (rootfs)
# The output/build/linux-3.10/vmlinux is the raw kernel image
function run() {
  local linux_root="/home/spooky/sources/linux-shallow"
  # the_kernel="../vmlinux"
  local the_kernel="${linux_root}/arch/x86_64/boot/bzImage"
  local the_img="${linux_root}/spooky/qemu-image.img"

  local is_gdb=true

  local gdb_debug=""
  if [ $is_gdb ]; then
    # -S  Do not start CPU at startup (you must type 'c' in the monitor).
    # gdb_debug="-S -gdb tcp::1234 /dev/zero"
    echo "gdb debug: on"
  fi

  # #notes
  # hda=/dev/sda

  # #debug
  # '-s' gdb listen on tcp::1234
  # '-S' option makes Qemu stop execution until you give the continue command in gdb.
  # (gdb) target remote localhost:1234
  # (gdb) continue

  # command="qemu-system-x86_64 \
  #   -kernel ${the_kernel} \
  #   -m 256M \
  #   -hda ${the_img} \
  #   --append 'root=/dev/sda rw console=ttyS0' \
  #   --nographic \
  #   --enable-kvm \
  #   ${gdb_debug}"

  qemu-system-x86_64 \
    -kernel "${the_kernel}" \
    -m '256M' \
    -hda "${the_img}" \
    --append "root=/dev/sda rw console=ttyS0" \
    --append nokaslr \
    --nographic \
    --enable-kvm \
    -S -s

  # -S -gdb tcp::1234 /dev/zero

  # echo "${command}"
  # $command

}

run
