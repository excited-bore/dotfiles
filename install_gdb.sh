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
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type gdb &> /dev/null; then 
    if test "$distro" == "Arch" || test "$distro" == "Manjaro" ;then
        sudo pacman -S gdb
    elif test $distro_base == "Debian"; then
        sudo apt install gdb 
    fi
fi

if ! test -d ~/.config/gdb; then
    mkdir -p ~/.config/gdb
fi

if ! test -f ~/.config/gdb/gdbinit; then
    echo 'set history save on' >> ~/.config/gdb/gdbinit
    echo 'set history size 256' >> ~/.config/gdb/gdbinit
    echo 'set history remove-duplicates 1' >> ~/.config/gdb/gdbinit 
fi
