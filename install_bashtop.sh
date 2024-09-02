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

if ! test -f aliases/.bash_aliases.d/package_managers.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh)" 
else
    source aliases/.bash_aliases.d/package_managers.sh
fi


if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type bashtop &> /dev/null && ! type bpytop &> /dev/null && ! type btop &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install bashtop / btop / bpytop? [Y/n]: " "n" sym2
    if test "$sym2" == "y"; then
        reade -Q "CYAN" -i "btop" -p "Which one? [Btop/bpytop/bashtop]: " "bpytop bashtop" sym2
        if test "$sym2" == "btop"; then
            if test $distro_base == "Debian"; then
               sudo apt install btop
            elif test $distro == "Arch" || test $distro == "Manjaro"; then
               sudo pacman -S btop
            fi
        elif test "$sym2" == "bpytop"; then 
           if test $distro_base == "Debian"; then
               sudo apt install bpytop
            elif test $distro == "Arch" || test $distro == "Manjaro"; then
               sudo pacman -S bpytop
            fi
        elif test "$sym2" == "bashtop"; then      
            if type add-apt-repository &> /dev/null && [[ $(check-ppa -c ppa:bashtop-monitor/bashtop) =~ 'OK' ]]; then
                sudo add-apt-repository ppa:bashtop-monitor/bashtop
                sudo apt update
                sudo apt install bashtop
            elif test "$distro" == "Arch" || test "$distro" == "Manjaro"; then
               sudo pacman -S bashtop
            else
                git clone https://github.com/aristocratos/bashtop.git $TMPDIR
                (cd $TMPDIR/bashtop && sudo make install)
            fi
        fi
    fi
fi 
