#!/usr/bin/env bash

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

get-script-dir SCRIPT_DIR

if ! type neofetch &>/dev/null && ! type fastfetch &>/dev/null && ! type screenFetch &>/dev/null; then
    #readyn -p "Install neofetch/fastfetch/screenFetch? "" sym2
    #if test "$sym2" == "y"; then

    reade -Q "CYAN" -i "fast neo screen" -p "Which one? [Fast/neo/screen]: " sym2
    if [[ "$sym2" == "neo" ]]; then
        if [["$distro_base" == "Debian" ]] || [[ "$distro_base" == "Arch" ]]; then
            eval "${pac_ins}" neofetch
        fi

        if ! test -f ~/.config/neofetch/config.conf; then
            if test -f neofetch/.config/neofetch/config.conf; then
                file=neofetch/.config/neofetch/config.conf
            else
                dir1="$(mktemp -d -t tmux-XXXXXXXXXX)"
                curl -s -o $dir1/config.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/neofetch/.config/neofetch/config.conf
                file=$dir1/config.conf
            fi

            function neofetch_conf() {
                mkdir -p ~/.config/neofetch
                cp -fbv $file ~/.config/neofetch/
            }
            yes-no-edit -f neofetch_conf -g "$file" -p "Install neofetch config.conf at $HOME/.config/neofetch/?" -i "y" -Q "GREEN"
        fi
    elif [[ "$sym2" == "fast" ]]; then
        if [[ $distro_base == "Debian" ]]; then
            if ! type jq &>/dev/null; then
                eval "${pac_ins}" jq
            fi
            if [[ $arch =~ "arm" ]]; then
                fetch_arch="armv7l"
            elif [[ $arch =~ "x86_64" ]]; then
                fetch_arch="aarch64"
            elif [[ $arch =~ "amd64" ]]; then
                fetch_arch="amd64"
            fi
            os="linux"
            ltstv=$(curl -sL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq -r ".tag_name")
            tmp=$(mktemp -d)
            wget -P $tmp https://github.com/fastfetch-cli/fastfetch/releases/download/$ltstv/fastfetch-$os-$fetch_arch.deb
            sudo dpkg -i $tmp/fastfetch-$os-$fetch_arch.deb
        elif [[ $distro_base == "Arch" ]]; then
            eval "${pac_ins}" fastfetch
        fi
    elif [[ "$sym2" == "screen" ]]; then
        if [[ $distro_base == "Debian" ]] || [[ $distro_base == "Arch" ]]; then
            eval "${pac_ins}" screenfetch
        fi
    fi
fi

if ! type onefetch &>/dev/null; then
    readyn -p "Install onefetch? (lists github stats like lines of codes)" nftch
    if [[ $nftch == 'y' ]]; then
        if [[ $distro_base == 'Arch' ]]; then
            eval "${pac_ins}" onefetch
        elif [[ $distro_base == 'Debian' ]] && type add-apt-repository &>/dev/null && [[ $(check-ppa ppa:o2sh/onefetch) =~ 'OK' ]]; then
            sudo add-apt-repository ppa:o2sh/onefetch
            eval "${pac_up}"
            eval "${pac_ins}" onefetch
        elif [[ "$distro" == 'Fedora' ]]; then
            sudo dnf copr enable varlad/onefetch
            sudo dnf install onefetch
        elif [[ "$distro" == 'alpine' ]]; then
            apk update
            apk add onefetch
        elif [[ $machine == 'Mac' ]] && type brew &>/dev/null; then
            brew install onefetch
        elif [[ $machine == 'Windows' ]]; then
            winget install onefetch
        elif type nix-env &>/dev/null; then
            nix-env -i onefetch
        else
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
            cargo install onefetch
        fi
    fi
fi
