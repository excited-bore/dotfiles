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

if ! test -f checks/check_appimage_ready.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_appimage_ready.sh)
else
    . ./checks/check_appimage_ready.sh
fi

if ! test -f aliases/.bash_aliases.d/package_managers.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh)
else
    source aliases/.bash_aliases.d/package_managers.sh
fi

if ! type AppImageLauncher &>/dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install Appimagelauncher"
    if [[ $distro_base == "Arch" ]]; then
        if test -z "$AUR_ins"; then
            if ! test -f checks/check_AUR.sh; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
            else
                source checks/check_AUR.sh
            fi
        fi

        eval "$AUR_ins appimagelauncher"

    elif [[ $distro_base == "Debian" ]]; then
        if type add-apt-repository &>/dev/null && [[ $(check-ppa ppa:appimagelauncher-team/stable) =~ 'OK' ]]; then
            sudo add-apt-repository ppa:appimagelauncher-team/stable
            eval "$pac_up"
            eval "$pac_ins appimagelauncher"
        else
            #if ! $(apt search libfuse2t64 &> /dev/null | awk 'NR>2 {print;}'); then
            #    eval "$pac_ins libfuse2t64 -y "
            #fi
            if ! $(apt search jq &>/dev/null | awk 'NR>2 {print;}'); then
                eval "$pac_ins_y jq "
            fi
            tmpd=$(mktemp -d)
            tag=$(curl https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | jq -r ".tag_name")
            ltstv=$(curl https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | jq -r ".assets" | grep --color=never "name" | sed 's/"name"://g' | tr '"' ' ' | tr ',' ' ' | sed 's/[[:space:]]//g')
            code_name='bionic'
            if ! test -z && [[ $release < 16.04 ]] || [[ $release == 16.04 ]]; then
                code_name='xenial'
            fi
            file=$(echo "$ltstv" | grep --color=never $code_name"_"$arch)

            wget-aria-dir $tmpd https://github.com/TheAssassin/AppImageLauncher/releases/download/$tag/$file
            sudo dpkg -i $tmpd/$file
            sudo apt --fix-broken install -y
            sudo systemctl restart systemd-binfmt
            unset tmpd tag ltstv code_name file
        fi
    fi
fi
