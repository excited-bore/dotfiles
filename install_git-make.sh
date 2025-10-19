#!/bin/bash

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash git &> /dev/null; then
    eval "$pac_ins git"
fi

if ! hash make &> /dev/null; then
    eval "$pac_ins make "
fi

if ! hash cmake &> /dev/null; then
    eval "$pac_ins cmake "
fi


#if test $distro == "Arch" || test $distro == "Manjaro"; then
#    eval "$pac_ins make cmake"
#elif test $distro_base == "Debian" ; then
#    eval "$pac_ins make cmake autoconf g++ gettext libncurses5-dev libtool libtool-bin "
#fi
