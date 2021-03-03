#!/bin/bash

source "$HOME/dotfiles/shared.sh"

function install_languagetool() {
  local wkd
  local cur
  local ltool="LanguageTool-5.2"
  local zip_file="${ltool}.zip"
  local jar="languagetool-commandline.jar"
  local dest_dir="$HOME/bin"
  local link_dest="${dest_dir}/${jar}"
  local link_src="$HOME/bin/${ltool}/${jar}"
  local installed=1
  cur="$(pwd)"


  if [ ! -e "${dest_dir}/${ltool}" ]; then
    wkd="$(mktemp -d)"
    res=$?

    if [ $res -eq 0 ]; then
      if cd "$wkd"; then
        if wget "https://languagetool.org/download/${zip_file}"; then
          if unzip "$zip_file"; then
            if mv "./${ltool}" "${dest_dir}"; then
              rm -f "${link_dest}"
              ln -s "${link_src}" "${link_dest}"
              installed=$?
            fi
          fi
        fi

        cd "${cur}" || cd || return 0
      fi
      echo "${wkd}"
      rm -rf "${wkd}"
    fi
  else
    return 0
  fi

  return $installed
}

sudo apt-get install python3
sudo apt-get install python3-pip
sudo apt-get install npm
sudo apt-get install curl
sudo apt-get install zsh
sudo apt-get install rake
sudo apt-get install ruby-dev
sudo apt-get install tmux
sudo apt-get install silversearcher-ag
sudo apt-get install tig
sudo apt-get install python3-venv

# vim: Konfekt/vim-DetectSpellLang
sudo apt-get install aspell aspell-en aspell-sv

if [[ "$(uname -a)" =~ Microsoft ]]; then
  sudo apt-get install htop
  sudo apt-get install nodejs
  sudo apt-get install ruby

  sudo apt-get install neovim
  sudo apt-get install universal-ctags

  sudo apt-get install tree

  install_languagetool
else
  sudo snap install htop
  sudo snap install node --classic
  sudo snap install ruby --classic

  sudo snap install nvim --classic  --channel=latest/beta
  sudo snap install universal-ctags --classic

  sudo snap install tree

  sudo snap install languagetool
fi

if [[ "$(uname -a)" =~ Microsoft ]]; then
  echo "Microsoft"
else
  sudo apt-get install gnome-tweak-tool -y
  sudo apt-get install xclip
fi
