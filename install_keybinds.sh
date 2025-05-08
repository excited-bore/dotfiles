if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

# Shell-keybinds

binds=$SCRIPT_DIR/keybinds/.inputrc
binds1=$SCRIPT_DIR/keybinds/.keybinds.d/keybinds.bash
binds2=$SCRIPT_DIR/keybinds/.keybinds
if ! test -f $binds; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.inputrc
    tmp1=$(mktemp) && curl -o $tmp1 https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds.d/keybinds.bash
    tmp2=$(mktemp) && curl -o $tmp2 https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds
    binds=$tmp
    binds1=$tmp1
    binds2=$tmp2
fi

if ! test -f /etc/inputrc; then
    sed -i 's/^$include \/etc\/inputrc/#$include \/etc\/inputrc/g' $binds
fi

shell-keybinds_r() {
    if test -f /root/.environment; then
        sudo sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' /root/.environment
    fi
    sudo cp -f $binds1 /root/.keybinds.d/
    sudo cp -f $binds2 /root/.keybinds
    sudo cp -f $binds /root/
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether '~/.keybinds' is sourced in /root/.bashrc"
    if test -f /root/.bashrc && ! grep -q '[ -f /root/.keybinds ]' /root/.bashrc; then
        if sudo grep -q '[ -f /root/.bash_aliases ]' /root/.bashrc; then
            sudo sed -i 's|\(\[ -f \/root/.bash_aliases \] \&\& source \/root/.bash_aliases\)|\1\n\[ -f \/root/.keybinds \] \&\& source \/root/.keybinds\n|g' /root/.bashrc
        else
            printf '[ -f ~/.keybinds ] && source ~/.keybinds' | sudo tee -a /root/.bashrc &>/dev/null
        fi
    fi

    # X based settings is generally not for root and will throw errors
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether 'setxkbmap *' is part of /root/.keybinds.d/keybinds.bash and comment this line out to prevent errors"
    if sudo grep -q '^setxkbmap' /root/.keybinds.d/keybinds.bash; then
        sudo sed -i 's|^setxkbmap|#setxkbmap|g' /root/.keybinds.d/keybinds.bash
    fi
}

shell-keybinds() {
    if ! test -f $SCRIPT_DIR/checks/check_keybinds.sh; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_keybinds.sh)
    else
        . $SCRIPT_DIR/checks/check_keybinds.sh
    fi

    printf "${cyan}You can always switch between vi/emacs mode with ${CYAN}Ctrl-o${normal}\n"

    readyn -Y "CYAN" -p "Startup in ${MAGENTA}vi-mode${CYAN} instead of ${GREEN}emacs${CYAN} mode? (might cause issues with pasteing)" vimde

    sed -i "s|^set editing-mode .*|#set editing-mode vi|g" $binds

    if [[ "$vimde" == "y" ]]; then
        sed -i "s|.set editing-mode .*|set editing-mode vi|g" $binds
    fi

    sed -i "s|^set show-mode-in-prompt .*|#set show-mode-in-prompt on|g" $binds

    readyn -p "Enable visual que for vi/emacs toggle? (Displayed as '(ins)/(cmd) - (emacs)')" vivisual
    if [[ "$vivisual" == "y" ]]; then
        sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
    fi

    sed -i "s|^setxkbmap |#setxkbmap |g" $binds

    if [[ $X11_WAY == 'x11' ]]; then
        readyn -p "Set caps to escape? (Might cause X11 errors with SSH)" xtrm
        if [[ "$xtrm" = "y" ]]; then
            sed -i "s|#setxkbmap |setxkbmap |g" $binds
        fi
    fi

    cp -f $binds1 ~/.keybinds.d/
    cp -f $binds2 ~/.keybinds
    cp -f $binds ~/

    if test -f ~/.bashrc && ! grep -q '~/.keybinds' ~/.bashrc; then
        if grep -q '\[ -f ~/.bash_aliases \]' ~/.bashrc; then
            sed -i 's|\(\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\1\n\n\[ -f \~/.keybinds \] \&\& source \~/.keybinds\n|g' ~/.bashrc
        else
            echo '[ -f ~/.keybinds ] && source ~/.keybinds' >>~/.bashrc
        fi
    fi

    if [ -f ~/.environment ]; then
        sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' ~/.environment
    fi
    unset vimde vivisual xterm
    yes-edit-no -Y "YELLOW" -f shell-keybinds_r -g "$binds $binds2 $binds1" -p "Install .inputrc and keybinds.bash at /root/ and /root/.keybinds.d/?"
}

yes-edit-no -f shell-keybinds -g "$binds $binds2 $binds1" -p "Install .inputrc and keybinds.bash at ~/ and ~/.keybinds.d/? (keybinds configuration)"

