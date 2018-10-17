#!/bin/bash

# this is to install my standard prereqs for ubuntu
echo -e "lets use some colors"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

BASEDIR=$(dirname "$0")
echo -e "$GREEN Running from $BASEDIR $NC"

# make sure to install python2, python3, vim, git, tmux, wget, curl
sudo apt-get install --assume-yes python python3 vim git tmux wget curl ruby
# clean up anything we don't need
sudo apt autoremove --assume-yes

