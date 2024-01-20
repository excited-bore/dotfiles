# !/bin/bash
. ./readline/rlwrap_scripts.sh
. ./checks/check_distro.sh

reade -Q "GREEN" -i "y" -p "Install copy-to? (Python tool for copying between 2 maps) [Y/n]:" "y n" cpcnf
if [ -z $compl ] || [ "y" == $compl ]; then
    if [ ! -x "$(command -v pipx)" ]; then
        if [ $distro_base == "Arch" ]; then
            yes | sudo pacman -Su python-pipx
        elif [ $distro_base == "Debian" ]; then
            yes | sudo apt install pipx
        fi
    fi
fi
pipx install copy-to
copy-to -h
