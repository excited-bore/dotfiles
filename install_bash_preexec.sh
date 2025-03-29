#!/usr/bin/env bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f ~/.bash_preexec; then
    curl -s -o ~/.bash_preexec https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh 
fi

if grep -q '~/.bash_preexec' $PROFILE; then
    printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n\n" >> $PROFILE
    #if grep -q "[ -f ~/.environment.env ]" ~/.bashrc; then
    #     sed -i 's|\(\[ -f ~/.environment.env \] \&\& source \~/.environment.env\)|\[ -f ~/.bash_preexec \] \&\& source ~/.bash_preexec\n\1\n\n|g' ~/.bashrc
    #elif grep -q "[ -f ~/.bash_completion ]" ~/.bashrc; then
    #     sed -i 's|\(\[ -f ~/.bash_completion \] \&\& source \~/.bash_completion\)|\[ -f ~/.bash_preexec \] \&\& source ~/.bash_preexec\n\n\1\n|g' ~/.bashrc
    #elif grep -q "[ -f ~/.bash_aliases ]" ~/.bashrc; then
    #     sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\[ -f ~/.bash_preexec \] \&\& source ~/.bash_preexec\n\n\1\n|g' ~/.bashrc
    #elif grep -q "[ -f ~/.keybinds ]" ~/.bashrc; then
    #     sed -i 's|\(\[ -f ~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f ~/.bash_preexec \] \&\& source ~/.bash_preexec\n\n\1\n|g' ~/.bashrc
    #fi
fi

if test -d /root/; then
    readyn -p '(Check and) Install pre-execution hooks for /root as well?' bash_r
    if [[ $bash_r == 'y' ]]; then
        if ! test -f /root/.bash_preexec; then
            sudo curl -s -o /root/.bash_preexec https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
        fi
        if ! sudo grep -q '~/.bash_preexec' $PROFILE_R; then
            printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n\n" | sudo tee -a $PROFILE_R 1> /dev/null
            #if sudo grep -q "[ -f /root/.environment.env ]" /root/.bashrc; then
            #   sudo sed -i 's|\(\[ -f /root/.environment.env \] \&\& source \/root/.environment.env\)|\[ -f /root/.bash_preexec \] \&\& source /root/.bash_preexec\n\1\n\n|g' /root/.bashrc
            #elif sudo grep -q "[ -f /root/.bash_completion ]" /root/.bashrc; then
            #     sudo sed -i 's|\(\[ -f /root/.bash_completion \] \&\& source \/root/.bash_completion\)|\[ -f /root/.bash_preexec \] \&\& source /root/.bash_preexec\n\n\1\n|g' /root/.bashrc
            #elif sudo grep -q "[ -f /root/.bash_aliases ]" /root/.bashrc; then
            #     sudo sed -i 's|\(\[ -f /root/.bash_aliases \] \&\& source \/root/.bash_aliases\)|\[ -f /root/.bash_preexec \] \&\& source /root/.bash_preexec\n\n\1\n|g' /root/.bashrc
            #elif sudo grep -q "[ -f /root/.keybinds ]" /root/.bashrc; then
            #     sudo sed -i 's|\(\[ -f /root/.keybinds \] \&\& source \/root/.keybinds\)|\[ -f /root/.bash_preexec \] \&\& source /root/.bash_preexec\n\n\1\n|g' /root/.bashrc
            #else
            #fi
        fi
    fi
    unset bash_r 
fi
