# !/bin/bash

. ./readline/rlwrap_scripts.sh


reade -Q "GREEN" -i "y" -p "Download gitignore, choose and install? ( Categorized Templates ) [Y/n]: " "y n" gitgn 
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
    while [ ! "$gitign" == "Stop" ]; do
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
            comp="Toggle Stop $(ls *.gitignore)"
            reade -Q "CYAN" -p "Wich templates need to be installed? ( 'Toggle' to switch between global and case specific temps / Ctrl-C or 'Stop' to abort): " "$comp"  gitign
            if [ -f "$gitign" ]; then
                printf "\n\n#\n# $gitign\n#\n\n\n" | tr 'a-z' 'A-Z' >> "$ignfl"
                cat "$gitign" | tee -a "$ignfl"
                rm "$gitign"
                printf "$gitign added to $ignfl\n"
            fi
        fi
    done)
    unset gitign comp1 comp2 globl
fi
rm -rf $TEMPDIR/gitignore
$EDITOR $ignfl
