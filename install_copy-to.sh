# !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f aliases/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi

reade -Q "GREEN" -i "y" -p "Install copy-to? (Python tool for copying between 2 maps) [Y/n]:" "y n" cpcnf
if [ -z $compl ] || [ "y" == $compl ]; then
    if ! type pipx &> /dev/null ; then
        if test $distro == "Arch" || test $distro == "Manjaro"; then
            sudo pacman -S python-pipx
        elif [ $distro_base == "Debian" ]; then
            sudo apt install pipx
        fi
    fi
fi
pipx install copy-to
copy-to -h
