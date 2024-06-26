if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi


if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi


if ! type lazygit &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install lazygit? (Git gui) [Y/n]: " "y n" nstll
    if [ "$nstll" == "y" ]; then
        if test $distro == "Arch" || test $distro == "Manjaro"; then
            sudo pacman -S lazygit
        elif [ $distro == "Ubuntu" ]; then
            if ! type curl &> /dev/null; then
                sudo apt install curl
            fi
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po --color=never '"tag_name": "v\K[^"]*')
            curl -Lo $TMPDIR/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            (cd $TMPDIR && tar xf $TMPDIR/lazygit.tar.gz) 
            sudo install $TMPDIR/lazygit /usr/local/bin
        fi
        lazygit --version
        
    fi
    unset nstll
fi

if ! type copy-to &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install copy-to? [Y/n]: " "y n" cpcnf;
    if [ "y" == "$cpcnf" ] || [ -z "$cpcnf" ]; then
        if ! test -f install_copy-to.sh; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_copy-to.sh)"
        else
            ./install_copy-to.sh
        fi
    fi
fi

if ! test -d ~/.bash_aliases.d/ || ! test -f ~/.bash_aliases.d/lazygit.sh || (test -f ~/.bash_aliases.d/lazygit.sh && ! grep -q "copy-to" ~/.bash_aliases.d/lazygit.sh); then
    reade -Q "GREEN" -i "y" -p "Set up an alias so copy-to does a 'run all' when starting up lazygit? [Y/n]: " "y n" nstll
    if [ "$nstll" == "y" ]; then
        if ! test -f checks/check_aliases_dir.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)" 
        else
           . ./checks/check_aliases_dir.sh
        fi
        if ! test -f ~/.bash_aliases.d/lazygit.sh; then 
            printf "alias lazygit=\"copy-to run all; lazygit\"\n" > ~/.bash_aliases.d/lazygit.sh
            echo "$(tput setaf 2)File in ~/.bash_aliases.d/lazygit.sh"
        fi
    fi
    unset nstll
fi
unset nstll
