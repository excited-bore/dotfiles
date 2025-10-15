#!/usr/bin/env bash

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! hash go &> /dev/null; then
    readyn -p "Installer uses go. Install?" go
    if [[ "y" == "$go" ]]; then
        if ! test -f install_go.sh; then
             source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh) 
        else
            . ./install_go.sh
        fi
    fi
    unset go
fi

go install -v github.com/theimpostor/osc@latest

if ! test -f checks/check_completions_dir.sh; then
     source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh) 
else
    . ./checks/check_completions_dir.sh
fi

osc completion bash > ~/.bash_completion.d/osc

test -n $BASH_VERSION && source ~/.bashrc
test -n $ZSH_VERSION && source ~/.zshrc
