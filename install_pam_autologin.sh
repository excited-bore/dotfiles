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

if ! test -f checks/check_AUR.sh; then
    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
else
    . ./checks/check_AUR.sh
fi

if ! test -z "$AUR_ins"; then
    eval "${AUR_ins} pam_autologin"
fi

if ! sudo grep -q "pam_autologin.so" /etc/pam.d/login; then
    sudo sed -i 's|\(#%PAM-1.0\)|\1\nauth       required        pam_autologin.so always|g' /etc/pam.d/login
fi
