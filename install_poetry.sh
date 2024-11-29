#!/bin/bash

if type curl &> /dev/null && ! type pipx &> /dev/null; then
   if ! test -f install_pipx.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)" 
    else
        ./install_pipx.sh
    fi 
fi

if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi


if ! type poetry &> /dev/null; then
    pipx install poetry
    pipx upgrade poetry 
fi

if ! test -f ~/.bash_completion.d/poetry; then
    touch ~/.bash_completion.d/poetry 
    poetry completions bash >> ~/.bash_completion.d/poetry
fi
