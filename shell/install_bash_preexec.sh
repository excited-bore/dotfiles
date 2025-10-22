test -n "$1" && bash_r='y'

SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! [[ -f $TOP/checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! [[ -f ~/.bash_preexec ]]; then
    wget-curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh > ~/.bash_preexec
fi

if [[ -f ~/.bash_profile ]]; then
    if grep -q '~/.bash_preexec' ~/.bash_profile && ! [[ "$(tail -1 ~/.bash_profile)" =~ '~/.bash_preexec' ]]; then
        sed -i '/[[ -f ~\/.bash_preexec ]] && source ~\/.bash_preexec/d' ~/.bash_profile
        printf "\n[[ -f ~/.bash_preexec ]] && source ~/.bash_preexec\n" >>~/.bash_profile
    fi
fi

if [[ -f ~/.bashrc ]]; then
    if grep -q '~/.bash_preexec' ~/.bashrc && ! [[ "$(tail -1 ~/.bashrc)" =~ '~/.bash_preexec' ]] || grep -q 'starship init bash' ~/.bashrc && ! [[ "$(tail -1 ~/.bashrc)" =~ 'starship init bash' ]]; then
        if ! grep -q 'starship init bash' ~/.bashrc; then
            sed -i '/[[ -f ~\/.bash_preexec ]] && source ~\/.bash_preexec/d' ~/.bashrc
            printf "[[ -f ~/.bash_preexec ]] && source ~/.bash_preexec\n" >>~/.bashrc
        else
            sed -i '/[[ -f ~\/.bash_preexec ]] && source ~\/.bash_preexec/d' ~/.bashrc
            sed -i '/starship init bash/d' ~/.bashrc
            printf "\n[[ -f ~/.bash_preexec ]] && source ~/.bash_preexec\n" >>~/.bashrc
            printf "\neval \"\$(starship init bash)\"\n" >>~/.bashrc
        fi
    fi
fi
