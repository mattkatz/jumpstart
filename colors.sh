# a simple library for easily outputting colored text to the screen.
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\E[0;33m'
BLACK='\E[0;47m'
BLUE='\E[0;34m'
MAGENTA='\E[0;35m'
CYAN='\E[0;36m'
WHITE='\E[0;37m'

color(){
  if (( $# < 2 ))
  then
    echo "need to call color() with a color and text";
  else
    echo -e "${2}$1${NC}";
  fi
}

green(){
    color "$1" "$GREEN"
}

red(){
    color "$1" "$RED"
}

yellow(){
    color "$1" "$YELLOW"
}
black(){
    color "$1" "$BLACK"
}
blue(){
    color "$1" "$BLUE"
}
magenta(){
    color "$1" "$MAGENTA"
}
cyan(){
    color "$1" "$CYAN"
}
white(){
    color "$1" "$WHITE"
}
