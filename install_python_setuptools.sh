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
if test "$distro" == "Arch" || test "$distro" == "Manjaro"; then
    ${pac_ins} make cmake
elif [ "$distro_base" == "Debian" ]; then
    ${pac_ins} make cmake autoconf g++ gettext libncurses5-dev libtool libtool-bin
fi

if which pip 2>/dev/null || echo FALSE ; then
    pip install setuptools
fi
if which pip3 2>/dev/null || echo FALSE ; then
    pip3 install setuptools
fi
