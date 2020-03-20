#!/bin/zsh -i
echo -e "lets use some colors"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

BASEDIR=$(dirname "$0")
echo -e "$GREEN Running from $BASEDIR $NC"

# make sure to install python2, python3, vim, git, tmux, pipenv, wget, curl
# if none of what we want is specified, we can exit 
# and kick something off for the appropriate package manager
if command -v curl >/dev/null 2>&1
then
	echo -e "${GREEN}curl is installed, tight.${NC}"
else
	echo -e "${RED}curl isn't installed, get that done!${NC}"
  exit 1
fi
if command -v wget >/dev/null 2>&1
then
	echo -e "${GREEN}wget is installed, sweet.${NC}"
else
	echo -e "${RED}whoa, wget isn't installed, get that done!${NC}"
  exit 1
fi
# Set up zsh by cloning oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]
then
	echo -e "${GREEN}oh-my-zsh already exists!${NC}"
else
	echo -e "installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	echo -e "oh-my-zsh should be installed now"
fi

# clone my vim config
if [ -d "$HOME/.vim" ]
then
	echo -e "${GREEN}vim config directory already exists${NC}"
else
	echo -e "Cloning my vim config"
	git clone https://github.com/mattkatz/.vim ~/.vim
	ln -s ~/.vim/.vimrc ~/.vimrc
	echo -e "plugins should install on next launch of vim"
fi

# add our gitignore
if [ -e "$HOME/.gitignore" ]
then
  echo -e "${GREEN}Good, we have a user .gitgnore file${NC}"
else
  echo -e "link our gitignore file in"
  ln -s $BASEDIR/.gitignore ~/.gitignore
fi

echo -e "making sure our gitignore is used by git!"
git config --global core.excludesfile $HOME/.gitignore

if grep -q "gitignore.io" ~/.oh-my-zsh/custom/functions.zsh
then
  echo -e "${GREEN}Oh, nice. There's a gi function defined for automatic gitignore file creation"
  echo -e "gi vim,python >> .gitignore${NC}"
else
  echo -e "set up a gitignore function gi so that we can do project gitignore from cli"
  echo -e "gi vim,python >> .gitignore"
  echo "function gi() { curl -sLw "\n" https://www.gitignore.io/api/\$@ ;}" >> \
    ~/.oh-my-zsh/custom/functions.zsh && source ~/.zshrc
fi

# set up tmux by cloning oh-my-tmux
if command -v tmux >/dev/null 2>&1
then
  echo -e "${GREEN}Whoot, tmux is installed${NC}"
else
  echo -e "${RED}Oh NO, please install tmux. Try:${NC}"
  echo -e "${RED}sudo apt-get install tmux${NC}"
fi
if [ -d "$HOME/.tmux" ]
then
  echo -e "${GREEN}Excellent, oh-my-tmux is already setup${NC}"
else
  echo -e "Installing oh-my-tmux"
  pushd $HOME
  git clone https://github.com/gpakosz/.tmux.git
  ln -s -f .tmux/.tmux.conf
  cp .tmux/.tmux.conf.local .
  echo -e "adding some more options to the local tmux.conf"
  echo -e "set -g mode-mouse on" >> ~/.tmux.conf.local
  echo -e "set -g mouse-resize-pane on" >> ~/.tmux.conf.local
  echo -e "set -g mouse-select-pane on" >> ~/.tmux.conf.local
  echo -e "set -g mouse-select-window on" >> ~/.tmux.conf.local
  echo -e "${GREEN}Installed oh-my-tmux!${NC}"
fi

# install tmux plugin manager
if [ -d ~/.tmux/plugins/tpm ]
then 
  echo -e "${GREEN}Hexcellent, tmux plugin manager is already setup${NC}"
else
  echo -e "Installing tpm"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo -e "# List of plugins" >> ~/tmux.conf.local
  echo -e "set -g @plugin 'tmux-plugins/tpm'" >> ~/.tmux.conf.local
  echo -e "set -g @plugin 'tmux-plugins/tmux-resurrect'" >> ~/.tmux.conf.local
  echo -e "set -g @plugin 'tmux-plugins/tmux-continuum'" >> ~/.tmux.conf.local
  echo -e "# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)" >> ~/.tmux.conf.local
  echo -e "run -b '~/.tmux/plugins/tpm/tpm'" >> ~/.tmux.conf.local
  echo -e "${GREEN}Installed tpm! type ctrl-a I to install your plugins${NC}"
fi



# gotta have some local user binaries
if [ -d "$HOME/.local" ]
then 
  echo -e "${GREEN}.local exists"${NC} 
