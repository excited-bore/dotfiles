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

# Check one last time if ~/.bash_preexec - for both $USER and root - is the last line in their ~/.bash_profile and ~/.bashrc

if grep -q '~/.bash_preexec.sh' ~/.bash_profile && ! [[ "$(tail -1 ~/.bash_profile)" =~ '~/.bash_preexec' ]]; then
    sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' ~/.bash_profile
    printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" >>~/.bash_profile
fi

if grep -q '~/.bash_preexec.sh' ~/.bash_profile && ! [[ "$(tail -1 ~/.bashrc)" =~ '~/.bash_preexec' ]]; then
    sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' ~/.bashrc
    printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" >>~/.bashrc
fi

if test -d /root/; then
    if sudo grep -q '~/.bash_preexec.sh' /root/.bash_profile &&  ! [[ "$(sudo tail -1 /root/.bash_profile)" =~ '~/.bash_preexec' ]]; then
        sudo sed -i 'r/[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh' /root/.bash_profile
        printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" | sudo tee -a /root/.bash_profile
    fi

    if sudo grep -q '~/.bash_preexec.sh' /root/.bashrc && ! [[ "$(sudo tail -1 /root/.bashrc)" =~ '~/.bash_preexec' ]]; then
        sudo sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' /root/.bashrc
        printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" | sudo tee -a /root/.bashrc
    fi
fi
