hash ast-grep &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! hash ast-grep &>/dev/null; then
    if ! hash cargo &>/dev/null || ! [[ $PATH =~ '/.cargo/bin' ]]; then
        if ! test -f pkgmngrs/install_cargo.sh; then
            source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh)
        else
            . pkgmngrs/install_cargo.sh
        fi
    fi

    cargo install ast-grep

    if ! test -f ~/.bash_completion.d/ast-grep.bash; then
        echo "$(ast-grep completions bash)" >~/.bash_completion.d/ast-grep.bash
    fi

    if ! test -f ~/.zsh_completion.d/ast-grep.zsh; then
        echo "$(ast-grep completions zsh)" >~/.zsh_completion.d/ast-grep.zsh
    fi
fi

eval "ast-grep --help | $PAGER"
