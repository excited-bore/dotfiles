#!/bin/bash

if ! test -f checks/update_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/update_system.sh)" 
else
    . ./checks/update_system.sh
fi

if ! type paru &> /dev/null; then
    if ! test -x $(command -v git) || ! test -x $(command -v makepkg); then
        sudo pacman -S --needed base-devel git
    fi
    git clone https://aur.archlinux.org/paru.git $TMPDIR/paru
    (cd $TMPDIR/paru
    makepkg -fsi)
    paru --version && echo "${green}${bold}Paru installed!"
fi
