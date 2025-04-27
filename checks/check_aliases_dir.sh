#!/usr/bin/env bash

if ! [ -f ~/.bash_aliases ]; then
    if ! test -f aliases/.bash_aliases; then
        curl -o ~/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases  
    else
        cp -fv aliases/.bash_aliases ~/
    fi 
fi

if ! [ -d ~/.bash_aliases.d/ ]; then
    mkdir ~/.bash_aliases.d/
fi


if test -f ~/.bashrc && ! grep -q '~/.bash_aliases' ~/.bashrc; then
    if grep -q '\[ -f ~/.keybinds \]' ~/.bashrc; then
        sed -i 's|\(\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\1\n\n\[ -f \~/.keybinds \] \&\& source \~/.keybinds\n|g' ~/.bashrc
    else
        echo '[ -f ~/.bash_aliases ] && source ~/.bash_aliases' >>~/.bashrc
    fi
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


echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_aliases.d' in /root and source it with '/root/.bash_aliases' in /root/.bashrc"
if ! [ -f /root/.bash_aliases ]; then
    if ! test -f aliases/.bash_aliases; then
        sudo curl -o /root/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases  
    else
        sudo cp -fv aliases/.bash_aliases /root/
    fi 
fi
if ! sudo grep -q ".bash_aliases" /root/.bashrc; then
    printf "[ -f ~/.bash_aliases ] && source ~/.bash_aliases \n" | sudo tee -a /root/.bashrc > /dev/null
fi
if sudo test -f /root/.bashrc && ! sudo grep -q '~/.bash_aliases' /root/.bashrc; then
    if sudo grep -q '\[ -f ~/.keybinds \]' /root/.bashrc; then
        sudo sed -i 's|\(\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\1\n\n\[ -f \~/.keybinds \] \&\& source \~/.keybinds\n|g' /root/.bashrc
    else
        printf '[ -f ~/.bash_aliases ] && source ~/.bash_aliases\n' | sudo tee -a ~/.bashrc &> /dev/null
    fi
fi

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
