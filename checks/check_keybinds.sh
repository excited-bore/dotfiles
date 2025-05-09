#!/usr/bin/env bash

if [ ! -f ~/.keybinds ]; then
    if ! test -f keybinds/.keybinds; then
        curl -o ~/.keybinds https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds  
    else
        cp keybinds/.keybinds ~/
    fi 
fi 

if [ ! -d ~/.keybinds.d/ ]; then
    mkdir ~/.keybinds.d/
fi

if ! grep -q ".keybinds" ~/.bashrc; then
    printf "\n[ -f ~/.keybinds ] && source ~/.keybinds\n\n" >> ~/.bashrc 
fi

if ! sudo test -d /root/.keybinds.d/ ; then
    sudo mkdir /root/.keybinds.d/
fi

if ! sudo grep -q ".keybinds" /root/.bashrc; then
    sudo printf "\n[ -f ~/.keybinds ] && source ~/.keybinds\n\n" | sudo tee -a /root/.bashrc &> /dev/null
fi

# Check one last time if ~/.bash_preexec - for both $USER and root - is the last line in their ~/.bash_profile and ~/.bashrc

if ! test -f ./checks/check_bash_source_order.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_bash_source_order.sh
fi
