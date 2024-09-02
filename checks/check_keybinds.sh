#!/usr/bin/env bash

if [ ! -f ~/.keybinds ]; then
    if ! test -f keybinds/.keybinds; then
        curl -o ~/.keybinds https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds  
    else
        cp -fv keybinds/.keybinds ~/
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
