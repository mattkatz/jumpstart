#!/usr/bin/sh
# make sure to install python2, python3, vim, git, tmux, pipenv, wget, curl
if command -v curl >/dev/null 2>&1
then
	echo "curl is installed, tight."
else
	echo "curl isn't installed, get that done!"
fi
if command -v wget >/dev/null 2>&1
then
	echo "wget is installed, sweet."
else
	echo "whoa, wget isn't installed, get that done!"
fi
# Set up zsh by cloning oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]
then
	echo "oh-my-zsh already exists!"
else
	echo "installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	echo "oh-my-zsh should be installed now"
fi
# set up tmux by cloning oh-my-tmux
# clone my vim config
if [ -d "$HOME/.vim" ]
then
	echo "vim config directory already exists"
else
	echo "Cloning my vim config"
	git clone https://github.com/mattkatz/.vim
	ln -s ~/.vim/.vimrc ~/.vimrc
	echo "plugins should install on next launch of vim"
fi
# gotta have some local user binaries
# add the .local/bin to the path
# install pycharm to the .local/bin
# install entr to the .local/bin


