#!/bin/bash

SYSTEM_UPDATED='true'

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

file=rm-prmpt/rm-prompt
if ! test -f $file; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/rm-prmpt/rm-prompt
    file=$tmp
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will install $(tput setaf 2)rm-prompt$(tput sgr0) inside $(tput bold)/usr/bin/$(tput sgr0)"
yes-edit-no -g "$file" -p 'Install rm-prompt?' -c '! hash rm-prompt &> /dev/null' nstll
if [[ $nstll == 'y' ]]; then
    sudo install -Dm777 $file -t "/usr/bin/" 
    rm-prompt --help 
fi


#if ! type rm-prompt &> /dev/null; then
    #reade -Q 'GREEN' -i 'y' -p 'Install rm-prompt? (Rm but prompts files before deletion) [Y/n]: ' 'n' rm_ins
    #if test $rm_ins == 'y'; then
    #fi
#fi
