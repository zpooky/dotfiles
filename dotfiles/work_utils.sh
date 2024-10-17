# internal
is_valid_build_dir() {
  if [ -z "${BUILDDIR}" ]; then
    echo "Must be run from oe-initenv shell">&2
    return 1
  fi

  if [[ ! "$(pwd)" =~ ^${BUILDDIR}.* ]]; then
    echo "ERROR: You are not located under the directory of oe-initenv ('${BUILDDIR}')"
    return 1
  fi

  return 0
}

# Enables "modifying" multiple repos at the same time
# Example:
#   $ devtool_modify audiocontrol ioboxd ...
# Note: using the same command for the normal devtool modify it would check the audiocontrol repo inside a directory called ioboxd
devtool_modify() {
  if ! is_valid_build_dir; then
    return 1
  fi

  local failed=""
  local success=""
  local ret=0

  local proj=( "$@" )
  for cur in "${proj[@]}"; do
    echo "##### devtool modify \"$cur\""
    if devtool modify "${cur}" -w; then
      success="${success} ${cur}"
    else
      ret=$?
      failed="${failed} ${cur}"
    fi
  done

  local msg="modify done"
  if [ -n "${success}" ]; then
    success="success: ${success}"
  fi

  if [ -n "${failed}" ]; then
    failed="failed: ${failed}"
  fi

  if [ -z "${success}" ]; then
    notify-send "${msg}" "${failed}"
  elif [ -z "${failed}" ]; then
    notify-send "${msg}" "${success}"
  else
    notify-send "${msg}" "${success}" "${failed}"
  fi

  return $ret
}

# Executes 'bitbake axis-image-cvp' and just sends a notification in the desktop environment when completed
# Example:
#   $ bitbake_axis-image-cvp
bitbake_axis-image-cvp() {
  if ! is_valid_build_dir; then
    return 1
  fi

  local dist_root="${BUILDDIR}/../.."
  local meta_production="${dist_root}/meta-production"
  if [ -e "${meta_production}" ]; then
    echo "meta-production exists: bitbake_axis-image-production"
    return 2
  fi

  local fimage="${BUILDDIR}/fimage"
  local fimage_before=$(sha256sum "${fimage}")

  local start_date=$(date)
  local start=$(date +%s)
  bitbake axis-image-cvp
  local ret=$?
  if [ ${ret} -eq 0 ]; then
    notify-send "Build [SUCCESS]"
  else
    notify-send "Build [FAILED]"
  fi
  local end=$(date +%s)
  local duration=$(($end-$start))

  local fimage_after=$(sha256sum "${fimage}")

  echo
  echo "# ${fimage}"
  echo "  before: ${fimage_before}"
  echo "   after: ${fimage_after}"
  echo "   start: ${start_date}"
  echo "     end: $(date)"
  if [ ${duration} -gt 60 ]; then
    echo "duration: $((($duration)/60)) minutes"
  else
    echo "duration: ${duration} seconds"
  fi

  if [ -e "${fimage}" ]; then
    local fimage_dir="$(dirname ${fimage})"
    cp "${fimage}" "${fimage_dir}/bak."$(date +"%Y-%m-%d_%H%M")".fimage"
  fi

  return $ret
}

# entr monitor source file in specified repo and runs devtool build automatically when they changes
# Example:
#   $ entr_devtool_build ioboxd
# Note: Manually trigger a rebuild with *space*
entr_devtool_build(){
  if ! is_valid_build_dir; then
    return 1
  fi

  if ! command -v ack; then
    echo "missing ack" 1>&2
    echo "install: 'apt-get install ack-grep'" 1>&2
    return 1
  fi

  if ! command -v entr; then
    echo "missing entr" 1>&2
    echo "install: 'apt-get install entr'" 1>&2
    return 1
  fi

  local project="${1}"
  local l_workspace="${BUILDDIR}/workspace/sources/${project}"

  if [ ! -e "${l_workspace}" ]; then
    echo "missing workspace '${l_workspace}'">&2
    return 1
  fi

  cd "${l_workspace}" || return 1
  ack -f --cpp --fortran --shell --make --cmake --meson --ignore-dir=oe-workdir --ignore-dir=oe-logs --devicetree -r | entr -c ffbuild "${project}"
  cd -
}