else
  echo -e "making .local"
  mkdir ~/.local
fi

if [ -d "$HOME/.local/bin" ]
then 
  echo -e "${GREEN}.local/bin exists"${NC} 
else
  echo -e "making .local/bin"
  mkdir ~/.local/bin
fi

# add the .local/bin to the path
if echo -e $PATH | grep -q .local/bin
then
  echo -e "${GREEN}.local/bin is on the path, whew!${NC}"
else
  echo -e "let's add .local/bin to the path"
  echo "path+=~/.local/bin/" >> ~/.oh-my-zsh/custom/paths.zsh
  EXPORTPATH=1
fi

# is the local ruby gem directory on the path?
if echo -e $PATH | grep -q .gem
then
  echo -e "${GREEN}local rubygems is on path!"${NC} 
else
  echo -e "adding local rubygems to the path"
  echo "path+=$(ruby -r rubygems -e 'puts Gem.user_dir')/bin" >> ~/.oh-my-zsh/custom/paths.zsh
  EXPORTPATH=1
fi

if [ -z $EXPORTPATH ]
then
  echo -e "${GREEN}all paths were set. nice one."${NC} 
else
  echo "export path" >> ~/.oh-my-zsh/custom/paths.zsh
  echo "export paths and reload the .zshrc"
  source ~/.oh-my-zsh/custom/paths.zsh
fi


BINDIR=$HOME/.local/bin
# install entr to the .local/bin
if command -v entr >/dev/null 2>&1
then
  echo -e "${GREEN}huzzah, entr is installed${NC}"
else
  echo -e "installing entr locally"
  mkdir  $BASEDIR/entr-source
  wget -qO- "http://www.entrproject.org/code/entr-4.1.tar.gz" | tar xvz -C $BASEDIR/entr-source
  pushd $BASEDIR/entr-source/eradman-entr*
  ./configure
  make test
  PREFIX=$HOME/.local make install
  popd
  echo -e "cleaning up entr-source"
  rm -rf $BASEDIR/entr-source
fi

# install git-extras
if command -v git-extras >/dev/null 2>&1
then
  echo -e "${GREEN}woop, git extras is installed${NC}"
else
  echo -e "installing git-extras locally"
  GES=$BASEDIR/git-extras-source
  mkdir $GES
  pushd $GES
  git clone https://github.com/tj/git-extras.git
  pushd git-extras
  git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
  make install PREFIX=$HOME/.local
  popd
  popd
  echo -e "cleaning up git-extras source"
  rm -rf $GES
fi

# install z the jump around command
# if z is installed, this should be an alias to _z
if type z >/dev/null 2>&1
then
  echo -e "${GREEN}Z is installed, jump around${NC}"
else
  echo -e "installing z to jump around"
  git clone https://github.com/rupa/z
  cp z/z.sh $BINDIR/.
  echo ". ~/.local/bin/z.sh" > ~/.oh-my-zsh/custom/z.zsh
  rm -rf z
fi

# do we have VIM set as editor?
if [ -z "$EDITOR" ] 
then
  echo "Need to set vim as the editor"
  echo "export EDITOR='vim'" >> ~/.oh-my-zsh/custom/settings.zsh
  source ~/.oh-my-zsh/custom/settings.zsh
else
  echo -e "${GREEN}ready to vim for all files${NC}"
fi


# install pycharm to the bin
if command -v pycharm >/dev/null 2>&1
then
  echo -e "${GREEN}Noice, pycharm is installed${NC}"
else
  echo -e "installing pycharm"
  wget https://download.jetbrains.com/python/pycharm-community-2018.2.4.tar.gz
  tar -xzf pycharm-community-2018.2.4.tar.gz --directory ~/.local/bin/
  rm pycharm-community-2018.2.4.tar.gz
  ln ~/.local/bin/pycharm-community-2018.2.4/bin/pycharm.sh ~/.local/bin/pycharm
fi

# install Rust
if command -v cargo >/dev/null 2>&1
then
  echo -e "${GREEN}This system is rusty${NC}"
else
  echo -e "Installing rust"
  curl https://sh.rustup.rs -sSf | sh
  source $HOME/.cargo/env
fi

# install bat, the cat with wings
if type bat >/dev/null 2>&1
then
  echo -e "${GREEN}🦇BAT EVERYWHERE🦇${NC}"
else
  echo -e "instaling bat"
  cargo install bat
fi

# TODO: install fzf and use that as the fuzzy finder in vim instead of ctrlp
# TODO: replace syntastic with ALE 

