# !/bin/bash
if ! test -f checks/check_distro.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro.sh)" 
else
    . ./checks/check_distro.sh
fi

if ! test -f aliases/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi

if ! type pip &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pip"
    if test $distro_base == "Arch"; then 
        yes | sudo pacman -Su python-pip
    elif test $distro_base == "Debian"; then
        yes | sudo apt install python3-pip
    fi
fi



if ! type pipx &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install pipx? (for installing packages outside of virtual environments) [Y/n]:" "y n" insppx
    if test $insppx == "y"; then
        echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
        if test $distro_base == "Arch"; then 
            yes | sudo pacman -Su python-pipx
            pipx ensurepath
            reade -Q "GREEN" -i "y" -p "Set to install packages globally (including for root)? [Y/n]:" "y n" insppxgl
            if test $insppxgl == "y"; then 
                sudo pipx ensurepath --global
            fi
        elif test $distro_base == "Debian"; then
            yes | sudo apt install python3-pip
            pipx ensurepath
            sudo pipx ensurepath --global
            reade -Q "GREEN" -i "y" -p "Set to install packages globally (including for root)? [Y/n]:" "y n" insppxgl
            if test $insppxgl == "y"; then 
                sudo pipx ensurepath --global
            fi
        fi
    fi
fi
