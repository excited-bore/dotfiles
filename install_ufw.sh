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
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi 

if ! type ufw &> /dev/null; then
    if test "$distro_base" == "Arch"; then
        eval "$pac_ins ufw"
    elif [ $distro_base == "Debian" ]; then
        eval "$pac_ins ufw"
    fi
fi

if ! type gufw &> /dev/null; then
    reade -Q 'GREEN' -i 'y' -p 'Also install GUI for uncomplicated firewall? [Y/n]: ' 'n' ins_gui
    if test $ins_gui == 'y'; then
        if test "$distro_base" == "Arch"; then
            eval "$pac_ins gufw"
        elif [ $distro_base == "Debian" ]; then
            eval "$pac_ins gufw"
        fi
    fi 
fi

unset ins_gui
