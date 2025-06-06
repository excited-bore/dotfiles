#!/bin/bash

[[ $0 != $BASH_SOURCE ]] && SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )" || SCRIPT_DIR="$( cd "$( dirname "$-1" )" && pwd )"

# https://stackoverflow.com/questions/5412761/using-colors-with-printf
# Execute (during printf) for colored prompt
# printf  "${blue}This text is blue${white}\n"

# https://unix.stackexchange.com/questions/139231/keep-aliases-when-i-use-sudo-bash
if type sudo &> /dev/null; then
    alias sudo='sudo '
fi
if type wget &> /dev/null; then
    alias wget='wget --https-only '
fi


# https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash

function version-higher () {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0})); then
            return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 1
        fi
    done
    return 0
}


function compare-tput-escape_color(){
    for (( ansi=0; ansi <= 120; ansi++)); do
        printf "$ansi $(tput setaf $ansi) tput foreground $(tput sgr0) $(tput setab $ansi) tput background $(tput sgr0)"; echo -e " \033[$ansi;mEscape\033[0m"
    done | $PAGER
    unset ansi
}

red=$(tput sgr0 && tput setaf 1)
red1=$(tput sgr0 && tput setaf 9)
orange=$(tput sgr0 && tput setaf 166)
green=$(tput sgr0 && tput setaf 2)
green1=$(tput sgr0 && tput setaf 10)
yellow=$(tput sgr0 && tput setaf 3)
yellow1=$(tput sgr0 && tput setaf 11)
blue=$(tput sgr0 && tput setaf 4)
blue1=$(tput sgr0 && tput setaf 12)
magenta=$(tput sgr0 && tput setaf 5)
magenta1=$(tput sgr0 && tput setaf 13)
cyan=$(tput sgr0 && tput setaf 6)
cyan1=$(tput sgr0 && tput setaf 14)
white=$(tput sgr0 && tput setaf 7)
white1=$(tput sgr0 && tput setaf 15)
black=$(tput sgr0 && tput setaf 16)
grey=$(tput sgr0 && tput setaf 8)

RED=$(tput setaf 1 && tput bold)
RED1=$(tput setaf 9 && tput bold)
ORANGE=$(tput setaf 166 && tput bold)
GREEN=$(tput setaf 2 && tput bold)
GREEN1=$(tput setaf 10 && tput bold)
YELLOW=$(tput setaf 3 && tput bold)
YELLOW1=$(tput setaf 11 && tput bold)
BLUE=$(tput setaf 4 && tput bold)
BLUE1=$(tput setaf 12 && tput bold)
MAGENTA=$(tput setaf 5 && tput bold)
MAGENTA1=$(tput setaf 13 && tput bold)
CYAN=$(tput setaf 6 && tput bold)
CYAN1=$(tput setaf 14 && tput bold)
WHITE=$(tput setaf 7 && tput bold)
WHITE1=$(tput setaf 15 && tput bold)
BLACK=$(tput setaf 16 && tput bold)
GREY=$(tput setaf 8 && tput bold)


bold=$(tput bold)
underline_on=$(tput smul)
underline_off=$(tput rmul)
standout_on=$(tput smso)
standout_off=$(tput rmso)
half_bright=$(tput dim)
reverse_color=$(tput rev)

# Reset
normal=$(tput sgr0)

# Broken !! (Or im dumb?)
blink=$(tput blink)
underline=$(tput ul)
italic=$(tput it)

# ...
# https://ss64.com/bash/tput.html

# Arguments: Completions(string with space entries, AWK works too),return value(-a password prompt, -c complete filenames, -p prompt flag, -Q prompt colour, -b break-chars (when does a string break for autocomp), -e change char given for multiple autocompletions)
# 'man rlwrap' to see all unimplemented options

if ! type reade &> /dev/null ; then
    if test -f $SCRIPT_DIR/../rlwrap-scripts/reade; then
        . $SCRIPT_DIR/../rlwrap-scripts/reade 1> /dev/null
    elif test -f $SCRIPT_DIR/01-reade.sh; then
	. $SCRIPT_DIR/01-reade.sh 1> /dev/null
    else
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/reade) &> /dev/null 
    fi
fi

if ! type readyn &> /dev/null; then
    if test -f $SCRIPT_DIR/../rlwrap-scripts/readyn; then
        . $SCRIPT_DIR/../rlwrap-scripts/readyn 1> /dev/null
    elif test -f $SCRIPT_DIR/02-readyn.sh; then
        . $SCRIPT_DIR/02-readyn.sh 1> /dev/null
    else
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/readyn) &> /dev/null
     fi
fi

if ! type yes-edit-no &> /dev/null; then
    if test -f $SCRIPT_DIR/../rlwrap-scripts/yes-edit-no; then
        . $SCRIPT_DIR/../rlwrap-scripts/yes-edit-no 1> /dev/null
    elif test -f $SCRIPT_DIR/03-yes-edit-no.sh; then
        . $SCRIPT_DIR/03-yes-edit-no.sh 1> /dev/null
    else
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/yes-edit-no) &> /dev/null 
    fi
fi
