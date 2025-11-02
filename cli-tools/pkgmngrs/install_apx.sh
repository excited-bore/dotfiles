# https://github.com/jim3692/apx-package-manager

hash apx &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! test -f $TOP/checks/check_AUR.sh; then
     source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
else
    . $TOP/checks/check_AUR.sh
fi

if ! test -f $TOP/cli-tools/install_docker.sh; then
     source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_docker.sh)
else
    . $TOP/cli-tools/install_docker.sh
fi

if [[ $distro_base == "Arch" ]]; then
    #TODO integrate different AUR launchers
    eval "$AUR_ins_y apx" 
    #echo "Install with apx with AUR launcher of choice (f.ex. yay, pamac)"
    #return 0
elif [[ $distro_base == "Debian" ]]; then
    if ! hash git &> /dev/null; then
        eval "$pac_ins_y git" 
    fi
    git clone https://github.com/Vanilla-OS/apx $TMPDIR/apx
    
    if ! hash go &> /dev/null; then
        if ! test -f $TOP/cli-tools/pkgmngrs/install_go.sh; then
             source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_go.sh)
        else
            . $TOP/cli-tools/pkgmngrs/install_go.sh
        fi
    fi
    go build $TMPDIR/apx
    sudo install -Dm755 "$TMPDIR/apx/apx" "/usr/bin/apx"
    sudo install -Dm644 "$TMPDIR/apx/man/apx.1" "/usr/share/man/man1/apx.1"
    #sudo install -Dm644 "./man/es/apx.1" "/usr/share/man/es/man1/apx.1"
    sudo install -Dm644 "$TMPDIR/apx/config/config.json" "/etc/apx/config.json"
    sudo sed -i "s,\(\"distroboxpath\": \"\).*,\1$HOME/.local/bin/distrobox\",g" /etc/apx/config.json
    if ! test -f $TOP/install_distrobox.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_distrobox.sh) 
     else
        . $TOP/install_distrobox.sh
    fi
    sudo mkdir /usr/lib/apx
    sudo mv ~/.local/bin/distrobox* /usr/lib/apx
fi

if hash systemctl &> /dev/null && systemctl status docker | grep -q dead; then
    systemctl start docker.service
fi

if test -d ~/.bash_completion.d/ && ! test -f ~/.bash_completion.d/complete-apx; then
    apx completion bash > ~/.bash_completion.d/complete-apx
fi

if test -d ~/.zsh_completion.d/site-functions/ && ! test -f ~/.zsh_completion.d/site-functions/complete-apx; then
    apx completion zsh > ~/.zsh_completion.d/site-functions/complete-apx
fi
