#/bin/bash

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

SCRIPT_DIR=$(pwd)


reade -Q "GREEN" -i "mergiraf fac meld kdiff3" -p "Which to install? [Mergiraf/fac(fixallconflicts)/meld/kdiff3]: " merger
if [[ $merger == 'fac' ]] ;then
    if ! type go &> /dev/null; then
        if ! test -f install_go.sh; then
            if type curl &>/dev/null; then
                source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh)
            else
                printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                return 1 || exit 1
            fi
        else
            . ./install_go.sh
        fi
    fi
    go install github.com/mkchoi212/fac@latest 
elif [[ $merger == 'mergiraf' ]] ;then
    if ! type cargo &> /dev/null; then
        if ! test -f install_cargo.sh; then
            if type curl &>/dev/null; then
                source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
            else
                printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                return 1 || exit 1
            fi
        else
            . ./install_cargo.sh
        fi
    fi
    cargo install --locked mergiraf
elif [[ $merger == 'meld' ]] ;then
    if [[ $machine == 'Mac' ]]; then
        if ! type brew &> /dev/null; then
            if ! test -f install_brew.sh; then
                if type curl &>/dev/null; then
                    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_brew.sh)
                else
                    printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                    return 1 || exit 1
                fi
            else
                . ./install_brew.sh
            fi
        fi
        brew install meld 
    elif [[ $distro_base == 'Debian' ]]; then
        sudo apt install meld
    elif [[ $distro_base == 'Arch' ]]; then
        sudo pacman -S meld
    elif [[ $distro == 'Fedora' ]] || [[ $distro == 'RedHat' ]]; then
        sudo dnf install meld 
    else
        if ! type pipx &> /dev/null; then
            if ! test -f install_pipx.sh; then
                if type curl &>/dev/null; then
                    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)
                else
                    printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                    return 1 || exit 1
                fi
            else
                . ./install_pipx.sh
            fi
        fi
        pipx install meld
    fi
elif [[ $merger == 'kdiff3' ]] ;then
    if ! type kdiff3 &> /dev/null; then
        if [[ $distro_base == 'Debian' ]]; then
            sudo apt install kdiff3
        elif [[ $distro_base == 'Arch' ]]; then
            sudo pacman -S kdiff3
        elif [[ $machine == 'Linux' ]]; then
            if ! test -f install_flatpak.sh; then
                if type curl &>/dev/null; then
                    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)
                else
                    printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
                    return 1 || exit 1
                fi
            else
                . ./install_flatpak.sh
            fi
            flatpak install kdiff3 
        fi 
    fi
fi
