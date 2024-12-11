#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type git &> /dev/null; then
    if test $distro == "Arch" || test $distro == "Manjaro"; then
        eval "$pac_ins git"
    elif test $distro_base == "Debian" ; then
        eval "$pac_ins git"
    fi
fi

if ! type make &> /dev/null; then
    if test $distro == "Arch" || test $distro == "Manjaro"; then
        eval "$pac_ins make "
    elif test $distro_base == "Debian" ; then
        eval "$pac_ins make "
    fi 
fi

if ! type cmake &> /dev/null; then
    if test $distro == "Arch" || test $distro == "Manjaro"; then
        eval "$pac_ins cmake "
    elif test $distro_base == "Debian" ; then
        eval "$pac_ins cmake "
    fi 
fi


#if test $distro == "Arch" || test $distro == "Manjaro"; then
#    eval "$pac_ins make cmake"
#elif test $distro_base == "Debian" ; then
#    eval "$pac_ins make cmake autoconf g++ gettext libncurses5-dev libtool libtool-bin "
#fi
