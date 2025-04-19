#!/bin/bash

if ! test -f checks/check_all.sh; then
     if type curl &> /dev/null; then
           eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"
     else
         continue
     fi
 else
     . ./checks/check_all.sh
 fi

printf "An AUR installer / pacman wrapper is needed.${CYAN}yay${normal} is recommended for this\n"
readyn -p "Install yay?" insyay
if [[ "y" == "$insyay" ]]; then
    if type curl &>/dev/null && ! test -f $SCRIPT_DIR/AUR_installers/install_yay.sh; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_yay.sh)
    else
        . $SCRIPT_DIR/AUR_installers/install_yay.sh
    fi
    AUR_pac="yay"
    AUR_up="yay -Syu"
    AUR_ins="yay -S"
    AUR_search="yay -Ss"
    AUR_ls_ins="yay -Q"
fi

