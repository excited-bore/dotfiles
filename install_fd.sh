#!/bin/bash

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if test $distro == "Arch" || test $distro == "Manjaro"; then
    sudo pacman -S fd
elif [ $distro_base == "Debian" ]; then
    sudo apt install fd-find
    if ! test -f ~/.local/bin/fd; then
        ln -s $(which fdfind) ~/.local/bin/fd
    fi
fi
