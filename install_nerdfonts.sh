#!/bin/bash

hash jq &>/dev/null &&
    SYSTEM_UPDATED='TRUE'

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

if ! test -f aliases/.bash_aliases.d/git.sh; then
    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh)
else
    . ./aliases/.bash_aliases.d/git.sh
fi

if ! [ -d ~/.local/share/fonts ]; then
    mkdir ~/.local/share/fonts
fi

if ! type jq &>/dev/null; then
    eval "$pac_ins jq"
fi

fonts=$(mktemp -d)
get-latest-releases-github https://github.com/ryanoasis/nerd-fonts $fonts/
#wget -P "$fonts" https://github.com/vorillaz/devicons/archive/master.zip

if [[ "$(ls $fonts/*)" ]]; then
    [[ "$(ls $fonts/*.zip 2> /dev/null)" ]] &&
        unzip $fonts/*.zip -d $fonts &&
        rm $fonts/*.zip

    [[ "$(ls $fonts/*.tar.xz 2> /dev/null)" ]] &&
        tar -xf $fonts/*.tar.xz -C $fonts &&
        rm $fonts/*.tar.xz

    mv $fonts/* ~/.local/share/fonts
    sudo fc-cache -fv
fi

#ltstv=$(curl -sL "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | jq -r ".tag_name")
#wget -P "$fonts" https://github.com/ryanoasis/nerd-fonts/releases/download/$ltstv/Hermit.zip
#unzip $fonts/Hermit.zip -d $fonts
