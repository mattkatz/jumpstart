#!/usr/bin/sh
# make sure to install python2, python3, vim, git, tmux, pipenv, wget, curl
# Set up zsh by cloning oh-my-zsh
# set up tmux by cloning oh-my-tmux
# clone my vim config
if [ -d "~/.vim" ]
then
	echo "Cloning my vim config"
else
	echo "vim config directory already exists"
fi
# install my vim plugins
