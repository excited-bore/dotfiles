#!/bin/bash

if [ ! -d ~/.bash_completion.d/ ]; then
    mkdir ~/.bash_completion.d/
fi

if ! grep -q "~/.bash_completion.d" ~/.bashrc; then

    echo "if [ -d ~/.bash_completion.d/ ] && [ \"\$(ls -A ~/.bash_completion.d/)\" ]; then" >> ~/.bashrc
    echo "  for comp in ~/.bash_completion.d/*; do" >> ~/.bashrc
    echo "      . \"\$comp\" " >> ~/.bashrc
    echo "  done" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

if ! sudo test -d /root/.bash_completion.d/ ; then
    sudo mkdir /root/.bash_completion.d/
fi

if ! sudo grep -q "~/.bash_completion.d" /root/.bashrc; then
    printf "\nif [ -d ~/.bash_completion.d/ ] && [ \"\$(ls -A ~/.bash_completion.d/)\" ]; then\n  for comp in ~/.bash_completion.d/*; do\n      . \"\$comp\" \n  done\nfi" | sudo tee -a /root/.bashrc > /dev/null
fi
