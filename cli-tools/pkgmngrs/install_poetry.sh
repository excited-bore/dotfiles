# https://github.com/python-poetry/poetry

hash poetry &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../../checks/check_all.sh
fi

if ! hash pipx &> /dev/null; then
   if ! test -f install_pipx.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_pipx.sh)
    else
        . install_pipx.sh
    fi
fi

if ! test -f ../../checks/check_completions_dir.sh; then
     source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)
else
    . ../../checks/check_completions_dir.sh
fi


if ! hash poetry &> /dev/null; then
    pipx install poetry
    pipx upgrade poetry
fi

if ! test -f ~/.bash_completion.d/poetry.bash; then
    poetry completions bash >> ~/.bash_completion.d/poetry.bash
fi

if ! test -f ~/.zsh_completion.d/poetry.zsh; then
    poetry completions zsh >> ~/.zsh_completion.d/poetry.zsh
fi

