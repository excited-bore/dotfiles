#!/bin/bash

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

SCRIPT_DIR=$(get-script-dir)

if ! command -v cargo &> /dev/null; then
    if ! test -f $SCRIPT_DIR/install_cargo.sh; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
    else
       . ./install_cargo.sh
    fi
fi

if ! test -f ~/.cargo/bin/zellij; then 
    if ! test -z "$pac_rm"; then
        eval "${pac_rm} zellij" 
    fi
    cargo install --locked zellij
fi

readyn -p "Install zellij config file at ~/.config/zellij?" -n -c "! test -f ~/.config/zellij/config.kbl" ansr
if [[ "$ansr" == 'y' ]]; then
    mkdir -p ~/.config/zellij
    zellij setup --dump-config > ~/.config/zellij/config.kdl
fi
unset ansr
