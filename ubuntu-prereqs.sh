#!/bin/bash

# this is to install my standard prereqs for ubuntu
echo -e "lets use some colors"
. colors.sh
yellow "so very colorful"


# make sure to install python2, python3, vim, git, tmux, wget, curl
green "Install python3, vim, git, tmux, wget, curl"
sudo apt-get install --assume-yes python3 vim git tmux wget curl ruby
green "installing 🏄ag and ripgrep!"
sudo apt-get install --assume-yes silversearcher-ag ripgrep
green "install docker prerequisites"
sudo apt-get install --assume-yes \
  ca-certificates \
  gnupg \
  lsb-release

green "homebrew prerequisites"
sudo apt-get install --assume-yes build-essential procps file 

green "installing docker"
if command -v docker >/dev/null 2>&1
then
  green "docker already installed"
else
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  rm get-docker.sh
fi

green "simple screen recorder"
sudo apt-get install --assume-yes simplescreenrecorder



green "clean up anything we don't need"
sudo apt autoremove --assume-yes

