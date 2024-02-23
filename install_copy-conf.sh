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

reade -Q "GREEN" -i "y" -p "Install copy-to? (Python tool for copying between 2 maps) [Y/n]:" "y n" cpcnf
if [ -z $compl ] || [ "y" == $compl ]; then
    if [ ! -x "$(command -v pipx)" ]; then
        if [ $distro_base == "Arch" ]; then
            yes | sudo pacman -Su python-pipx
        elif [ $distro_base == "Debian" ]; then
            yes | sudo apt install pipx
        fi
    fi
fi
pipx install copy-to
copy-to -h
