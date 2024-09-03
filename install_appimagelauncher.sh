#!/usr/bin/env bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_appimage_ready.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_appimage_ready.sh)" 
else
    . ./checks/check_appimage_ready.sh
fi

if ! test -f aliases/.bash_aliases.d/package_managers.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh)" 
else
    source aliases/.bash_aliases.d/package_managers.sh
fi


if ! type AppImageLauncher &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install Appimagelauncher"
    if test $distro == "Arch" || test $distro == "Manjaro"; then 
        sudo pacman -S appimagelauncher
    elif test $distro_base == "Debian"; then
        if type add-apt-repository &> /dev/null; then
            if [[ $(check-ppa -c ppa:lakinduakash/lwh) =~ 'OK' ]]; then
                sudo add-apt-repository ppa:appimagelauncher-team/stable
                sudo apt-get update
                sudo apt-get install appimagelauncher 
            else
                #if ! $(apt search libfuse2t64 &> /dev/null); then
                #    sudo apt install libfuse2t64 -y 
                #fi
                if ! $(apt search jq &> /dev/null); then
                    sudo apt install jq -y 
                fi
                tmpd=$(mktemp -d)
                tag=$(curl -sL https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | jq -r ".tag_name") 
                ltstv=$(curl -sL https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | jq -r ".assets" | grep --color=never "name" | sed 's/"name"://g' | tr '"' ' ' | tr ',' ' ' | sed 's/[[:space:]]//g')
                code_name='bionic' 
                if [[ $release < 16.04 ]] || [[ $release == 16.04 ]]; then
                    code_name='xenial'
                fi
                file=$(echo "$ltstv" | grep --color=never $code_name"_"$arch) 
                curl -o $tmpd/appimagelauncher.deb https://github.com/TheAssassin/AppImageLauncher/releases/download/$tag/$file
                sudo dpkg -i $tmpd/appimagelauncher.deb 
                sudo apt --fix-broken install -y
                sudo systemctl restart systemd-binfmt 
                unset tmpd tag ltstv code_name file 
            fi
        fi 
    fi
fi

