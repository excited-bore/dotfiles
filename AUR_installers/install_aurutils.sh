#!/bin/bash 

[[ $0 != $BASH_SOURCE ]] && 
    SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )" || 
    SCRIPT_DIR="$( cd "$( dirname "$-1" )" && pwd )" 

if ! test -f $SCRIPT_DIR/../checks/check_all.sh; then 
    if type curl &> /dev/null; then 
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)  
    else  
        continue  
    fi 
else 
    . $SCRIPT_DIR/../checks/check_all.sh 
fi

if ! hash aur &> /dev/null; then
    if ! hash git &> /dev/null || ! hash makepkg &> /dev/null || ! hash fakeroot &> /dev/null; then
        eval "${pac_ins} --needed base-devel git fakeroot"
    fi
    git clone https://aur.archlinux.org/aurutils.git $TMPDIR/aurutils
    (cd $TMPDIR/aurutils
    makepkg -fsri)
    aur --version && echo "${green}${bold}Aurutils installed!"
    #sudo $EDITOR /etc/pacman.d/aur
fi

