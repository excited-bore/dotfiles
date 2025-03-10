#!/usr/bin/env bash

if ! type ../update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ../aliases/.bash_aliases.d/update-system.sh
    fi
    update-system
else
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type trizen &> /dev/null; then
    if ! type git &> /dev/null || ! type makepkg &> /dev/null; then
        eval "$pac_ins --needed base-devel git"
    fi
    git clone https://aur.archlinux.org/trizen.git $TMPDIR/trizen
    (cd $TMPDIR/trizen
    makepkg -fsi)
    trizen --version && echo "${green}${bold}Trizen installed!"
fi

