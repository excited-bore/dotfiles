#!/bin/bash

if ! test -f ../update_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
else
    . ./../update_system.sh
fi

update_system

if ! type aurman &> /dev/null; then
    if ! type git &> /dev/null || ! type makepkg &> /dev/null; then
        sudo pacman -S --needed base-devel git
    fi
    git clone https://aur.archlinux.org/packages/aurman.git $TMPDIR/aurman
    (cd $TMPDIR/aurman
    makepkg -fsri)
    aurman --version && echo "${green}${bold}Aurman installed!"
fi
     

