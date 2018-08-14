#!/usr/bin/sh

BASEDIR=$(dirname "$0")
echo "Running from $BASEDIR"
# make sure to install python2, python3, vim, git, tmux, pipenv, wget, curl
if command -v curl >/dev/null 2>&1
then
	echo "curl is installed, tight."
else
	echo "curl isn't installed, get that done!"
  exit 1
fi
if command -v wget >/dev/null 2>&1
then
	echo "wget is installed, sweet."
else
	echo "whoa, wget isn't installed, get that done!"
  exit 1
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

# add our gitignore
if [ -e "$HOME/.gitignore" ]
then
  echo "Good, we have a user .gitgnore file"
else
  echo "link our gitignore file in"
  ln -s $BASEDIR/.gitignore ~/.gitignore
fi

echo "make sure our gitignore is used by git!"
git config --global core.excludesfile $HOME/.gitignore

# set up tmux by cloning oh-my-tmux
if command -v tmux >/dev/null 2>&1
then
  echo "Whoot, tmux is installed"
else
  echo "Oh NO, please install tmux. Try:"
  echo "sudo apt-get install tmux"
fi


# gotta have some local user binaries
if [ -d "$HOME/.local" ]
then 
  echo ".local exists" 
else
  echo "making .local"
  mkdir ~/.local
fi

if [ -d "$HOME/.local/bin" ]
then 
  echo ".local/bin exists" 
else
  echo "making .local/bin"
  mkdir ~/.local/bin
fi

# add the .local/bin to the path
if echo $PATH | grep -q .local/bin
then
  echo ".local/bin is on the path, whew!"
else
  echo "let's add .local/bin to the path"
  ln -s $BASEDIR/.pathrc $HOME/.oh-my-zsh/custom/.pathrc
fi


BINDIR=$HOME/.local/bin
# install entr to the .local/bin
if command -v entr >/dev/null 2>&1
then
  echo "huzzah, entr is installed"
else
  echo "installing entr locally"
  mkdir  $BASEDIR/entr-source
  wget -qO- "http://www.entrproject.org/code/entr-4.1.tar.gz" | tar xvz -C $BASEDIR/entr-source
  pushd $BASEDIR/entr-source/eradman-entr*
  ./configure
  make test
  PREFIX=$HOME/.local make install
  popd
  echo "cleaning up entr-source"
  rm -rf $BASEDIR/entr-source
fi


# install pycharm to the .local/bin


