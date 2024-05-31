#!/bin/bash

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if [ "$(which ffmpegthumbnailer)" == "" ]; then 
    if [ $distro_base == "Arch" ];then
        yes | sudo pacman -Su ffmpegthumbnailer
    elif [ $distro_base == "Debian" ]; then
        yes | sudo apt update
        yes | sudo apt install ffmpegthumbnailer 
    fi
fi
