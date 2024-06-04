#!/bin/bash

if ! test -f update_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
else
    . ./update_system.sh
fi

if ! type yay &> /dev/null; then
    if ! type git &> /dev/null || ! type makepkg &> /dev/null; then
        sudo pacman -S --needed base-devel git
    fi
    git clone https://aur.archlinux.org/yay.git $TMPDIR/yay
    (cd $TMPDIR/yay
    makepkg -si)
    yay --version && echo "${green}${bold}Yay installed!"
fi
