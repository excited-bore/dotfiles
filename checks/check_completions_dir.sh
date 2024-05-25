#!/bin/bash

if ! grep -q "/usr/share/bash-completion/bash_completion" ~/.bashrc; then
    echo "[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion" >> ~/.bashrc
fi

if [ ! -f ~/.bash_completion ]; then
    if ! test -f aliases/.bash_completion; then
        wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_completion -P ~/ 
    else
        cp -fv aliases/.bash_completion ~/
    fi 
fi


if [ ! -d ~/.bash_completion.d/ ]; then
    mkdir ~/.bash_completion.d/
fi

if ! grep -q "~/.bash_completion" ~/.bashrc; then
    echo "if [ -f ~/.bash_completion ]; then" >> ~/.bashrc
    echo "  . ~/.bash_completion" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi


if ! sudo test -f /root/.bash_completion; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_completion.d' in /root and source it with '/root/.bash_completion"
    if [ ! -f /root/.bash_completion ]; then
        if ! test -f aliases/.bash_completion; then
            sudo wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_completion -P /root/ 
        else
            sudo cp -fv aliases/.bash_completion /root/
        fi 
    fi
    if ! sudo test -d /root/.bash_completion.d/; then
        sudo mkdir /root/.bash_completion.d/
    fi
    if ! sudo grep -q "~/.bash_completion" /root/.bashrc; then
        printf "\nif [ -f ~/.bash_completion/ ]; then\n    . ~/.bash_completion\nfi\n" | sudo tee -a /root/.bashrc > /dev/null
    fi
fi 
