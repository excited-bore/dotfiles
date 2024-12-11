#!/usr/bin/env bash

#if ! grep -q "/usr/share/bash-completion/bash_completion" ~/.bashrc; then
#    echo "[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion" >> ~/.bashrc
#fi

if [ ! -f ~/.bash_completion ]; then
    if ! test -f completions/.bash_completion; then
        curl -o ~/.bash_completion https://raw.githubusercontent.com/excited-bore/dotfiles/main/completions/.bash_completion
    else
        cp -fv completions/.bash_completion ~/
    fi 
fi


if [ ! -d ~/.bash_completion.d/ ]; then
    mkdir ~/.bash_completion.d/
fi

if ! grep -q "~/.bash_completion" ~/.bashrc; then
    printf "\n[ -f ~/.bash_completion ] && source ~/.bash_completion\n\n" >> ~/.bashrc
fi

if ! sudo test -f /root/.bash_completion; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_completion.d' in /root and source it with '/root/.bash_completion"
    if [ ! -f /root/.bash_completion ]; then
        if ! test -f completions/.bash_completion; then
            sudo curl -o /root/.bash_completion https://raw.githubusercontent.com/excited-bore/dotfiles/main/completions/.bash_completion 
        else
            sudo cp -fv completions/.bash_completion /root/
        fi 
    fi
    if ! sudo test -d /root/.bash_completion.d/; then
        sudo mkdir /root/.bash_completion.d/
    fi
    if ! sudo grep -q "~/.bash_completion" /root/.bashrc; then
        printf "\n[ -f ~/.bash_completion/ ] && source ~/.bash_completion\n\n" | sudo tee -a /root/.bashrc > /dev/null
    fi
fi 
