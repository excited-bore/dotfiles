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

if ! type git &> /dev/null; then
    eval "$pac_ins git"
fi

if ! type make &> /dev/null; then
    eval "$pac_ins make "
fi

if ! type cmake &> /dev/null; then
    eval "$pac_ins cmake "
fi


#if test $distro == "Arch" || test $distro == "Manjaro"; then
#    eval "$pac_ins make cmake"
#elif test $distro_base == "Debian" ; then
#    eval "$pac_ins make cmake autoconf g++ gettext libncurses5-dev libtool libtool-bin "
#fi
