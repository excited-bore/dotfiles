#!/usr/bin/env bash

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
    if sudo grep -q '~/.bash_preexec.sh' /root/.bash_profile &&  ! [[ "$(sudo tail -1 /root/.bash_profile)" =~ '~/.bash_preexec' ]]; then
        sudo sed -i 'r/[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh' /root/.bash_profile
        printf "\n[ -f ~/.bash_preexec.sh ] && source ~/.bash_preexec.sh\n" | sudo tee -a /root/.bash_profile
    fi

if sudo grep -q '~/.bash_preexec.sh' /root/.bashrc && ! [[ "$(sudo tail -1 /root/.bashrc)" =~ '~/.bash_preexec' ]] || sudo grep -q 'starship init bash' /root/.bashrc && ! [[ "$(sudo tail -1 ~/.bashrc)" =~ 'starship init bash' ]]; then
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

