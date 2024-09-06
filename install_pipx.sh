# !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi


if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi


if ! type pipx &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install pipx? (for installing packages outside of virtual environments) [Y/n]: " "n" insppx
    if test $insppx == "y"; then
        if test $machine == 'Mac' && type brew &> /dev/null; then
            echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
            brew install python python-pipx
            if [[ $(pipx --version) < 1.6.0 ]]; then 
                pipx install pipx
                brew uninstall pipx 
                source ~/.local/bin/ 
            fi
        elif test $distro_base == "Arch"; then 
            echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
            sudo pacman -S python-pipx
            if [[ $(pipx --version) < 1.6.0 ]]; then 
                pipx install pipx
                sudo pacman -Rs pipx 
                source ~/.local/bin/pipx 
            fi
        elif test $distro_base == "Debian"; then
            echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
            sudo apt install pipx
            if [[ $(pipx --version) < 1.6.0 ]]; then 
                pipx install pipx
                sudo apt purge --autoremove pipx 
                source ~/.local/bin/pipx 
            fi 
        fi
        pipx ensurepath
        if ! test $machine == 'Windows'; then 
            reade -Q "GREEN" -i "y" -p "Set to install packages globally (including for root)? [Y/n]: " "n" insppxgl
            if test $insppxgl == "y"; then 
                if [[ $(whereis pipx) =~ $HOME/.local/bin ]]; then
                    sudo env PATH=$PATH:$HOME/.local/bin pipx ensurepath --global
                fi
                sudo pipx --global ensurepath 
            fi
        fi 
    fi
fi

