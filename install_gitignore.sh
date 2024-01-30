# !/bin/bash

. ./aliases/rlwrap_scripts.sh


reade -Q "GREEN" -i "y" -p "Download template gitignores, choose and install? [Y/n]: " "y n" gitgn 
if [ "y" == "$gitgn" ]; then
    git clone https://github.com/github/gitignore $TMPDIR/gitignore
    
    reade -Q "GREEN" -i "local" -p "Install globally or locally? ( ./ vs ~/.config/git/ignore ) [Local/global]: " "global local" globl
    if [ "$globl" == "global" ]; then
       if [ ! -d ~/.config/git/ ]; then
           mkdir ~/.config/git/ 
        fi
        if [ ! -f ~/.config/git/ignore ]; then
           touch ~/.config/git/ignore
        fi
        ignfl=~/.config/git/ignore
    else
        if [ ! -f .gitignore ]; then
           touch .gitignore
        fi
        ignfl=.gitignore
    fi

    (
    cd $TMPDIR/gitignore
    gitign=""
    if [ "$globl" == "global" ]; then
        cd Global
    fi
    while [ ! "$gitign" == "Stop" ] && [ ! "$gitign" == "AllGlobal" ] ; do
        if [ "$gitign" == "Toggle" ]; then
            if [ $(pwd) == $TMPDIR/gitignore ]; then
                cd $TMPDIR/gitignore/Global
                printf "To global templates\n" 
            else
                cd $TMPDIR/gitignore
                printf "To normal templates\n"
            fi
            unset gitign
        else
            comp="AllGlobal Toggle Stop $(ls *.gitignore)"
            reade -Q "CYAN" -p "Wich templates need to be installed? ( 'AllGlobal', 'Toggle' to switch between global and case specific temps and Ctrl-C / 'Stop' to abort): " "$comp"  gitign
            if [ -f "$gitign" ]; then
                printf "\n\n#\n# ${gitign}\n#\n\n\n" | tr 'a-z' 'A-Z' >> "$ignfl"
                unalias cat
                cat "$gitign" | tee -a "$ignfl"
                printf "$gitign added to $ignfl\n"
            fi
        fi
    done
    if [ "$gitign" == "AllGlobal" ]; then
        echo "" > "$ignfl"
        cd $TMPDIR/gitignore/Global
        FILES=$PWD/*
        for ign in $FILES; do
            printf "\n\n#\n# ${ign}\n#\n\n\n" | tr 'a-z' 'A-Z' >> "$ignfl"
            cat "$ign" | tee -a "$ignfl"
            printf "$ign added to $ignfl\n"
            unset $ign
        done
    fi)
    unset gitign comp1 comp2 globl
fi
$EDITOR $ignfl
