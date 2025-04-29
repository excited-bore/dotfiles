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

if ! [ -d  ~/.local/share/fonts ]; then
    mkdir ~/.local/share/fonts
fi

if ! type jq &> /dev/null; then
    elif [[ $distro_base == "Debian" ]] || [[ $distro_base == "Arch" ]]; then
        eval "$pac_ins jq"
    fi
fi
fonts=$(mktemp -d)
wget -P "$fonts" https://github.com/vorillaz/devicons/archive/master.zip 
unzip $fonts/master.zip -d $fonts
ltstv=$(curl -sL "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | jq -r ".tag_name")
wget -P "$fonts" https://github.com/ryanoasis/nerd-fonts/releases/download/$ltstv/Hermit.zip
unzip $fonts/Hermit.zip -d $fonts
rm -f $fonts/master.zip $fonts/Hermit.zip
mv $fonts/* ~/.local/share/fonts
sudo fc-cache -fv
