#!/usr/bin/sh
echo "lets use some colors"
alias echo='echo -e'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

BASEDIR=$(dirname "$0")
echo "${GREEN}Running from $BASEDIR${NC}"

# make sure to install python2, python3, vim, git, tmux, pipenv, wget, curl
if command -v curl >/dev/null 2>&1
then
	echo "${GREEN}curl is installed, tight.${NC}"
else
	echo "${RED}curl isn't installed, get that done!${NC}"
  exit 1
fi
if command -v wget >/dev/null 2>&1
then
	echo "${GREEN}wget is installed, sweet.${NC}"
else
	echo "${RED}whoa, wget isn't installed, get that done!${NC}"
  exit 1
fi
# Set up zsh by cloning oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]
then
	echo "${GREEN}oh-my-zsh already exists!${NC}"
else
	echo "installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	echo "oh-my-zsh should be installed now"
fi
# clone my vim config
if [ -d "$HOME/.vim" ]
then
	echo "${GREEN}vim config directory already exists${NC}"
else
	echo "Cloning my vim config"
	git clone https://github.com/mattkatz/.vim
	ln -s ~/.vim/.vimrc ~/.vimrc
	echo "plugins should install on next launch of vim"
fi

# add our gitignore
if [ -e "$HOME/.gitignore" ]
then
  echo "${GREEN}Good, we have a user .gitgnore file${NC}"
else
  echo "link our gitignore file in"
  ln -s $BASEDIR/.gitignore ~/.gitignore
fi

echo "making sure our gitignore is used by git!"
git config --global core.excludesfile $HOME/.gitignore

# set up tmux by cloning oh-my-tmux
if command -v tmux >/dev/null 2>&1
then
  echo "${GREEN}Whoot, tmux is installed${NC}"
else
  echo "${RED}Oh NO, please install tmux. Try:${NC}"
  echo "${RED}sudo apt-get install tmux${NC}"
fi
if [ -d "$HOME/.tmux" ]
then
  echo "${GREEN}Excellent, oh-my-tmux is already setup${NC}"
else
  echo "Installing oh-my-tmux"
  pushd $HOME
  git clone https://github.com/gpakosz/.tmux.git
  ln -s -f .tmux/.tmux.conf
  cp .tmux/.tmux.conf.local .
  echo "${GREEN}Installed oh-my-tmux!${NC}"
fi


# gotta have some local user binaries
if [ -d "$HOME/.local" ]
then 
  echo "${GREEN}.local exists"${NC} 
else
  echo "making .local"
  mkdir ~/.local
fi

if [ -d "$HOME/.local/bin" ]
then 
  echo "${GREEN}.local/bin exists"${NC} 
else
  echo "making .local/bin"
  mkdir ~/.local/bin
fi

# add the .local/bin to the path
if echo $PATH | grep -q .local/bin
then
  echo "${GREEN}.local/bin is on the path, whew!${NC}"
else
  echo "let's add .local/bin to the path"
  ln -s $BASEDIR/.pathrc $HOME/.oh-my-zsh/custom/.pathrc
fi


BINDIR=$HOME/.local/bin
# install entr to the .local/bin
if command -v entr >/dev/null 2>&1
then
  echo "${GREEN}huzzah, entr is installed${NC}"
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


