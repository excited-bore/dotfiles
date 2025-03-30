#!/bin/bash 
    
if ! test -f checks/check_all.sh; then 
    if type curl &> /dev/null; then 
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"  
    else  
        continue  
    fi 
else 
    . ./checks/check_all.sh 
fi

if ! type xcp &> /dev/null; then
	if ! type cargo &> /dev/null; then
		if ! test -f install_cargo.sh; then
    			eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
		else
   			. ./install_cargo.sh
		fi
	fi
	cargo install xcp
fi
