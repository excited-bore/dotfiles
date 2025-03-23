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

if ! type trizen &> /dev/null; then
    if ! type git &> /dev/null || ! type makepkg &> /dev/null || ! type fakeroot &> /dev/null; then
        eval ${pac_ins} --needed base-devel git fakeroot
    fi
    git clone https://aur.archlinux.org/trizen.git $TMPDIR/trizen
    (cd $TMPDIR/trizen
    makepkg -fsri)
    trizen --version && echo "${green}${bold}Trizen installed!"
fi

