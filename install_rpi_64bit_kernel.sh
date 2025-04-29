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

if [[ $distro == "Raspbian" ]]; then
    sudo rpi-update
    if ! sudo grep -q "arm_64bit=1" /boot/config.txt; then
        sudo sed -i "s,\[pi4\],[pi4]\narm_64bit=1,g" /boot/config.txt
        readyn -p "You should reboot before further install" pmpt
        if [[ "y" == $pmpt ]]; then
            sudo reboot
        fi
    fi
fi
