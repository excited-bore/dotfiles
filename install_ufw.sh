#!/usr/bin/env bash

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

get-script-dir SCRIPT_DIR

if ! type ufw &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]] || [[ $distro_base == "Debian" ]]; then
        eval "${pac_ins}" ufw
    fi
fi

if ! type gufw &>/dev/null; then
    readyn -p 'Also install GUI for uncomplicated firewall?' ins_gui
    if [[ $ins_gui == 'y' ]]; then
        if [[ "$distro_base" == "Arch" ]] || [[ $distro_base == "Debian" ]]; then
            eval "${pac_ins}" gufw
        fi
    fi
fi
unset ins_gui
