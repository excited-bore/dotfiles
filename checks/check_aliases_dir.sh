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

