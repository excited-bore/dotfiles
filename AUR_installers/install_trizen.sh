#!/bin/bash

if ! test -f update_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
else
    . ./update_system.sh
fi

if ! type trizen &> /dev/null; then
    if ! type git &> /dev/null || ! type makepkg &> /dev/null; then
        sudo pacman -S --needed base-devel git
    fi
    git clone https://aur.archlinux.org/trizen.git $TMPDIR/trizen
    (cd $TMPDIR/trizen
    makepkg -fsi)
    trizen --version && echo "${green}${bold}Trizen installed!"
fi

