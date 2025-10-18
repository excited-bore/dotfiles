hash neofetch &>/dev/null || hash fastfetch &>/dev/null || hash screenFetch &>/dev/null && SYSTEM_UPDATED="TRUE"

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! hash neofetch &>/dev/null && ! hash fastfetch &>/dev/null && ! hash screenFetch &>/dev/null; then
    #readyn -p "Install neofetch/fastfetch/screenFetch? "" sym2
    #if [[ "$sym2" == "y" ]]; then

    reade -Q "CYAN" -i "fast neo screen" -p "Which one? [Fast/neo/screen]: " sym2
    if [[ "$sym2" == "neo" ]]; then
        if [["$distro_base" == "Debian" || "$distro_base" == "Arch" ]]; then
            eval "${pac_ins_y}" neofetch
        fi

        if ! test -f ~/.config/neofetch/config.conf; then
            if test -f neofetch/.config/neofetch/config.conf; then
                file=neofetch/.config/neofetch/config.conf
            else
                dir1="$(mktemp -d -t tmux-XXXXXXXXXX)"
                wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/neofetch/.config/neofetch/config.conf > $dir1/config.conf
                file=$dir1/config.conf
            fi

            function neofetch_conf() {
                mkdir -p ~/.config/neofetch
                cp $file ~/.config/neofetch/
            }
            yes-edit-no -f neofetch_conf -g "$file" -p "Install neofetch config.conf at $HOME/.config/neofetch/?"
            neofetch
        fi
    elif [[ "$sym2" == "fast" ]]; then
        if [[ $distro_base == "Debian" ]]; then
            if ! hash jq &>/dev/null; then
                eval "${pac_ins_y}" jq
            fi
            if [[ $arch =~ "arm" ]]; then
                fetch_arch="armv7l"
            elif [[ $arch =~ "x86_64" ]]; then
                fetch_arch="aarch64"
            elif [[ $arch =~ "amd64" ]]; then
                fetch_arch="amd64"
            fi
            os="linux"
            ltstv=$(wget-curl https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq -r ".tag_name")
            tmp=$(mktemp -d)
            wget-aria-dir $tmp https://github.com/fastfetch-cli/fastfetch/releases/download/$ltstv/fastfetch-$os-$fetch_arch.deb
            sudo dpkg -i $tmp/fastfetch-$os-$fetch_arch.deb
        elif [[ $distro_base == "Arch" ]]; then
            eval "${pac_ins_y}" fastfetch
        fi
        fastfetch
    elif [[ "$sym2" == "screen" ]]; then
        if [[ $distro_base == "Debian" ]] || [[ $distro_base == "Arch" ]]; then
            eval "${pac_ins_y}" screenfetch
        fi
        screenfetch
    fi
fi

if ! hash onefetch &>/dev/null; then
    readyn -p "Install onefetch? (lists github stats like lines of codes)" nftch
    if [[ $nftch == 'y' ]]; then
        if [[ $distro_base == 'Arch' ]]; then
            eval "${pac_ins_y}" onefetch
        elif [[ $distro_base == 'Debian' ]]; then
            if ! hash add-apt-repository &> /dev/null; then     
                if ! test -f pkgmngrs/install_ppa.sh; then
                    source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_ppa.sh)
                else
                    . pkgmngrs/install_ppa.sh
                fi
                if ! test -f ../aliases/.aliases.d/package_managers.sh; then
                    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.aliases.d/package_managers.sh)
                else
                    . ../aliases/.aliases.d/package_managers.sh
                fi
            fi 
            if hash add-apt-repository &>/dev/null && [[ $(check-ppa ppa:o2sh/onefetch) =~ 'OK' ]]; then
                sudo add-apt-repository ppa:o2sh/onefetch
                eval "${pac_up_y}"
                eval "${pac_ins_y}" onefetch
            fi
        elif [[ "$distro" == 'Fedora' ]]; then
            sudo dnf copr enable varlad/onefetch
            sudo dnf install onefetch
        elif [[ "$distro" == 'alpine' ]]; then
            apk update
            apk add onefetch
        elif [[ $machine == 'Mac' ]] && hash brew &>/dev/null; then
            brew install onefetch
        elif [[ $machine == 'Windows' ]]; then
            winget install onefetch
        elif type nix-env &>/dev/null; then
            nix-env -i onefetch
        else
            if ! test -f pkgmngrs/install_cargo.sh; then
                source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh)
            else
                . pkgmngrs/install_cargo.sh
            fi
            cargo install onefetch
        fi
        onefetch
    fi
fi
