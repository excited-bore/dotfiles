#!/bin/bash

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

if ! type docker &> /dev/null; then
    if [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins docker.io"
        sudo apt remove docker docker-engine 
        curl https://get.docker.com | sh
        printf "${cyan}Log out and log in again${normal}, execute ${cyan}'groups'${normal} and check if ${cyan}'docker'${normal} in there.\n Else, execute ${GREEN}'sudo usermod -aG docker $USER'${normal}\n"
    elif [[ $distro == "Arch" ]]; then
        eval "$pac_ins docker"
        printf "${cyan}Log out and log in again${normal}, execute ${cyan}'groups'${normal} and check if ${cyan}'docker'${normal} in there.\n Else, execute ${GREEN}'sudo usermod -aG docker $USER'${normal}\n"
    fi
fi
