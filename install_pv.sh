#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

if ! command -v pv &> /dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        sudo pacman -S --noconfirm pv
    elif [[ $distro_base == "Debian" ]]; then
        sudo apt install -y pv                                                              
    fi
fi
