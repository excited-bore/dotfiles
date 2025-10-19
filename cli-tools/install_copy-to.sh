hash copy-to &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if ! hash copy-to &> /dev/null; then
    if ! hash pipx &> /dev/null ; then
        if ! test -f $TOP/cli-tools/pkgmngrs/install_pipx.sh; then
            source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_pipx.sh)
        else
            . $TOP/cli-tools/pkgmngrs/install_pipx.sh
        fi
    fi

    if [[ $upg_pipx == 'y' ]]; then
        $HOME/.local/bin/pipx install copy-to
    else
        pipx install copy-to
    fi
fi


if hash copy-to &> /dev/null; then
    copy-to -h
else
    printf "Something went wrong installing\n"
fi
