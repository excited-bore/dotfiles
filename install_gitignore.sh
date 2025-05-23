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
local gitign comp1 comp2 globl

gitignd=$(mktemp -d)
globl="local"
if [[ "$1" == 'local' ]] || [[ 'global' == "$1" ]]; then
    git clone https://github.com/github/gitignore $gitignd/gitignore
    globl="$1"
else
    readyn -p "Download template gitignores, choose and install?" gitgn 
    if [[ "y" == "$gitgn" ]]; then
        git clone https://github.com/github/gitignore $gitignd/gitignore
        reade -Q "GREEN" -i "local global" -p "Install globally or locally? ( ./ vs ~/.config/git/ignore ) [Local/global]: " globl
    fi
    if [[ "$globl" == "global" ]]; then
       if ! [ -d ~/.config/git/ ]; then
           mkdir ~/.config/git/ 
        fi
        if ! [ -f ~/.config/git/ignore ]; then
           touch ~/.config/git/ignore
        fi
        ignfl=~/.config/git/ignore
    else
        if ! [ -f .gitignore ]; then
           touch .gitignore
        fi
        ignfl=.gitignore
    fi

    (cd $gitignd/gitignore
    gitign=''
    if [[ "$globl" == "global" ]]; then
        cd Global
    fi
    while ! [[ "$gitign" == "Stop" ]] && ! [[ "$gitign" == "AllGlobal" ]] ; do
        if [[ "$gitign" == "Toggle" ]]; then
            if [[ $(pwd) == $gitignd/gitignore ]]; then
                cd $gitignd/gitignore/Global
                printf "To global templates\n" 
            else
                cd $gitignd/gitignore
                printf "To normal templates\n"
            fi
            unset gitign
        else
            comp="AllGlobal Toggle Stop $(ls *.gitignore)"
            reade -Q "CYAN" -i "$comp" -p "Which templates need to be installed? ( 'AllGlobal', 'Toggle' to switch between global and case specific temps and Ctrl-C / 'Stop' to abort): "  gitign
            if [ -f "$gitign" ]; then
                printf "\n\n#\n# $(basename ${gitign})\n#\n\n\n" | tr 'a-z' 'A-Z' >> "$ignfl"
                unalias cat
                cat "$gitign" | tee -a "$ignfl"
                printf "$gitign added to $ignfl\n"
            fi
        fi
    done
    if [[ "$gitign" == "AllGlobal" ]]; then
        echo "" > "$ignfl"
        cd $gitignd/gitignore/Global
        FILES=$PWD/*
        for ign in $FILES; do
            printf "\n\n#\n# $(basename ${ign})\n#\n\n\n" | tr 'a-z' 'A-Z' >> "$ignfl"
            cat "$ign" | tee -a "$ignfl"
            printf "$ign added to $ignfl\n"
            unset $ign
        done
    fi)
    $EDITOR $ignfl
fi
