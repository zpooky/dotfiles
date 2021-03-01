#!/bin/bash

source "$HOME/dotfiles/shared.sh"

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
else
  sudo snap install htop
  sudo snap install node --classic
  sudo snap install ruby --classic

  sudo snap install nvim --classic  --channel=latest/beta
  sudo snap install universal-ctags --classic

  sudo snap install tree 
fi

if [[ "$(uname -a)" =~ Microsoft ]]; then
  echo "Microsoft"
else
  sudo apt-get install gnome-tweak-tool -y
  sudo apt-get install xclip
fi
