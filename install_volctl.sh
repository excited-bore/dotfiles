#!/bin/bash

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if test -f $SCRIPT_DIR/checks/check_AUR.sh; then
    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
else
    . $SCRIPT_DIR/checks/check_AUR.sh
fi

if [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
    echo "${RED}Wayland${red} is sadly not supported. Exiting...${normal}"
else 
    if [[ $distro_base == 'Arch' ]]; then
        eval "${AUR_ins} volctl" 
    else
        git clone https://github.com/buzz/volctl $TMPDIR/volctl
        (cd $TMPDIR/volctl 
        sudo ./setup.py install
        sudo update-desktop-database 
        test -d /usr/share/glib-2.0/schemas/ &&
            sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
        test -d /usr/local/share/glib-2.0/schemas/ &&
            sudo glib-compile-schemas /usr/local/share/glib-2.0/schemas/
        ) 
    fi
fi
