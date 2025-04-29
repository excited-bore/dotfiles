#!/usr/bin/env bash
# Install Butterfish
# Author: Peter Bakkum

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

if ! type go &> /dev/null; then
    echo "Go is not installed. Installing Go..."
    if ! test -f install_go.sh; then
         source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh) 
    else
        . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
    fi
fi


go install github.com/bakks/butterfish/cmd/butterfish@latest

echo "Go to https://platform.openai.com/account/api-keys to get your OpenAI API key."
echo "Then put it in ~/.config/butterfish/buttefish.env, like so:"
echo "OPENAI_TOKEN=sk-foobar"
readyn -p "Edit ~/.config/buttefish/buttefish.env now?" response
if [[ "$response" == "y" ]]; then
    mkdir -p ~/.config/butterfish
    touch ~/.config/butterfish/butterfish.env
    printf "OPENAI_TOKEN=" > ~/.config/butterfish/butterfish.env
    $EDITOR ~/.config/butterfish/butterfish.env
fi
