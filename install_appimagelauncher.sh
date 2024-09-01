#!/usr/bin/env bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type checks/check_appimage_ready.sh &> /dev/null; then
    if ! test -f checks/check_appimage_ready.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_appimage_ready.sh)" 
    else
        . ./checks/check_appimage_ready.sh
    fi
fi

if ! type AppImageLauncher &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install Appimagelauncher"
    if test $distro == "Arch" || test $distro == "Manjaro"; then 
        sudo pacman -S appimagelauncher
    elif test $distro_base == "Debian"; then
        sudo add-apt-repository ppa:appimagelauncher-team/stable
        sudo apt-get update
        sudo apt-get install appimagelauncher 
    fi
fi

