if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
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

if ! type pv &> /dev/null; then
    if test "$distro_base" == "Arch"; then
        yes | eval "$pac_ins pv "
    elif [ $distro_base == "Debian" ]; then
        eval "$pac_ins pv -y                                                               "
    fi
fi