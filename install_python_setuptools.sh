TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi
if [[ "$distro_base" == "Arch" ]]; then
    eval "$pac_ins_y make cmake"
elif [[ "$distro_base" == "Debian" ]]; then
    eval "$pac_ins_y make cmake autoconf g++ gettext libncurses5-dev libtool libtool-bin"
fi

if which pip 2>/dev/null || echo FALSE ; then
    pip install setuptools
fi
if which pip3 2>/dev/null || echo FALSE ; then
    pip3 install setuptools
fi
