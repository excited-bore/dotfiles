#!/usr/bin/env bash
# Install Butterfish
# Author: Peter Bakkum

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type go &> /dev/null; then
    echo "Go is not installed. Installing Go..."
    if ! test -f install_go.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
    else
        . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
    fi
fi


go install github.com/bakks/butterfish/cmd/butterfish@latest

echo "Go to https://platform.openai.com/account/api-keys to get your OpenAI API key."
echo "Then put it in ~/.config/butterfish/buttefish.env, like so:"
echo "OPENAI_TOKEN=sk-foobar"
readyn -p "Edit ~/.config/buttefish/buttefish.env now?" response
if [ "$response" == "y" ]; then
    mkdir -p ~/.config/butterfish
    touch ~/.config/butterfish/butterfish.env
    printf "OPENAI_TOKEN=" > ~/.config/butterfish/butterfish.env
    $EDITOR ~/.config/butterfish/butterfish.env
fi
