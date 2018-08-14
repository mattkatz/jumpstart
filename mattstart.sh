#!/usr/bin/sh
# make sure to install python2, python3, vim, git, tmux, pipenv, wget, curl
# Set up zsh by cloning oh-my-zsh
# set up tmux by cloning oh-my-tmux
# clone my vim config
if [ -d ".vim" ]
then
	echo "vim config directory already exists"
else
	echo "Cloning my vim config"
	git clone https://github.com/mattkatz/.vim
	ln -s ~/.vim/.vimrc ~/.vimrc
	echo "plugins should install on next launch of vim"
fi
# install my vim plugins