# Executes 'repo sync' and updates all "modified" repos in workspace/appends/ to match the new versions fetched by 'repo sync'
# Example:
#   $ bitbake_repo_sync
# Issue bitbake_repo_sync tries to solve:
#  $ devtool_modify psed
#  $ ls workspace/appends/psed_0.0.4.bbappend
#  $ repos sync
#  $ ls meta-axis/recipes-product/psed/psed_0.0.5.bb
#  $ devtool build psed
#  ERROR: No recipes in default available for:
#    .../workspace/appends/psed_0.0.4.bbappend
#
# Alternative:
#   $ devtool modify psed -w
# Note: using the -w will bypass this problems completely
bitbake_repo_sync(){
  if ! is_valid_build_dir; then
    return 1
  fi

  local project_dir="${BUILDDIR}/workspace/appends"
  local meta_axis="${BUILDDIR}/../../meta-axis"
  local meta_axis_bsp="${BUILDDIR}/../../meta-axis-bsp"
  local needle

  if ! repo sync -j10; then
    return $?
  fi

  echo
  for dist in "${project_dir}"/*; do
    local fname="$(basename ${dist})"

    if [[ "${fname}" == *_%.bbappend ]]; then
      echo "'${fname}' SKIPPING"
    elif [[ "${fname}" =~ '^(.+)_.*\.bbappend$' ]]; then
      neddle=""
      local bb_name="${match[1]}"
      # echo "${fname}|${bb_name}"

      local search_dir=""
      if [ "${bb_name}" = "hwconfig" ]; then
        search_dir="${meta_axis_bsp}"
        needle="${bb_name}_"
      elif [ "${bb_name}" = "devicetree" ]; then
        search_dir="${meta_axis_bsp}"
        needle="${bb_name}_"
      elif [ "${bb_name}" = "linux-axis" ]; then
        search_dir="${meta_axis_bsp}"
        if [[ "${fname}" =~ '^(.+_[0-9]+\.[0-9]+\.).*\.bbappend$' ]]; then
          needle="${match[1]}"
        else
          echo "something went wrong"
          return 1
        fi
      else
        search_dir="${meta_axis}"
        needle="${bb_name}_"
      fi
      # echo "find ${search_dir} -name \"${needle}*.bb\""
      local dest_bb=$(find ${search_dir} -name "${needle}*.bb")

      if [ -e "${dest_bb}" ]; then
        local dest_bb_fname="$(basename ${dest_bb})append"

        local src_bbappend="${project_dir}/${fname}"
        local dest_bbappend="${project_dir}/${dest_bb_fname}"
        if [ ! "${fname}" = "${dest_bb_fname}" ]; then
          echo "mv ${src_bbappend} ${dest_bbappend}"
          mv "${src_bbappend}" "${dest_bbappend}"
        else
          echo "'${fname}' UP TO DATE"
        fi
      fi
    fi
  done
}

# Devtool reset one or more recipes using ffbuild to make it faster (why not!).
dtr() {
    echo -n $@ | xargs -d' ' -I_RECIPE -P16 ffbuild -F --reset _RECIPE ||
        ffbuild --reset $@
}

# Quick version of devtool_modify using ffbuild and parallel processing
#
# When in need of modifying more than one recipe at a time
# @params one or more recipe name
dtm() {
    test $# -eq 0 && echo 'Missing recipes to be modified!' >&2

    # Checkout code in large batches (parallel) without falling back to bitbake
    echo -n $@ | xargs -d' ' -I_RECIPE -P16 ffbuild -F --modify _RECIPE || :

    # Now, re-run with serial execution fallback so that devtool takes care of
    # those recipes requiring it
    echo -n $@ | xargs -d' ' -I_RECIPE ffbuild --modify _RECIPE
}

# Show devtool status and, if possible, use ffbuild to speed it up too.
dts() {
    output=$(ffbuild --devstatus 2>&1)
    if echo "$output" | /bin/grep -i 'ffbuild: error' >/dev/null; then
        # Fallback to devtool if ffbuild gives an error
        echo ffbuild returned an error. Falling back to devtool.
        devtool status
    else
        echo "$output" | sed -r '2,$s#devtool\s+/home/.+$#devtool#'
    fi
}

# Print a confirmation dialog before executing a command.
confirm() {
    echo -n 'Are you really sure about that? [y/N] '
    read answer
    answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
    case "${answer}" in
        y|yes)  echo 'Continue.' ;;
        *)      echo 'Abort.'; return 1 ;;
    esac
    # Run the command
    $@
}
# Alias the reboot command, since it happened to me and colleagues to want to
# restart a device (e.g. a camera), but we executed the command on our own
# machine instead because of a lack of focus :P
alias reboot='confirm reboot'

# One function to extract them all archive file types.
extract() {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar|*.tar.xz)
                         tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *.lzo)       lzop -d $1     ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Execute a command without any set proxy environment variable.
# Usage: noproxy <your_cmd>
noproxy() {
    proxy_tmp=$HTTP_PROXY
    proxy_tmp2=$http_proxy
    proxy_tmp3=$https_proxy
    proxy_tmp4=$HTTPS_PROXY

    unset HTTP_PROXY
    unset http_proxy
    unset https_proxy
    unset HTTPS_PROXY

    $@

    export HTTP_PROXY=$proxy_tmp
    export http_proxy=$proxy_tmp2
    export https_proxy=$proxy_tmp3
    export HTTPS_PROXY=$proxy_tmp4
}

