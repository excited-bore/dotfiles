# !/bin/bash

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

if ! type copy-to &> /dev/null; then
    if ! type pipx &> /dev/null ; then
        if ! test -f install_pipx.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)
        else
            . ./install_pipx.sh
        fi
    fi

    if [[ $upg_pipx == 'y' ]]; then
        $HOME/.local/bin/pipx install copy-to
    else
        pipx install copy-to
    fi
fi


if type copy-to &> /dev/null; then
    copy-to -h
else
    printf "Something went wrong installing\n"
fi
