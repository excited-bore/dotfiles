#!/bin/bash
if ! test -f checks/check_distro.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro.sh)" 
else
    . ./checks/check_distro.sh
fi

if ! type testdisk &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install testdisk"
    if test $distro_base == "Arch"; then 
        yes | sudo pacman -Su testdisk
    elif test $distro_base == "Debian"; then
        yes | sudo apt install testdisk
    fi
fi
