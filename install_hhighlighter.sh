#!/bin/bash

if ! type ack &> /dev/null; then
    if ! test -f install_ack.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ack.sh)" 
    else
        ./install_ack.sh
    fi 
fi

if ! type h &> /dev/null; then
    sudo wget --https-only -O /usr/bin/h https://raw.githubusercontent.com/paoloantinori/hhighlighter/refs/heads/master/h.sh
    printf '\nh "$@\n\"' | sudo tee -a /usr/bin/h &> /dev/null 
    sudo chmod 0755 /usr/bin/h 
    h 
fi
