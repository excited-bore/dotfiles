#!/bin/bash

if [ ! -d ~/.keybinds.d/ ]; then
    mkdir ~/.keybinds.d/
fi

if ! grep -q ".keybinds" ~/.bashrc; then
    printf "[ -f ~/.keybinds ] && source ~/.keybinds\n" >> ~/.bashrc 
fi

if ! sudo test -d /root/.keybinds.d/ ; then
    sudo mkdir /root/.keybinds.d/
fi

if ! sudo grep -q ".keybinds" /root/.bashrc; then
    sudo printf "[ -f ~/.keybinds ] && source ~/.keybinds\n" | sudo tee -a /root/.bashrc 
fi

KEYBIND=~/.bashrc

if [ -f ~/.keybinds.d/keybinds.bash ]; then
    KEYBIND=~/.keybinds.d/keybinds.bash
fi

KEYBIND_R=/root/.bashrc

if sudo test -f /root/.keybinds.d/keybinds.bash; then
    KEYBIND_R=/root/.keybinds.d/keybinds.bash
fi 
