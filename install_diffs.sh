. ./checks/check_distro.sh
. ./aliases/rlwrap_scripts.sh

if test $distro_base == "Arch"; then
    reade -Q "GREEN" -i "delta" -p "Which diff to install? [Delta/diff-so-fancy/ydiff/difftastic]: " "diff-so-fancy delta ydiff difftastic" difftool ;
    if test $difftool == "diff-so-fancy"; then
        sudo pacman -Su diff-so-fancy
    elif test $difftool == "delta"; then
        sudo pacman -Su git-delta
    elif test $difftool == "ydiff"; then
        sudo pacman -Su pipx
        pipx install --upgrade ydiff
    elif test $difftool == "difftastic"; then
        sudo pacman -Su difftastic
    fi
elif test $distro_base == "Debian"; then
    reade -Q "GREEN" -i "delta" -p "Which diff to install? [Delta/diff-so-fancy/ydiff/difftastic]: " "diff-so-fancy delta ydiff difftastic" difftool;
    if test $difftool == "diff-so-fancy"; then
        sudo apt install npm
        sudo npm -g install diff-so-fancy 
    elif test $difftool == "delta"; then
        sudo apt install Debdelta
    elif test $difftool == "ydiff"; then
        sudo apt install pipx
        pipx install --upgrade ydiff
    elif test $difftool == "difftastic"; then
        if [[ $arch =~ "arm" ]]; then
            sudo apt install cargo
            cargo install --locked difftastic
        else
            . ./install_homebrew.sh
            brew install difftastic
        fi
    fi
    
fi
unset difftool
