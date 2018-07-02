#!/bin/bash

include_initfs="$1"

#===
source_root="${HOME}/dotfiles/lib/kernel"
busybox_dest_root="$HOME/sources/busybox"

version="1.28.4"
initfs="${busybox_dest_root}/initramfs-${version}/x86-busybox"
initfs_cpio="${initfs}/initramfs-busybox-x86.cpio.gz"

#===
linux_root="$HOME/sources/linux-shallow"
bz_image="${linux_root}/arch/x86/boot/bzImage"

priv="${pwd}"

function build_busybox() {
  echo "# build_busybox"

  local config="${source_root}/.config-${version}"
  local dest_file="busybox-${version}"
  local dest="${busybox_dest_root}/${dest_file}"
  local busybox_tar="${dest}.tar.bz2"
  local busybox_tar_file="${dest_file}.tar.bz2"

  if [ ! -e "${busybox_dest_root}" ]; then
    mkdir "$busybox_dest_root"
  fi

  cd "$busybox_dest_root"
  if [ ! $? -eq 0 ]; then
    cd "$priv"
    exit 1
  fi

  if [ ! -e "${dest}" ]; then

    wget "http://busybox.net/downloads/${busybox_tar_file}"
    if [ ! $? -eq 0 ]; then
      rm "${busybox_tar}"
      cd "$priv"
      exit 1
    fi

    tar -xvf "${busybox_tar}"
    RET=$?

    rm "${busybox_tar}"

    if [ ! $RET -eq 0 ]; then
      cd "$priv"
      exit 1
    fi

  fi

  cd "${dest}"
  if [ ! $? -eq 0 ]; then
    cd "$priv"
    exit 1
  fi

  if [ -e $config ]; then
    cp "$config" .config
    if [ ! $? -eq 0 ]; then
      cd "$priv"
      exit 1
    fi
  else
    eatmydata make defconfig
    if [ ! $? -eq 0 ]; then
      cd "$priv"
      exit 1
    fi

    # Busybox Settings --> Build Options --> Build Busybox as a static binary
    eatmydata make menuconfig
    if [ ! $? -eq 0 ]; then
      cd "$priv"
      exit 1
    fi

    cp .config "${config}"
    if [ ! $? -eq 0 ]; then
      cd "$priv"
      exit 1
    fi
  fi

  eatmydata make -j 4
  if [ ! $? -eq 0 ]; then
    cd "$priv"
    exit 1
  fi

  eatmydata make install
  if [ ! $? -eq 0 ]; then
    rm -rf _install
    cd "$priv"
    exit 1
  fi

  #==
  local busybox_install="${dest}/_install"

  if [ -e "${initfs}" ]; then
    rm -rf "${initfs}"
  fi

  mkdir -p "${initfs}"
  cd "${initfs}"
  mkdir -pv {bin,sbin,etc,proc,sys,usr/{bin,sbin}}

  cp -av "${busybox_install}/." .
  if [ ! $? -eq 0 ]; then
    cd "$priv"
    exit 1
  fi

  #==
  cp "${source_root}/busybox_init.sh" ./init
  if [ ! $? -eq 0 ]; then
    cd "$priv"
    exit 1
  fi

  #==
  if [ -e "${include_initfs}" ]; then
    echo "===================================="
    cp -r "${include_initfs}" .
    echo "===================================="
  fi

  #==
  cp "$source_root/.profile" ./etc/profile

  #==
  if [ -e "${initfs_cpio}" ]; then
    rm "${initfs_cpio}"
  fi

  find . -print0 |
    cpio --null -ov --format=newc |
    gzip -9 >"${initfs_cpio}"
  if [ ! $? -eq 0 ]; then
    cd "$priv"
    exit 1
  fi

}

function build_linux() {
  local linux_config="${linux_root}/.config"
  local linux_build_config="${linux_root}/linux_build_config"
  echo "#build_linux"

  if [ ! -e "${linux_root}" ]; then
    echo "linux source not found"
    cd "${priv}"
    exit 1
  fi

  cd "${linux_root}"

  if [ ! -e ${linux_config} ]; then
    # x86 config
    eatmydata make x86_64_defconfig
    if [ ! $? -eq 0 ]; then
      cd "$priv"
      exit 1
    fi

    # options for qemu
    eatmydata make kvmconfig
    if [ ! $? -eq 0 ]; then
      cd "$priv"
      exit 1
    fi

    cp "${source_root}/linux_build_config" "${linux_build_config}"
    ${linux_root}/scripts/kconfig/merge_config.sh "${linux_config}" "${linux_build_config}"
    if [ ! $? -eq 0 ]; then
      cd "$priv"
      exit 1
    fi

    # TODO make with debug symbols & gdb

  fi

  # - "make" will build kernel and drivers. Building drivers takes much more
  #   time than kernel. And we don't need drivers.
  # - "make bzImage" will build only kernel image
  eatmydata make -j8 bzImage
  if [ ! $? -eq 0 ]; then
    cd "$priv"
    exit 1
  fi
}

function run_qemu() {
  if [ ! -e "${bz_image}" ]; then
    echo "missing bzImage"
    cd "$priv"
    exit 1
  fi

  if [ ! -e "${initfs_cpio}" ]; then
    echo "missing initfs"
    cd "$priv"
    exit 1
  fi

  # -kernel: location of kernel image
  # -initrd: location of filesystem image
  # -nographic -append "console=ttyS0 init=/init": print the kernel booting message on your terminal
  #     Without this option, you cannot see anything.
  # -enable-kvm: use kvm driver. It is not mandatory but it makes booting fast.
  # -s: gdb listen on tcp::1234
  qemu-system-x86_64 -smp 4 -kernel "${bz_image}" \
    -initrd "${initfs_cpio}" \
    -nographic \
    -append "console=ttyS0 init=/init nokaslr" \
    -s

  # {
  # TODO this breaks gdb debugging
  # https://stackoverflow.com/questions/46069388/kernel-debugging-gdb-step-jumps-out-of-function
  # -enable-kvm \
  # }

  # -S
}

build_busybox
build_linux
run_qemu

cd "${priv}"
