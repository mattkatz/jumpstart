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
# clean up anything we don't need
sudo apt autoremove --assume-yes

