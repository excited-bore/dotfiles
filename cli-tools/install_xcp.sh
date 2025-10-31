# https://github.com/tarka/xcp

hash xcp &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if ! hash xcp &> /dev/null; then
    if ! hash cargo &> /dev/null || ! [[ $PATH =~ '/.cargo/bin' ]] ; then
        if ! test -f $TOP/cli-tools/pkgmngrs/install_cargo.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh)
        else
            . $TOP/cli-tools/pkgmngrs/install_cargo.sh
        fi
    fi
    cargo install xcp
fi
xcp --help | $PAGER 
