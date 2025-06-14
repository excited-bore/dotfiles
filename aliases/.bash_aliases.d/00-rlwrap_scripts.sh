SYSTEM_UPDATED='TRUE'
READE_NOSTYLE='filecomp-only'

#! type wget &> /dev/null && command -v brew &> /dev/null &&
#    brew install wget 


# https://stackoverflow.com/questions/5412761/using-colors-with-printf
# Execute (during printf) for colored prompt
# printf  "${blue}This text is blue${white}\n"

red=$(tput sgr0 && tput setaf 1)
red1=$(tput sgr0 && tput setaf 9)
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

if ! type reade &>/dev/null; then
    if test -f rlwrap-scripts/reade; then
        . ./rlwrap-scripts/reade 1>/dev/null
    else
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/reade) &>/dev/null
    fi
fi

if ! type readyn &>/dev/null; then
    if test -f rlwrap-scripts/readyn; then
        . ./rlwrap-scripts/readyn 1>/dev/null
    else
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/readyn) &>/dev/null
    fi
fi

if ! type yes-edit-no &>/dev/null; then
    if test -f rlwrap-scripts/yes-edit-no; then
        . ./rlwrap-scripts/yes-edit-no 1>/dev/null
    else
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/yes-edit-no) &>/dev/null
    fi
fi

if ! test -f checks/check_system.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)
    fi
else
    . ./checks/check_system.sh
fi

# printf "${green} Will now start with updating system ${normal}\n"

if ! type update-system &>/dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi


if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if [[ "$updatesysm" == "y" ]]; then
        update-system-yes
    fi
    export SYSTEM_UPDATED="TRUE"
fi


alias get-script-dir='cd "$( dirname "$-1" )" && pwd'

([[ "$(type unalias)" =~ 'aliased' ]] || [[ "$(type unalias)" =~ 'function' ]]) && 
    alias unalias="builtin unalias"

# Make sure cp copies forceably (without asking confirmation when overwriting) and verbosely

if (hash xcp &> /dev/null || hash cpg &> /dev/null) && ! ([[ "$(type cp)" =~ "'cpg -fgv'" ]] || [[ "$(type cp)" =~ "'xcp'" ]]); then
    if hash cpg &> /dev/null; then
        echo "Since you have cpg installed, this next $(tput setaf 1)sudo$(tput sgr0) will check whether it can be used for the script (if it's sudo executable, it is)"
        sudo bash -c "hash cpg" &&
            alias cp='cpg -fgv' ||
            alias cp='cp -fv'
    elif hash xcp &> /dev/null; then
        echo "Since you have xcp installed, this next $(tput setaf 1)sudo$(tput sgr0) will check whether it can be used for the script (if it's sudo executable, it is)"
        sudo bash -c "hash xcp &> /dev/null" &&
            alias cp='xcp' ||
            alias cp='cp -fv'
    fi
elif ! (hash xcp &> /dev/null || hash cpg &> /dev/null); then
    alias cp='cp -fv'
fi

# Make sure mv moves forceably (without asking confirmation when overwriting) and verbosely
[[ "$(type mv)" =~ 'aliased' ]] && 
    command unalias mv 
alias mv='mv -fv'

# Make sure rm removes forceably, recursively and verbosely 
[[ "$(type rm)" =~ 'aliased' ]] &&
    command unalias rm 
alias rm='rm -rfv'

# Make sure sudo isn't aliased to something weird
command -v sudo &>/dev/null && [[ "$(type sudo)" =~ 'aliased' ]] &&
    command unalias sudo
# Keep aliases when using sudo
alias sudo="sudo "

# Wget only uses https - encrypted http
command -v wget &>/dev/null && [[ "$(type wget)" =~ 'aliased' ]] &&
    command unalias wget 
alias wget='wget --https-only'

alias wget-aria='wget'
alias wget-aria-quiet='wget -q'
alias wget-aria-dir='wget -P'
alias wget-aria-name='wget -O'

alias curl="curl -fsSL --proto '=https' --tlsv1.2"

if ! hash curl &> /dev/null; then
    alias wget-curl='wget -qO-'
else
    alias wget-curl='curl'
fi

if hash aria2c &>/dev/null; then 
    if test -z "$WGET_ARIA"; then
        builtin unalias wget-aria 
        function wget-aria(){
            readyn -p "Use 'aria2c' in favour of 'wget' for faster downloads?" wget_ar
            if [[ $wget_ar == 'y' ]]; then
                export WGET_ARIA=1 
                alias wget-aria='aria2c'
                alias wget-aria-quiet='aria2c -q'
                alias wget-aria-dir='aria2c -d'
                alias wget-aria-name='aria2c -o'
                local frst="$1"
                [[ "$frst" == "-P" ]] && frst="-d"  
                [[ "$frst" == "-O" ]] && frst="-o"  
                aria2c $frst ${@:2}
            else
                wget $@ 
            fi
            unset wget_ar
        } 
        alias wget-aria-quiet="wget-aria -q" 
        alias wget-aria-dir="wget-aria -P" 
        alias wget-aria-name="wget-aria -O" 
    else
        alias wget-aria='aria2c'
        alias wget-aria-quiet='aria2c -q'
        alias wget-aria-dir='aria2c -d'
        alias wget-aria-name='aria2c -o'
    fi
fi


# Less does raw control chars, use color and linenumbers, no sounds/bell and doesn't trigger your epilepsy
alias less='less -R --use-color --LINE-NUMBERS --quit-if-one-screen -Q --no-vbell'
test -z "$PAGER" && PAGER="less"

# https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash

function version-higher() {
    if [[ $1 == $2 ]]; then
        return 1
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    test -n "$BASH_VERSION" && local j=0 
    test -n "$ZSH_VERSION" && local j=1 
    for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
        ver1[i]=$j
    done
    for ((i = $j; i < ${#ver1[@]}; i++)); do
        if ((10#${ver1[i]:=$j} > 10#${ver2[i]:=$j})); then
            return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 1
        fi
    done
    return 0
}

function compare-tput-escape_color() {
    test -z $PAGER && PAGER=less
    for ((ansi = 0; ansi <= 120; ansi++)); do
        printf "$ansi $(tput setaf $ansi) tput foreground $(tput sgr0) $(tput setab $ansi) tput background $(tput sgr0)"
        echo -e " \033[$ansi;mEscape\033[0m"
    done | $PAGER
    unset ansi
}
