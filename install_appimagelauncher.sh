#!/usr/bin/env bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type checks/check_appimage_ready.sh &> /dev/null; then
    if ! test -f checks/check_appimage_ready.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_appimage_ready.sh)" 
    else
        . ./checks/check_appimage_ready.sh
    fi
fi

if ! type AppImageLauncher &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install Appimagelauncher"
    if test $distro == "Arch" || test $distro == "Manjaro"; then 
        sudo pacman -S appimagelauncher
    elif test $distro_base == "Debian"; then
        if test $distro == 'Ubuntu'; then
            stable="devel disco eoan focal groovy hirsuite impish jammy kinetic" 
            if "[[ $(lsb_release -a)" =~ "$stable" ]]; then
                sudo add-apt-repository ppa:appimagelauncher-team/stable
            else
                if ! $(apt search libfuse2t64 &> /dev/null); then
                    sudo apt install libfuse2t64 -y 
                fi
                if ! $(apt search jq &> /dev/null); then
                    sudo apt install jq -y 
                fi
                tmpd=$(mktemp -d)
                tag=$(curl -sL https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | jq -r ".tag_name") 
                ltstv=$(curl -sL https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | jq -r ".assets" | grep --color=never "name" | sed 's/"name"://g' | tr '"' ' ' | tr ',' ' ' | sed 's/[[:space:]]//g')
                code_name='xenial'
                if [[ $release < 16.04 ]] || [[ $release == 16.04 ]]; then
                    code_name='bionic'
                fi
                file=$(echo "$ltstv" | grep --color=never $code_name"_"$arch) 
                wget -O $tmpd/appimagelauncher.deb https://github.com/TheAssassin/AppImageLauncher/releases/download/$tag/$file
                sudo dpkg -i $tmpd/appimagelauncher.deb 
                sudo apt --fix-broken install -y
                sudo systemctl restart systemd-binfmt 
                #sudo add-apt-repository ppa:appimagelauncher-team/daily
                unset tmpd tag ltstv code_name file 
            fi
            sudo apt-get update
            sudo apt-get install appimagelauncher 
        fi 
    fi
fi

