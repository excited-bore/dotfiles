# !/bin/bash
. ./readline/rlwrap_scripts.sh

if [ "$(which bat)" == "" ]; then 
    if [ $distro_base == "Arch" ];then
        yes | sudo pacman -Su bat
    elif [ $distro_base == "Debian" ]; then
        yes | sudo apt update
        yes | sudo apt install bat
        if [ -x "$(command -v batcat)" ]; then
            mkdir -p ~/.local/bin
            ln -s /usr/bin/batcat ~/.local/bin/bat
        fi
    fi
fi 

unset bat 
