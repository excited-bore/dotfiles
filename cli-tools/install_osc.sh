# https://github.com/theimpostor/osc

hash osc &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash go &> /dev/null; then
    readyn -p "Installer uses go. Install?" go
    if [[ "y" == "$go" ]]; then
        if ! test -f $TOP/cli-tools/pkgmngrs/install_go.sh; then
             source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_go.sh) 
        else
            . $TOP/cli-tools/pkgmngrs//install_go.sh
        fi
    fi
    unset go
fi

if ! hash osc &> /dev/null; then
    go install -v github.com/theimpostor/osc@latest
fi

if hash osc &> /dev/null; then
   
    if test -d ~/.bash_completion.d/ && ! test -f ~/.bash_completion.d/osc.bash; then
        osc completion bash > ~/.bash_completion.d/osc.bash
    fi
    
    if test -d ~/.zsh_completion.d/ && ! test -f ~/.zsh_completion.d/osc.zsh; then
        osc completion zsh > ~/.bash_completion.d/osc.zsh
    fi
fi
