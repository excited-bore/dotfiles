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

if ! type fd &> /dev/null; then
    if [[ $distro_base == "Arch" ]]; then
        eval "$pac_ins fd"
    elif [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins fd-find"
        if ! test -f ~/.local/bin/fd; then
            ln -s $(which fdfind) ~/.local/bin/fd
        fi
    fi
fi

# TODO: Make better check: https://github.com/sharkdp/fd
if type fd-find &> /dev/null || type fd &> /dev/null; then
    echo "${green}Fd can read from global gitignore file${normal}"
    readyn -n -p "Generate global gitignore using 'themed' templates? (https://github.com/github/gitignore)" fndgbl
    if [[ $fndgbl == 'y' ]]; then
        if ! test -f install_gitignore.sh; then
            b=$(mktemp)
            curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_gitignore.sh | tee "$b" &> /dev/null
            chmod u+x "$b"
            eval "$b" "global"
            unset b
        else
            ./install_gitignore.sh "global"
        fi 
    fi
fi


