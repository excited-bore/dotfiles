#!/bin/bash 
 
[[ $0 != $BASH_SOURCE ]] && SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )" || SCRIPT_DIR="$( cd "$( dirname "$-1" )" && pwd )" 
 
if ! test -f $SCRIPT_DIR/../checks/check_all.sh; then 
    if type curl &> /dev/null; then 
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"  
    else  
        continue  
    fi 
else 
    . $SCRIPT_DIR/../checks/check_all.sh 
fi

if ! type paru &> /dev/null; then
    if ! type git &> /dev/null || ! type makepkg &> /dev/null || ! type fakeroot &> /dev/null; then
        eval ${pac_ins} --needed base-devel git fakeroot
    fi
    git clone https://aur.archlinux.org/paru.git $TMPDIR/paru
    (cd $TMPDIR/paru
    makepkg -fsri)
    paru --version && echo "${green}${bold}Paru installed!"
fi
