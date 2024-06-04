#!/bin/bash

if ! test -f checks/update_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/update_system.sh)" 
else
    . ./checks/update_system.sh
fi

if ! type trizen &> /dev/null; then
    if ! test -x $(command -v git) || ! test -x $(command -v makepkg); then
        sudo pacman -S --needed base-devel git
    fi
    git clone https://aur.archlinux.org/trizen.git $TMPDIR/trizen
    (cd $TMPDIR/trizen
    makepkg -fsi)
    trizen --version && echo "${green}${bold}Trizen installed!"
fi

