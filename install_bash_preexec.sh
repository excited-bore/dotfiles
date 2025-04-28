#!/usr/bin/env bash

local bash_r
test -n "$1" && bash_r='y'

SYSTEM_UPDATED='TRUE'

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

if ! test -f ~/.bash_preexec.sh; then
    curl -s -o ~/.bash_preexec.sh https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
fi

if grep -q '~/.bash_preexec.sh' ~/.bash_profile && ! [[ "$(tail -1 ~/.bash_profile)" =~ '~/.bash_preexec' ]]; then
    sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' ~/.bash_profile
    printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" >>~/.bash_profile
fi

if grep -q '~/.bash_preexec.sh' ~/.bashrc && ! [[ "$(tail -1 ~/.bashrc)" =~ '~/.bash_preexec' ]] || grep -q 'starship init bash' ~/.bashrc && ! [[ "$(tail -1 ~/.bashrc)" =~ 'starship init bash' ]]; then
    if ! grep -q 'starship init bash' ~/.bashrc; then
        sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' ~/.bashrc
        printf "[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" >>~/.bashrc
    else
        sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' ~/.bashrc
        sed -i '/starship init bash/d' ~/.bashrc
        printf "[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" >>~/.bashrc
        printf "\neval \"\$(starship init bash)\"\n" >>~/.bashrc
    fi
fi

if test -d /root/; then
    test -z "$bash_r" && readyn -p '(Check and) Install pre-execution hooks for /root as well?' bash_r
    if [[ "$bash_r" == 'y' ]]; then
        if ! test -f /root/.bash_preexec.sh; then
            sudo curl -s -o /root/.bash_preexec.sh https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
        fi

        if sudo grep -q '~/.bash_preexec.sh' /root/.bash_profile &&  ! [[ "$(sudo tail -1 /root/.bash_profile)" =~ '~/.bash_preexec' ]]; then
            sudo sed -i 'r/[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh' /root/.bash_profile
            printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" | sudo tee -a /root/.bash_profile
        fi

    if sudo grep -q '~/.bash_preexec.sh' /root/.bashrc && ! [[ "$(sudo tail -1 /root/.bashrc)" =~ '~/.bash_preexec' ]] || sudo grep -q 'starship init bash' /root/.bashrc && ! [[ "$(sudo tail -1 /root/.bashrc)" =~ 'starship init bash' ]]; then
            if ! sudo grep -q 'starship init bash' /root/.bashrc; then
                sudo sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' /root/.bashrc
                printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" | sudo tee -a /root/.bashrc 1> /dev/null
            else
                sudo sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' /root/.bashrc
                sudo sed -i '/starship init bash/d' /root/.bashrc
                printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" | sudo tee -a /root/.bashrc 1> /dev/null
                printf "\neval \"\$(starship init bash)\"\n" | sudo tee -a /root/.bashrc 1> /dev/null
            fi
        fi
    fi
fi
