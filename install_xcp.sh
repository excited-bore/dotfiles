#!/bin/bash 
    
if ! test -f checks/check_all.sh; then 
    if command -v curl &> /dev/null; then 
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)  
    else  
        continue  
    fi 
else 
    . ./checks/check_all.sh 
fi

if ! hash xcp &> /dev/null; then
    if ! hash cargo &> /dev/null || ! [[ $PATH =~ '/.cargo/bin' ]] ; then
        if ! test -f install_cargo.sh; then
            source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
        else
            . ./install_cargo.sh
        fi
    fi
    cargo install xcp
    xcp --help | $PAGER 
fi
