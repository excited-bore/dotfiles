# https://zellij.dev/

hash zellij &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if ! hash cargo &> /dev/null; then
    if ! [[ -f $TOP/cli-tools/pkgmngrs/install_cargo.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh)
    else
       . $TOP/cli-tools/pkgmngrs/install_cargo.sh
    fi
fi

if ! [[ -f ~/.cargo/bin/zellij ]]; then 
    eval "${pac_rm_y} zellij" 
    cargo install --locked zellij
fi

readyn -p "Install zellij config file at $XDG_CONFIG_HOME/zellij?" -n -c "! [[ -f $XDG_CONFIG_HOME/zellij/config.kbl ]]" ansr
if [[ "$ansr" == 'y' ]]; then
    mkdir -p $XDG_CONFIG_HOME/zellij
    zellij setup --dump-config > $XDG_CONFIG_HOME/zellij/config.kdl
fi
unset ansr
