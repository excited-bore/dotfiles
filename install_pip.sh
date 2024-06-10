# !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
    update_system
else
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi

if ! type pip &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pip"
    if test $distro == "Arch" || test $distro == "Manjaro"; then 
        sudo pacman -S python-pip
    elif test $distro_base == "Debian"; then
        sudo apt install python3-pip
    fi
fi



if ! type pipx &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install pipx? (for installing packages outside of virtual environments) [Y/n]:" "y n" insppx
    if test $insppx == "y"; then
        echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
        if test $distro == "Arch" || test $distro == "Manjaro"; then 
            sudo pacman -S python-pipx
            pipx ensurepath
            reade -Q "GREEN" -i "y" -p "Set to install packages globally (including for root)? [Y/n]:" "y n" insppxgl
            if test $insppxgl == "y"; then 
                sudo pipx ensurepath --global
            fi
        elif test $distro_base == "Debian"; then
            sudo apt install python3-pip
            pipx ensurepath
            sudo pipx ensurepath --global
            reade -Q "GREEN" -i "y" -p "Set to install packages globally (including for root)? [Y/n]:" "y n" insppxgl
            if test $insppxgl == "y"; then 
                sudo pipx ensurepath --global
            fi
        fi
    fi
fi
