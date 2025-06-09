#!/bin/bash

if ! test -f $SCRIPT_DIR/../checks/check_all.sh; then
    if type curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
    else 
        continue 
    fi
else
    . $SCRIPT_DIR/../checks/check_all.sh
fi

if ! hash yay &> /dev/null; then
    if ! hash git &> /dev/null || ! hash makepkg &> /dev/null || ! hash fakeroot &> /dev/null; then
        eval "${pac_ins} --needed base-devel git fakeroot"
    fi
    git clone https://aur.archlinux.org/yay.git $TMPDIR/yay
    (cd $TMPDIR/yay
    makepkg -fsri)
    yay --version && echo "${green}${bold}Yay installed!${normal}"
fi
