# a simple library for easily outputting colored text to the screen.
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
# YELLOW='\E[0;33m'
YELLOW='\033[0;33m'
BLACK='\033[0;47m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

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
