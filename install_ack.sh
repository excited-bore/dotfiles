#!/bin/bash

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type ack &> /dev/null; then
    if ! test -z "$pac_ins"; then
        ${pac_ins} ack 
    fi
    if ! test $? == 0 || test -z "$pac_ins"; then
        b="$(curl https://beyondgrep.com/ack-2.16-single-file)" 
        sudo tee "$b" /usr/bin/ack 
        sudo chmod 0755 /usr/bin/ack
        unset b 
    fi
fi
