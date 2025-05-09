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

if ! command -v lowfi &> /dev/null; then
    if ! command -v npm &> /dev/null; then
       if ! test -f install_npm.sh; then
           source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_npm.sh) 
       else
           . ./install_npm.sh 
       fi 
    else 
        sudo npm -g update 
    fi
    sudo npm install -g lowfi 
fi
