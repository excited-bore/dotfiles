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

if ! test -f ~/.exrc; then
    readyn -p "Install exrc (ex config) at $HOME?"  nsrc
    if [[ $nsrc == 'y' ]]; then
        cp -fv ex/.exrc ~/.exrc
    fi
fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) will check for /root/.nanorc";
if ! sudo test -f /root/.nanorc; then
    readyn -p 'Install exrc (ex config) at /root?' nsrc
    if [[ $nsrc == 'y' ]]; then
        sudo cp -fv ex/.exrc /root/.exrc
    fi
fi
