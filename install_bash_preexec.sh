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

if ! [[ "$(tail -1 ~/.bash_profile)" =~ '~/.bash_preexec' ]]; then
    sed -i 'r/[ -f ~/.bash_preexec ] && source ~/.bash_preexec' ~/.bash_profile
    printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bash_profile
fi

if ! [[ "$(tail -1 ~/.bashrc)" =~ '~/.bash_preexec' ]]; then
    sed -i 'r/[ -f ~/.bash_preexec ] && source ~/.bash_preexec' ~/.bashrc
    printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bashrc
fi

if test -d /root/; then
    readyn -p '(Check and) Install pre-execution hooks for /root as well?' bash_r
    if [[ "$bash_r" == 'y' ]]; then
        if ! test -f /root/.bash_preexec; then
            sudo curl -s -o /root/.bash_preexec https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
        fi
        if ! [[ "$(sudo tail -1 /root/.bash_profile)" =~ '~/.bash_preexec' ]]; then
            sudo sed -i 'r/[ -f ~/.bash_preexec ] && source ~/.bash_preexec' /root/.bash_profile
            printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" | sudo tee -a /root/.bash_profile
        fi

        if ! [[ "$(sudo tail -1 /root/.bashrc)" =~ '~/.bash_preexec' ]]; then
            sudo sed -i 'r/[ -f ~/.bash_preexec ] && source ~/.bash_preexec' /root/.bashrc
            printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" | sudo tee -a /root/.bashrc
        fi

    fi
    unset bash_r
fi
