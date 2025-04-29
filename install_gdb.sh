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

if ! type gdb &> /dev/null; then 
    if test -n $pac_ins; then
        eval "$pac_ins gdb"
    else
        echo "${RED}System not known -> package manager not known.${normal}"
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
