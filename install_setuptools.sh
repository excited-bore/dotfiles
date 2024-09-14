if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if test $distro == "Arch" || test $distro == "Manjaro"; then
    eval "$pac_ins make cmake"
elif [ $distro_base == "Debian" ]; then
    eval "$pac_ins make cmake autoconf g++ gettext libncurses5-dev libtool libtool-bin "
fi

if which pip 2>/dev/null || echo FALSE ; then
    pip install setuptools
fi
if which pip3 2>/dev/null || echo FALSE ; then
    pip3 install setuptools
fi
