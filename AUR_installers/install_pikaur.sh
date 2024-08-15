#!/bin/bash

if ! type ../update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ../aliases/.bash_aliases.d/update-system.sh
    fi
    update-system
else
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type pikaur &> /dev/null ; then
    if ! type git &> /dev/null || ! type makepkg &> /dev/null; then
        sudo pacman -s --needed base-devel git
    fi
    git clone https://aur.archlinux.org/pikaur.git $tmpdir/pikaur
    (cd $tmpdir/pikaur
    makepkg -fsri)
    pikaur --version && echo "${green}${bold}pikaur installed!"
fi

