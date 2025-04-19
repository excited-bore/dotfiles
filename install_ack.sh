#!/bin/bash

if ! test -f checks/check_all.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)" 
else
    . ./checks/check_all.sh
fi

if ! test -f checks/check_aur.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aur.sh)" 
else
    . ./checks/check_aur.sh
fi


if ! type ack &> /dev/null; then
    if ! test -z "$AUR_ins"; then
        eval "${AUR_ins}" ack 
    elif ! test -z "$pac_ins"; then
        printf "Gonna try to install ack through the regular packagemanager\n"
        eval "${pac_ins}" ack
    fi
    if ! [[ $? == 0 ]] || test -z "$pac_ins"; then
        printf "Installing through regular packagemanager failed. Will just get it straight from beyongrep.com..\n"
        b="$(curl https://beyondgrep.com/ack-2.16-single-file)" 
        sudo tee "$b" /usr/bin/ack 
        sudo chmod 0755 /usr/bin/ack
        unset b 
    fi
fi

type ack &> /dev/null && ack --help
