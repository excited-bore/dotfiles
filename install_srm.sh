# !/bin/bash

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi 

if ! type srm &> /dev/null; then
    if test $distro == "Manjaro"; then
        pamac install srm
    else
        echo "Install srm from sourceforge"
        echo "Link: https://sourceforge.net/projects/srm/"
    fi
fi
