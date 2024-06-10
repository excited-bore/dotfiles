#!/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi
if ! type testdisk &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install testdisk"
    if test $distro == "Arch" || test $distro == "Manjaro"; then 
        sudo pacman -S testdisk
    elif test $distro_base == "Debian"; then
        sudo apt install testdisk
    fi
fi
