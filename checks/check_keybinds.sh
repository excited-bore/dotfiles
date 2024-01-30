#!/bin/bash

if [ ! -d ~/.keybinds.d/ ]; then
    mkdir ~/.keybinds.d/
fi

if ! grep -q "~/.keybinds.d" ~/.bashrc; then

    echo "if [ -d ~/.keybinds.d/ ] && [ \"\$(ls -A ~/.keybinds.d/)\" ]; then" >> ~/.bashrc
    echo "  for comp in ~/.keybinds.d/*.bash; do" >> ~/.bashrc
    echo "      . \"\$comp\" " >> ~/.bashrc
    echo "  done" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

if ! sudo test -d /root/.keybinds.d/ ; then
    sudo mkdir /root/.keybinds.d/
fi

if ! sudo grep -q "~/.keybinds.d" /root/.bashrc; then
    printf "\nif [ -d ~/.keybinds.d/ ] && [ \"\$(ls -A ~/.keybinds.d/)\" ]; then\n  for comp in ~/.keybinds.d/*.bash; do\n      . \"\$comp\" \n  done\nfi" | sudo tee -a /root/.bashrc > /dev/null
fi

KEYBIND=~/.bashrc

if [ -f ~/.keybinds.d/keybinds.bash ]; then
    KEYBIND=~/.keybinds.d/keybinds.bash
fi

KEYBIND_R=/root/.bashrc

if sudo test -f /root/.keybinds.d/keybinds.bash; then
    KEYBIND_R=/root/.keybinds.d/keybinds.bash
fi 
