#!/bin/bash

if ! grep -q "/usr/share/bash-completion/bash_completion" ~/.bashrc; then
    echo "[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion" >> ~/.bashrc
fi

if [ ! -d ~/.bash_completion.d/ ]; then
    mkdir ~/.bash_completion.d/
fi

if ! grep -q "~/.bash_completion" ~/.bashrc; then
    echo "if [ -f ~/.bash_completion ]" >> ~/.bashrc
    echo "  . ~/.bash_completion" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_completion.d' in /root and source it with '/root/.bash_completion' "

if ! sudo grep -q "/usr/share/bash-completion/bash_completion" ~/.bashrc; then
    printf "[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion\n" | sudo tee -a //root/.bashrc
fi

if ! sudo test -d /root/.bash_completion.d/ ; then
    sudo mkdir /root/.bash_completion.d/
fi

if ! sudo grep -q "~/.bash_completion" /root/.bashrc; then
    printf "\nif [ -f ~/.bash_completion/ ]; then\n    . ~/.bash_completion\nfi\n" | sudo tee -a /root/.bashrc > /dev/null
fi

if test -f ~/.bash_aliases && ! grep -q 'complete_alias' ~/.bash_aliases; then
    if ! test -f install_bashalias_completions.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashalias_completions.sh)" 
    else
        . ./install_bashalias_completions.sh
    fi
fi
