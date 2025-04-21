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

# Check one last time if ~/.bash_preexec - for both $USER and root - is the last line in their ~/.bash_profile and ~/.bashrc

if grep -q '~/.bash_preexec' ~/.bash_profile && ! [[ "$(tail -1 ~/.bash_profile)" =~ '~/.bash_preexec' ]]; then
    sed -i 'r/[ -f ~/.bash_preexec ] && source ~/.bash_preexec' ~/.bash_profile
    printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bash_profile
fi

if grep -q '~/.bash_preexec' ~/.bash_profile && ! [[ "$(tail -1 ~/.bashrc)" =~ '~/.bash_preexec' ]]; then
    sed -i 'r/[ -f ~/.bash_preexec ] && source ~/.bash_preexec' ~/.bashrc
    printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bashrc
fi

if test -d /root/; then
    if sudo grep -q '~/.bash_preexec' /root/.bash_profile &&  ! [[ "$(sudo tail -1 /root/.bash_profile)" =~ '~/.bash_preexec' ]]; then
        sudo sed -i 'r/[ -f ~/.bash_preexec ] && source ~/.bash_preexec' /root/.bash_profile
        printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" | sudo tee -a /root/.bash_profile
    fi

    if sudo grep -q '~/.bash_preexec' /root/.bashrc && ! [[ "$(sudo tail -1 /root/.bashrc)" =~ '~/.bash_preexec' ]]; then
        sudo sed -i 'r/[ -f ~/.bash_preexec ] && source ~/.bash_preexec' /root/.bashrc
        printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" | sudo tee -a /root/.bashrc
    fi
fi

