# !/bin/bash
. ./checks/check_distro.sh

reade -Q "GREEN" -i "y" -p "Install copy-to? (Python tool for copying between 2 maps) [Y/n]:" "y n" cpcnf
if [ -z $compl ] || [ "y" == $compl ]; then
    if [ ! -x "$(command -v pip)" ]; then
        if [ $distro_base == "Arch" ]; then
            yes | sudo pacman -Su python-pip
        elif [ $distro_base == "Debian" ]; then
            yes | sudo apt install python3-pip
        fi
    fi
fi
pip3 install copy-to
copy-to -h
