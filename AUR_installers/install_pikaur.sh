#!/bin/bash

if ! test -f checks/update_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/update_system.sh)" 
else
    . ./checks/update_system.sh
fi

if ! type pikaur &> /dev/null ; then
    if ! type git &> /dev/null || ! type makepkg &> /dev/null; then
        sudo pacman -S --needed base-devel git
    fi
    git clone https://aur.archlinux.org/pikaur.git $TMPDIR/pikaur
    (cd $TMPDIR/pikaur
    makepkg -fsri)
    pikaur --version && echo "${green}${bold}Pikaur installed!"
fi

