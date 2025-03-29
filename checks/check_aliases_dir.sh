#!/usr/bin/env bash

if [ ! -f ~/.bash_aliases ]; then
    if ! test -f aliases/.bash_aliases; then
        curl -o ~/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases  
    else
        cp -fv aliases/.bash_aliases ~/
    fi 
fi

if [ ! -d ~/.bash_aliases.d/ ]; then
    mkdir ~/.bash_aliases.d/
fi

if ! grep -q ".bash_aliases" ~/.bashrc; then
    echo '[ -f ~/.bash_aliases ] && source ~/.bash_aliases' >> ~/.bashrc
fi

#if ! grep -q "shopt -s expand_aliases" ~/.bashrc; then
#    echo "shopt -s expand_aliases" >> ~/.bashrc
#fi
#
#if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then
#
#    echo "if [ -d ~/.bash_aliases.d/ ] && [ \"\$(ls -A ~/.bash_aliases.d/)\" ]; then" >> ~/.bashrc
#    echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
#    echo "      . \"\$alias\" " >> ~/.bashrc
#    echo "  done" >> ~/.bashrc
#    echo "fi" >> ~/.bashrc
#fi


if ! sudo test -f /root/.bash_aliases; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_aliases.d' in /root and source it with '/root/.bash_aliases' "
    sudo cp -fv ~/.bash_aliases /root/
    if ! sudo grep -q ".bash_aliases" /root/.bashrc; then
        printf "[ -f ~/.bash_aliases ] && source ~/.bash_aliases \n" | sudo tee -a /root/.bashrc > /dev/null
    fi
fi