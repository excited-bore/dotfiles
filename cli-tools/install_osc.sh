hash osc &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash go &> /dev/null; then
    readyn -p "Installer uses go. Install?" go
    if [[ "y" == "$go" ]]; then
        if ! test -f pkgmngrs/install_go.sh; then
             source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_go.sh) 
        else
            . pkgmngrs//install_go.sh
        fi
    fi
    unset go
fi

go install -v github.com/theimpostor/osc@latest

if ! test -f ../checks/check_completions_dir.sh; then
     source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh) 
else
    . ../checks/check_completions_dir.sh
fi

osc completion bash > ~/.bash_completion.d/osc.bash
osc completion zsh > ~/.bash_completion.d/osc.zsh

test -n "$BASH_VERSION" && source ~/.bashrc
test -n "$ZSH_VERSION" && source ~/.zshrc
