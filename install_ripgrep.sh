# !/bin/bash

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if [ "$(which rg)" == "" ]; then 
    if [ $distro_base == "Arch" ];then
        yes | sudo pacman -Su ripgrep
    elif [ $distro_base == "Debian" ]; then
        yes | sudo apt install ripgrep 
    fi
fi
