#!/bin/bash

dir="${1}"
if [ ! -e "${dir}" ]; then
  echo "is not a dir '${dir}'" >&2
  exit 1
fi

function cp_ycm_template(){
  local dir="${1}"
  local comp_db="${2}"

  local ycm_conf="${dir}/.ycm_extra_conf.py"
  # echo "${ycm_conf}"
# echo << EOF
#
# EOF

  cp "${HOME}/.ycm_extra_conf.py" "${ycm_conf}"
  if [ $? -eq 0 ]; then
    # echo "sed -i 's|compilation_database_folder = ''|compilation_database_folder = '${dir}'|' ${ycm_conf}"
    sed -i "s|compilation_database_folder = ''|compilation_database_folder = '${dir}'|" "${ycm_conf}"
    if [ $? -eq 0 ]; then
      return 0
    fi
  fi

  return 1
}

function main() {
  local force="${1}"
  #use the folder name as package name
  # package=$(pwd | sed "s/.*\///")
  local package=$(basename "${dir}")
  local comp_db="${dir}/compile_commands.json"

  echo $package

  echo "========================================================="
  echo "===============$package=================================="
  echo "========================================================="

  if [ "${force}"=="force" ] || [ "${force}"=="true" ]; then
    echo "force"
  else
    echo "not force"
    if [ -e "${comp_db}" ]; then
      echo "'${comp_db}' already exists"
      return 0
    fi
  fi

  #this will let vim call bitbake with correct package name
  # export PACKAGE=$package

  #Make sure we rebuild everything with bear to capture the compilation database.
  bitbake -c clean $package #Clean to make everything compile
  if [ ! $? -eq 0 ]; then
    echo "bitbake -c clean $package" >&2
    return 1
  fi

  #The tasks before compile can fail when wrapped in Bear so use normal bitbake
  bitbake $package:do_prepare_recipe_sysroot
  if [ ! $? -eq 0 ]; then
    echo "bitbake $package:do_prepare_recipe_sysroot" >&2
    return 1
  fi

  bitbake $package:do_configure
  if [ ! $? -eq 0 ]; then
    echo "bitbake $package:do_configure" >&2
    return 1
  fi

# --use-cc
  bear --cdb "${comp_db}" bitbake $package:do_compile
  if [ ! $? -eq 0 ]; then
    echo "bear --use-cc --cdb '${comp_db}' bitbake $package:do_compile" >&2
    return 1
  fi

  if [ -e "${comp_db}" ]; then
    cp_ycm_template "${dir}" "${comp_db}"
  fi

  bitbake -c clean $package #Clean to make everything compile
  if [ ! $? -eq 0 ]; then
    echo "bitbake -c clean $package" >&2
    return 1
  fi
}

# cp_ycm_template "${dir}" "test"
main "false"
