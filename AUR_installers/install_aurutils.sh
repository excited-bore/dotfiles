#!/bin/bash

if ! test -f update_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
else
    . ./update_system.sh
fi

if ! type aur &> /dev/null; then
    if ! type git &> /dev/null || ! type makepkg &> /dev/null; then
        sudo pacman -S --needed base-devel git
    fi
    git clone https://aur.archlinux.org/aurutils.git $TMPDIR/aurutils
    (cd $TMPDIR/aurutils
    makepkg -fsri)
    aur --version && echo "${green}${bold}Aurutils installed!"
    sudo $EDITOR /etc/pacman.d/aur
fi

