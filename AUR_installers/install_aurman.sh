#!/bin/bash

if ! test -f checks/update_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/update_system.sh)" 
else
    . ./checks/update_system.sh
fi

if ! type aurman &> /dev/null; then
    if ! test -x $(command -v git) || ! test -x $(command -v makepkg); then
        sudo pacman -S --needed base-devel git
    fi
    git clone https://aur.archlinux.org/packages/aurman.git $TMPDIR/aurman
    (cd $TMPDIR/aurman
    makepkg -fsri)
    aurman --version && echo "${green}${bold}Aurman installed!"
fi
     

