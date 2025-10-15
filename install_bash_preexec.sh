test -n "$1" && bash_r='y'

SYSTEM_UPDATED='TRUE'

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f ~/.bash_preexec; then
    curl-wget https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh > ~/.bash_preexec
fi

if test -f ~/.bash_profile; then
    if grep -q '~/.bash_preexec' ~/.bash_profile && ! [[ "$(tail -1 ~/.bash_profile)" =~ '~/.bash_preexec' ]]; then
        sed -i '/[ -f ~\/.bash_preexec ] && source ~\/.bash_preexec/d' ~/.bash_profile
        printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bash_profile
    fi
fi

if test -f ~/.bashrc; then
    if grep -q '~/.bash_preexec' ~/.bashrc && ! [[ "$(tail -1 ~/.bashrc)" =~ '~/.bash_preexec' ]] || grep -q 'starship init bash' ~/.bashrc && ! [[ "$(tail -1 ~/.bashrc)" =~ 'starship init bash' ]]; then
        if ! grep -q 'starship init bash' ~/.bashrc; then
            sed -i '/[ -f ~\/.bash_preexec ] && source ~\/.bash_preexec/d' ~/.bashrc
            printf "[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bashrc
        else
            sed -i '/[ -f ~\/.bash_preexec ] && source ~\/.bash_preexec/d' ~/.bashrc
            sed -i '/starship init bash/d' ~/.bashrc
            printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bashrc
            printf "\neval \"\$(starship init bash)\"\n" >>~/.bashrc
        fi
    fi
fi

if test -d /root/; then
    test -z "$bash_r" && readyn -p '(Check and) Install pre-execution hooks for /root as well?' bash_r
    if [[ "$bash_r" == 'y' ]]; then
        if ! test -f /root/.bash_preexec; then
            sudo curl -s -o /root/.bash_preexec https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh
        fi

        if test -f /root/.bash_profile; then
            if sudo grep -q '~/.bash_preexec' /root/.bash_profile &&  ! [[ "$(sudo tail -1 /root/.bash_profile)" =~ '~/.bash_preexec' ]]; then
                sudo sed -i 'r/[ -f ~/.bash_preexec ] && source ~/.bash_preexec' /root/.bash_profile
                printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" | sudo tee -a /root/.bash_profile &> /dev/null
            fi
        fi

    if test -f ~/.bashrc; then 
        if sudo grep -q '~/.bash_preexec' /root/.bashrc && ! [[ "$(sudo tail -1 /root/.bashrc)" =~ '~/.bash_preexec' ]] || sudo grep -q 'starship init bash' /root/.bashrc && ! [[ "$(sudo tail -1 /root/.bashrc)" =~ 'starship init bash' ]]; then
                if ! sudo grep -q 'starship init bash' /root/.bashrc; then
                    sudo sed -i '/[ -f ~\/.bash_preexec ] && source ~\/.bash_preexec/d' /root/.bashrc
                    printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" | sudo tee -a /root/.bashrc 1> /dev/null
                else
                    sudo sed -i '/[ -f ~\/.bash_preexec ] && source ~\/.bash_preexec/d' /root/.bashrc
                    sudo sed -i '/starship init bash/d' /root/.bashrc
                    printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" | sudo tee -a /root/.bashrc 1> /dev/null
                    printf "\neval \"\$(starship init bash)\"\n" | sudo tee -a /root/.bashrc 1> /dev/null
                fi
            fi
        fi
    fi
fi
