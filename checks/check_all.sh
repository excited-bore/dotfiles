[[ "$1" == 'n' ]] && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

READE_NOSTYLE='filecomp-only'

#! hash wget &> /dev/null && hash brew &> /dev/null &&
#    brew install wget 

alias get-script-dir='cd "$( dirname "$-1" )" && pwd'

builtin unalias curl &>/dev/null
builtin unalias wget &>/dev/null

([[ "$(type unalias)" =~ 'aliased' ]] || [[ "$(type unalias)" =~ 'function' ]]) && 
    alias unalias="builtin unalias"

# Make sure cp copies forceably (without asking confirmation when overwriting) and verbosely
if [ -z "$CP_ALIAS_CHECKED" ] && (hash xcp &> /dev/null || hash cpg &> /dev/null || command cp --help | grep -qF -- '-g') && ! [[ "$(type cp)" =~ "'cpg -fgv'" ]] && ! [[ "$(type cp)" =~ "'xcp'" ]]; then
     
    # Cpg is installed and replaced regular cp
    if command cp --help | grep -qF -- '-g'; then
        alias cp='cp -fgv' 
    else
        echo "Next ${RED}sudo${normal} will check for installed cp alternatives and whether their available for root as well as the user"
        sudo ls &> /dev/null
        if (hash cpg &> /dev/null && ! [[ "$((sudo -n 'cpg') 2>&1)" =~ 'not found' ]]); then
            alias cp='cpg -fgv'
        fi
        if hash xcp &> /dev/null && ! [[ "$((sudo -n 'xcp') 2>&1)" =~ 'not found' ]]; then
            alias cp='xcp' 
        fi
    fi
    CP_ALIAS_CHECKED='y'
elif ! (hash xcp &> /dev/null || hash cpg &> /dev/null || cp --help | grep -qF -- '-g'); then
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
hash sudo &>/dev/null && [[ "$(type sudo)" =~ 'aliased' ]] &&
    command unalias sudo
# Keep aliases when using sudo
alias sudo="sudo "

# Wget only uses https - encrypted http
hash wget &>/dev/null && [[ "$(type wget)" =~ 'aliased' ]] &&
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
    if [ -z "$WGET_ARIA" ]; then
        builtin unalias wget-aria 
        function wget-aria(){
            local wget_ar
            readyn -p "Use 'aria2c' in favour of 'wget' for faster downloads?" wget_ar
            if [[ $wget_ar == 'y' ]]; then
                export WGET_ARIA=1 
                alias wget-aria='aria2c'
                alias wget-aria-quiet='aria2c -q'
                alias wget-aria-dir='aria2c -d'
                function wget-aria-name(){
                    aria2c --dir $(dirname $1) --out=$(basename $1) ${@:2}  
                }
                alias wget-aria-name='wget-aria-name'
                local frst="$1"
                if [[ "$frst" == "-P" ]]; then
                    aria2c --dir ${@:2}
                elif [[ "$frst" == "-O" ]]; then
                    aria2c --dir $(dirname $2) --out=$(basename $2) ${@:3}  
                else
                    aria2c $frst ${@:2}
                fi 
            else
                wget $@ 
            fi
        } 
        alias wget-aria-quiet="wget-aria -q" 
        alias wget-aria-dir="wget-aria -P" 
        alias wget-aria-name="wget-aria -O" 
    else
        alias wget-aria='aria2c'
        alias wget-aria-quiet='aria2c -q'
        alias wget-aria-dir='aria2c -d'
        function wget-aria-name(){
            aria2c --dir $(dirname $1) -o $(basename $1) ${@:2} 
        }
    fi
fi


# Less does raw control chars, use color and linenumbers, no sounds/bell and doesn't trigger your epilepsy
export LESS='-R --use-color --LINE-NUMBERS --quit-if-one-screen -Q --no-vbell --prompt "Press q to quit"'
[ -z "$PAGER" ] && PAGER="less"


# ...
# https://ss64.com/bash/tput.html

# Arguments: Completions(string with space entries, AWK works too),return value(-a password prompt, -c complete filenames, -p prompt flag, -Q prompt colour, -b break-chars (when does a string break for autocomp), -e change char given for multiple autocompletions)
# 'man rlwrap' to see all unimplemented options

if ! test -f $TOP/shell/aliases/.aliases.d/00-colors.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.aliases.d/00-colors.sh)
else
    source $TOP/shell/aliases/.aliases.d/00-colors.sh
fi


if ! type reade &>/dev/null; then
    if ! [ -f $TOP/shell/rlwrap-scripts/reade ]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/rlwrap-scripts/reade)
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/rlwrap-scripts/readyn)
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/rlwrap-scripts/yes-edit-no)
    else
        source $TOP/shell/rlwrap-scripts/reade
        source $TOP/shell/rlwrap-scripts/readyn
        source $TOP/shell/rlwrap-scripts/yes-edit-no
    fi
fi

if ! [ -f $TOP/checks/check_system.sh ]; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)
else
    . $TOP/checks/check_system.sh
fi

# printf "${green} Will now start with updating system ${normal}\n"
if ! type update-system &>/dev/null; then
    if ! [ -f $TOP/shell/aliases/.aliases.d/update-system.sh ]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.aliases.d/update-kernel.sh)
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.aliases.d/update-system.sh)
    else
        . $TOP/shell/aliases/.aliases.d/update-kernel.sh
        . $TOP/shell/aliases/.aliases.d/update-system.sh
    fi
fi

if ! test -f $TOP/shell/aliases/.aliases.d/package_managers.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.aliases.d/package_managers.sh)
else
    . $TOP/shell/aliases/.aliases.d/package_managers.sh
fi


if [ -z "$SYSTEM_UPDATED" ]; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if [[ "$updatesysm" == "y" ]]; then
        update-system-yes
    fi
    export SYSTEM_UPDATED="TRUE"
    unset updatesysm 
fi


# https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash

function version-higher() {
    if [[ $1 == $2 ]]; then
        return 1
    fi
    local IFS=. i 
    if [ -n "$BASH_VERSION" ]; then
        local ver1=($1) ver2=($2) j=0
    elif [ -n "$ZSH_VERSION" ]; then
        setopt shwordsplit 
        local ver1=(${=1}) ver2=(${=2}) j=1 
    fi
    # fill empty fields in ver1 with zeros
    for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
        ver1[i]=0
    done
    if [ -n "$BASH_VERSION" ]; then
        
        for ((i = $j; $i < ${#ver1[@]}; i++)); do
            
            # 10#$variable forces variable to be a base 10 integer (relative to f.ex. an octal/hexadecimal integer)  
            # $var:=$j means 'if variable is null or unset, give it the value of $j' 
            if ((10#${ver1[i]:=$j} > 10#${ver2[i]:=$j})); then
                return 0
            fi
            if ((10#${ver1[i]:=$j} < 10#${ver2[i]:=$j})); then
                return 1
            fi
        done
    elif [ -n "$ZSH_VERSION" ]; then
        
        for ((i = $j; (($i-1)) < ${#ver1[@]}; i++)); do
            
            # 10#$variable forces variable to be a base 10 integer (relative to f.ex. an octal/hexadecimal integer)  
            [[ -z 10#${ver1[i]} ]] && ver1[i]=0 
            [[ -z 10#${ver2[i]} ]] && ver2[i]=0 
            
            if ((10#${ver1[i]} > 10#${ver2[i]})); then
                return 0
            fi
            if ((10#${ver1[i]} < 10#${ver2[i]})); then
                return 1
            fi
        done
    fi
    return 0
}
