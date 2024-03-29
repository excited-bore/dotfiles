# !/bin/bash

if ! test -f checks/check_distro.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro.sh)" 
else
    . ./checks/check_distro.sh
fi 

if ! type srm &> /dev/null; then
    if test $distro_base == "Arch"; then
        if test $distro == "Manjaro"; then
            yes | pamac install srm
        fi            
    else
        echo "Install srm from sourceforge"
        echo "Link: https://sourceforge.net/projects/srm/"
    fi
fi
