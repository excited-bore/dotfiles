#!/usr/bin/env bash

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
    reade -Q "CYAN" -i "y" -p "Update system? [Y/n]: " "n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type fd &> /dev/null; then
    if test $distro == "Arch" || test $distro == "Manjaro"; then
        eval "$pac_ins fd"
    elif [ $distro_base == "Debian" ]; then
        eval "$pac_ins fd-find"
        if ! test -f ~/.local/bin/fd; then
            ln -s $(which fdfind) ~/.local/bin/fd
        fi
    fi
fi

# TODO: Make better check: https://github.com/sharkdp/fd
if type fd-find &> /dev/null || type fd &> /dev/null; then
    echo "${green}Fd can read from global gitignore file${normal}"
    reade -Q "YELLOW" -i "n" -p "Generate global gitignore using 'themed' templates? (https://github.com/github/gitignore) [N/y]: " "y" fndgbl
    if [ $fndgbl == 'y' ]; then
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


