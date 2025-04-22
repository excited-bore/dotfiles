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
    curl -s -o ~/.bash_preexec.sh https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
fi

if ! [[ "$(tail -1 ~/.bash_profile)" =~ '~/.bash_preexec.sh' ]]; then
    sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' ~/.bash_profile
    printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" >>~/.bash_profile
fi

readyn -n -p 'Sourced to ~/.bash_profile. Source in ~/.bashrc as well (might break prompts like starship when reloading .bashrc)?' bash_rc
if [[ "$bash_rc" == 'y' ]]; then
    if ! [[ "$(tail -1 ~/.bashrc)" =~ '~/.bash_preexec.sh' ]]; then
        sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' ~/.bashrc
        printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" >>~/.bashrc
    fi
fi

if test -d /root/; then
    readyn -p '(Check and) Install pre-execution hooks for /root as well?' bash_r
    if [[ "$bash_r" == 'y' ]]; then
        if ! test -f /root/.bash_preexec.sh; then
            sudo curl -s -o /root/.bash_preexec.sh https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
        fi
        readyn -n -p 'Sourced to /root/.bash_profile. Source in /root/.bashrc as well (might break prompts like starship when reloading .bashrc)?' bash_rrc
        if [[ "$bash_rrc" == 'y' ]]; then
            if ! [[ "$(sudo tail -1 /root/.bash_profile)" =~ '~/.bash_preexec.sh' ]]; then
                sudo sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' /root/.bash_profile
                printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" | sudo tee -a /root/.bash_profile
            fi

            if ! [[ "$(sudo tail -1 /root/.bashrc)" =~ '~/.bash_preexec.sh' ]]; then
                sudo sed -i '/[ -f ~\/.bash_preexec.sh ] && source ~\/.bash_preexec.sh/d' /root/.bashrc
                printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" | sudo tee -a /root/.bashrc
            fi
        fi
    fi
    unset bash_r
fi
