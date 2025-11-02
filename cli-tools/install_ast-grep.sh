# https://github.com/ast-grep/ast-grep

hash ast-grep &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if ! hash ast-grep &>/dev/null; then
    if ! hash cargo &>/dev/null || ! [[ $PATH =~ '/.cargo/bin' ]]; then
        if ! test -f $TOP/cli-tools/pkgmngrs/install_cargo.sh; then
            source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh)
        else
            . $TOP/cli-tools/pkgmngrs/install_cargo.sh
        fi
    fi

    cargo install ast-grep

    if test -d ~/.bash_completion.d/ && ! test -f ~/.bash_completion.d/ast-grep; then
        echo "$(ast-grep completions bash)" >~/.bash_completion.d/ast-grep
    fi

    if test -d ~/.zsh_completion.d/site-functions && ! test -f ~/.zsh_completion.d/site-functions/ast-grep; then
        echo "$(ast-grep completions zsh)" >~/.zsh_completion.d/site-functions/ast-grep
    fi
fi

eval "ast-grep --help | $PAGER"
