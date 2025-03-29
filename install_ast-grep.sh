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

get-script-dir SCRIPT_DIR

if ! type ast-grep &>/dev/null; then
    if ! type cargo &>/dev/null; then
        if ! test -f install_cargo.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
        else
            . ./install_cargo.sh
        fi
    fi

    cargo install ast-grep

    if ! test -f ~/.bash_aliases.d/ast-grep; then
        echo "$(ast-grep completions bash)" >~/.bash_completion.d/ast-grep
    fi
fi
