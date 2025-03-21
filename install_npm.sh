#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &> /dev/null; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"
    else
        continue
    fi
else
    . ./checks/check_all.sh
fi

if ! type npm &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install npm and nodejs"
    if test $distro == "Arch" || test $distro == "Manjaro"; then 
        ${pac_ins} npm nodejs
    elif test $distro_base == "Debian"; then
        ${pac_ins} npm nodejs
    fi
fi


