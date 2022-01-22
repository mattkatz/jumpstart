#!/bin/zsh -i
echo -e "lets use some colors"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

color(){
  if (( $# < 2 ))
  then
    echo "need to call color() with a color and text";
  else
    echo -e "${2}$1${NC}";
  fi
}
green(){
    color $1 $GREEN
}
red (){
    color $1 $RED
}

BASEDIR=${0:a:h}
green "running from $BASEDIR"


# make sure to install  python3, vim, git, tmux, pipenv, wget, curl
# if none of what we want is specified, we can exit 
# and kick something off for the appropriate package manager
if command -v curl >/dev/null 2>&1
then
  green "curl is installed, tight."
else
  red "curl isn't installed, get that done!"
  exit 1
fi


#What OS are we on?
if [[ "$OSTYPE" == "linux-gnu"* ]]
then
  # we'll need to do some apt-get installs and such, eh?
  green "looks like we are on linux, time to apt install"
elif [[ "$OSTYPE" == "darwin"* ]]
then
  # if on OSX we'll need to install homebrew
  if command -v brew >/dev/null 2>&1
  then
    green "🍻 homebrew is installed"
  else
    red "time to install homebrew 🍺"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
fi

if command -v wget >/dev/null 2>&1
then
  green "wget is installed, sweet."
else
  if [[ "$OSTYPE" == "darwin"* ]]
  then
    red "need to install wget, let's brew that"
    brew install wget
  else
    red "whoa, wget isn't installed, get that done!"
    exit 1
  fi
fi
# Set up zsh by cloning oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]
then
  green "oh-my-zsh already exists!"
else
  echo -e "installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  echo -e "oh-my-zsh should be installed now"
fi

# clone my vim config
if [ -d "$HOME/.vim" ]
then
  green "vim config directory already exists"
else
  echo -e "Cloning my vim config"
  git clone https://github.com/mattkatz/.vim ~/.vim
  ln -s ~/.vim/.vimrc ~/.vimrc
  echo -e "plugins should install on next launch of vim"
fi

# add our gitignore
if [ -e "$HOME/.gitignore" ]
then
  green "Good, we have a user .gitgnore file"
else
  red "need to link our gitignore file in"
  ln -s $BASEDIR/.gitignore ~/.gitignore
fi

green  "making sure our gitignore is used by git!"
git config --global core.excludesfile $HOME/.gitignore

if grep -q "gitignore.io" ~/.oh-my-zsh/custom/functions.zsh
then
  green "Oh, nice. There's a gi function defined for automatic gitignore file creation"
  green "gi vim,python >> .gitignore"
else
  echo -e "set up a gitignore function gi so that we can do project gitignore from cli"
  echo -e "gi vim,python >> .gitignore"
  echo "function gi() { curl -sLw "\n" https://www.gitignore.io/api/\$@ ;}" >> \
    ~/.oh-my-zsh/custom/functions.zsh && source ~/.zshrc
fi

# set up tmux by cloning oh-my-tmux
if command -v tmux >/dev/null 2>&1
then
  green "Whoot, tmux is installed"
else
  if [[ "$OSTYPE" == "darwin"* ]]
  then
    red "No tmux?! lets brew that up"
    brew install tmux
    red "run jumpstart till it all goes green!"
  else
    red "Oh NO, please install tmux. Try:"
    red "sudo apt-get install tmux"
  fi
fi
if [ -d "$HOME/.tmux" ]
then
  green "Excellent, oh-my-tmux is already setup"
else
  echo -e "Installing oh-my-tmux"
  pushd $HOME
  git clone https://github.com/gpakosz/.tmux.git
  ln -s -f .tmux/.tmux.conf
  cp .tmux/.tmux.conf.local .
  echo -e "adding some more options to the local tmux.conf"
  echo -e "set -g mouse on" >> ~/.tmux.conf.local
  echo -e "set-window-option -g mode-keys vi" >> ~/.tmux.conf.local
  echo -e "bind-key -T copy-mode-vi v send -X begin-selection" >> ~/.tmux.conf.local
  echo -e "bind-key -T copy-mode-vi V send -X select-line" >> ~/.tmux.conf.local
  echo -e "bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'" >> ~/.tmux.conf.local
  "

  green "Installed oh-my-tmux!"
fi

# install tmux plugin manager
if [ -d ~/.tmux/plugins/tpm ]
then 
  green "Hexcellent, tmux plugin manager is already setup"
else
  echo -e "Installing tpm"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  echo -e "# List of plugins" >> ~/tmux.conf.local
  echo -e "set -g @plugin 'tmux-plugins/tpm'" >> ~/.tmux.conf.local
  echo -e "set -g @plugin 'tmux-plugins/tmux-resurrect'" >> ~/.tmux.conf.local
  echo -e "set -g @plugin 'tmux-plugins/tmux-continuum'" >> ~/.tmux.conf.local
  echo -e "set -g @continuum-restore 'on'" >> ~/.tmux.conf.local
  echo -e "set -g @continuum-save-interval '10'" >> ~/.tmux.conf.local
  echo -e "set -g @continuum-boot 'on'" >> ~/.tmux.conf.local
  echo -e "# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)" >> ~/.tmux.conf.local
  echo -e "run -b '~/.tmux/plugins/tpm/tpm'" >> ~/.tmux.conf.local
  green "Installed tpm! type ctrl-a I to install your plugins"
fi



# gotta have some local user binaries
if [ -d "$HOME/.local" ]
then 
  green ".local exists"
else
  echo -e "making .local"
  mkdir ~/.local
fi

if [ -d "$HOME/.local/bin" ]
then 
  green ".local/bin exists"
else
  echo -e "making .local/bin"
  mkdir ~/.local/bin
fi

# add the .local/bin to the path
if echo -e $PATH | grep -q ~/.local/bin
then
  green ".local/bin is on the path, whew!"
else
  red "let's add .local/bin to the path"
  echo "path+=~/.local/bin/" >> ~/.oh-my-zsh/custom/paths.zsh
  EXPORTPATH=1
fi

# RUBY STUFF
# is the local ruby gem directory on the path?
if echo -e $PATH | grep -q .local/share/gem
then
  green "local rubygems is on path!"
else
  red "adding local rubygems to the path"
  echo "path+=$(ruby -r rubygems -e 'puts Gem.user_dir')/bin" >> ~/.oh-my-zsh/custom/paths.zsh
  EXPORTPATH=1
fi
# the default way to install gems is to root with SUDO! That's not secure
if echo -e $GEM_HOME | grep -q $HOME;
then
  green "ruby gems home is safely set to the user directory"
else
  echo -e "setting up safe ruby gem user installation"
  echo "GEM_HOME=$(ruby -r rubygems -e 'puts Gem.user_dir')" >> ~/.oh-my-zsh/custom/ruby.zsh
fi


PY3USERBASE="$( python3 -m site --user-base )"
if echo $PATH | grep -q $PY3USERBASE
then
  green "🐍🐍🐍 py3 user bin is in path"
else
  red "adding the py3 bin paths"
  echo "path+=$PY3USERBASE/bin" >> ~/.oh-my-zsh/custom/paths.zsh
fi


if [ -z $EXPORTPATH ]
then
  green "all paths were set. nice one."
else
  echo "export path" >> ~/.oh-my-zsh/custom/paths.zsh
  echo "export paths and reload the .zshrc"
  source ~/.oh-my-zsh/custom/paths.zsh
fi


BINDIR=$HOME/.local/bin
# install entr to the .local/bin
if command -v entr >/dev/null 2>&1
then
  green "huzzah, entr is installed"
else
  red "installing entr locally"
  mkdir  $BASEDIR/entr-source
  wget -qO- "http://eradman.com/entrproject/code/entr-4.6.tar.gz" | tar xvz -C $BASEDIR/entr-source
  pushd $BASEDIR/entr-source/entr*
  ./configure
  make test
  PREFIX=~/.local make install
  popd
  echo -e "cleaning up entr-source"
  rm -rf $BASEDIR/entr-source
fi

# install git-extras
if command -v git-extras >/dev/null 2>&1
then
  green "woop, git extras is installed"
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
  green "Z is installed, jump around"
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
  green "ready to vim for all files"
fi


# install pycharm to the bin
if command -v pycharm >/dev/null 2>&1
then
  green "Noice, pycharm is installed"
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
  green "This system is rusty"
else
  echo -e "Installing rust"
  curl https://sh.rustup.rs -sSf | sh
fi

# add the .cargo/bin to the path
if echo -e $PATH | grep -q ~/.cargo/bin
then
  green ".cargo/bin is on the path, whew!"
else
  red "let's add .cargo/bin to the path"
  echo "path+=~/.cargo/bin/" >> ~/.oh-my-zsh/custom/paths.zsh
  red "rerun jumpstart till everything is green"
  red "and try launching a new zsh"
  exit 1;
fi

# install bat, the cat with wings
if type bat >/dev/null 2>&1
then
  green "🦇BAT EVERYWHERE🦇"
else
  echo -e "instaling bat"
  cargo install bat
fi

# check to see if we have node and npm installed
if npm -v >/dev/null 2>&1
then
  green "Node and npm are installed!"
  green "Let's make them safe"
  # set up local non sudo npm package installs
  mkdir -p $HOME/.npm-packages
  NPMZSH=~/.oh-my-zsh/custom/npm.zsh
  echo "#THIS FILE IS RECREATED EVERY TIME JUMPSTART GETS RUN #" > $NPMZSH
  echo NPM_PACKAGES="$HOME/.npm-packages" >> $NPMZSH
  echo NODE_PATH=\"\$NPM_PACKAGES/lib/node_modules:\$NODE_PATH\" >> $NPMZSH
  green "created npm.zsh"
  if grep $NPM_PACKAGES ~/.npmrc >/dev/null 2>&1
  then
    green "NPM_PACKAGES is in your .npmrc!"
  else
    red "Adding NPM_PACKAGES to your ~/.npmrc"
    echo prefix=$HOME/.npm-packages >> ~/.npmrc
  fi
  if grep $NPM_PACKAGES ~/.oh-my-zsh/custom/paths.zsh >/dev/null 2>&1
  then
    green "NPM_PACKAGES/bin is in your paths!"
  else
    red "Adding NPM_PACKAGES/bin to your paths"
    echo path+=$NPM_PACKAGES/bin >> ~/.oh-my-zsh/custom/paths.zsh
  fi
else
  red "need to install nodejs and npm"
  if [[ "$OSTYPE" == "darwin"* ]]
  then
    brew install nodejs
    brew install npm
    red "rerun jumpstart till it all turns green!"
  else
    red "sudo apt install nodejs; sudo apt install npm"
  fi
fi


# TODO: install fzf and use that as the fuzzy finder in vim instead of ctrlp
# TODO: replace syntastic with ALE 
if command -v gh >/dev/null 2>&1
then
  green "github cli is installed!"
else
  echo -e "Installing the github cli gh"
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install gh
  echo -e "time to authenticate"
  gh auth login
fi
if pip3 freeze | grep gitim >/dev/null 2>&1
then
  green "gitim module is installed"
else
  echo -e "installing gitim!"
  pip3 install --user git+https://github.com/muhasturk/gitim@master#egg=gitim
fi

# poetry seems to be worth more investment than pipenv
if command -v poetry >/dev/null 2>&1
then
  green "؎we have poetry in our system؎"
else
  echo -e "Installing Poetry"
  curl -sSL https://install.python-poetry.org | python3 -
fi

# we like kitty
if command -v kitty >/dev/null 2>&1
then
  green "Meow! 😸 kitty is installed and purring!"
else
  echo "installing kitty"
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
fi


# let's get theming
if command -v themer >/dev/null 2>&1
then 
  green "🎨themed up!🎨"
else
  echo -e "🎨using themer for sweet colors🎨"
  # npm install themer
  npx \
    -p themer \
    -p @themerdev/colors-night-sky \
    -p @themerdev/vim \
    -p @themerdev/wallpaper-burst \
    -p @themerdev/kitty \
    -p @themerdev/firefox-color \
    -p @themerdev/chrome \
    -p @themerdev/terminator \
    themer \
    -c @themerdev/colors-night-sky \
    -t @themerdev/vim \
    -t @themerdev/wallpaper-burst \
    -t @themerdev/kitty \
    -t @themerdev/firefox-color \
    -t @themerdev/chrome \
    -t @themerdev/terminator \
    -o ~/.themerdev
  echo -e "Now follow instrux in ~/.themerdev/README.md"
fi

THEMER_VIM_TARGET="$HOME/.vim/colors/ThemerVim.vim"
echo -e "$THEMER_VIM_TARGET"
if [ -L "$THEMER_VIM_TARGET" ]
then
  green "🎨Looks like Vim has the themer colors🎨"
else
  echo -e "🎨Installing Themer vim colors🎨"
  # ln -s ~/.themerdev/vim/ThemerVim.vim ${THEMER_VIM_TARGET}
  ln -s ~/.themerdev/vim/ThemerVim.vim ${THEMER_VIM_TARGET}
  echo -e "my .vimrc has a try catch to load themervim if it exists"
fi

KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"
if grep -q "themerdev" $KITTY_CONFIG
then
  green "🎨😸 Kitty is themed🎨😸"
else
  echo -e "including the themer kitty theme🎨😸"
  echo 'include ${HOME}/.themerdev/kitty/themer-dark.conf' >> $KITTY_CONFIG
fi

gsettings set org.gnome.desktop.background picture-uri file://${HOME}/.themerdev/wallpaper-burst/themer-wallpaper-burst-dark-2880x1800.png

if grep -q "startup_session" $KITTY_CONFIG
then
  green "Rockin. We've got a startup_session configured for kitty"
else
  echo -e "setting up a startup session for kitty to start with tmux"
  echo "cd ~\nlaunch tmux" > "$HOME/.config/kitty/tmux.session"
  echo 'startup_session ${HOME}/.config/kitty/tmux.session' >> $KITTY_CONFIG
fi
