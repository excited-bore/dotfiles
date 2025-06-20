#!/bin/bash

[[ $0 != $BASH_SOURCE ]] && 
    SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )" || 
    SCRIPT_DIR="$( cd "$( dirname "$-1" )" && pwd )" 

if ! test -f $SCRIPT_DIR/../checks/check_all.sh; then
    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
else
    . $SCRIPT_DIR/../checks/check_all.sh
fi

if ! hash pacaur &> /dev/null; then
    if ! hash git &> /dev/null || ! hash makepkg &> /dev/null || ! hash fakeroot &> /dev/null; then
        eval "${pac_ins} --needed base-devel git fakeroot"
    fi
    if ! hash auracle &> /dev/null; then
        if ! test -f $SCRIPT_DIR/install_auracle.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_auracle.sh) 
        else 
            . $SCRIPT_DIR/install_auracle.sh
        fi 
    fi
     
    git clone https://aur.archlinux.org/pacaur.git $TMPDIR/pacaur
    (cd $TMPDIR/pacaur
    makepkg -fsri)
    pacaur --version && echo "${GREEN}Pacaur installed!${normal}"
fi
