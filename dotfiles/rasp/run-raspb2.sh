#!/usr/bin/env bash

# qemu-system-arm \
#   -machine raspi2 \
#   -kernel ./boot/kernel7.img \
#   -append "root=/dev/mmcblk0p2 panic=1 rootfstype=ext4 rw" \
#   -no-reboot \
#   -serial stdio \
  #-net nic -net user \
  #-net tap,ifname=vnet0,script=no,downscript=no

# "(cat ./boot/cmdline.txt)":
#console=serial0,115200 console=tty1 root=PARTUUID=6c586e13-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait quiet init=/usr/lib/raspi-config/init_resize.sh

# Linux version 4.19.75-v7+ 
# qemu-system-arm \
#     -M raspi2 \
#     -kernel ./boot/kernel7.img \
#     -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 root=PARTUUID=6c586e13-02 dwc_otg.lpm_enable=0 rootfstype=ext4 rootwait init=/usr/lib/raspi-config/init_resize.sh" \
#     -cpu arm1176 \
#     -dtb ./boot/bcm2709-rpi-2-b.dtb \
#     -sd ./raspbian-buster-lite.qcow2 \
#     -m 1G \
#     -smp 4 \
#     -serial stdio \
# ;


    # -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 rootfstype=ext4 root=/dev/mmcblk0p2" \
    # -sd ./2019-09-26-raspbian-buster-lite.img \

# 0. download raspbian
# 0.1 download qemu kernel & device tree https://github.com/dhruvvyas90/qemu-rpi-kernel

# 1. convert raspbian.img to acow2
# qemu-img convert -f raw -O qcow2 2019-09-26-raspbian-buster-lite.img raspbian-buster-lite.qcow2

# 2. qemu virtual arm where the filesystem is the qcow2 file
# TODO maybe PARTUUID will change between releases (see ./boot/cmdline.txt)
qemu-system-arm \
  -M versatilepb \
  -cpu arm1176 \
  -m 256 \
  -hda ./raspbian-buster-lite.qcow2 \
  -net nic \
  -net user,hostfwd=tcp::5022-:22 \
  -net user,hostfwd=tcp::9394-:8384 \
  -dtb ./versatile-pb.dtb \
  -kernel ./kernel-qemu-4.19.50-buster \
  -append 'root=PARTUUID=6c586e13-02 panic=1 rootfstype=ext4 console=ttyAMA0,115200' \
  -no-reboot \
  -nographic \
  ;

# 3. convert qcow2 back to img
# qemu-img convert ./raspbian-buster-lite.qcow2 ./spooky.img

# 4. write image to sdcard
# dd if=./spooky.img of=/dev/mmcblk0 status=progress

# ?. on raspberry pi run `raspi-config` advanced/expand_rootfs to be able to use the full capacity of the sdcard
