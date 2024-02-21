if ! test -f checks/check_distro.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro.sh)" 
else
    . ./checks/check_distro.sh
fi

if ! test -f aliases/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi

reade -Q "GREEN" -i "y" -p "Install lazygit? (Git gui) [Y/n]: " "y n" nstll
if [ "$nstll" == "y" ]; then
    if [ $distro == "Arch" ] || [ $distro_base == "Arch" ]; then
        yes | sudo pacman -Su lazygit
    elif [ $distro == "Debian" ] || [ $distro_base == "Debian" ]; then
        yes | sudo apt update
        yes | sudo apt install lazygit
    fi
    
fi
unset nstll

if ! type copy-to &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install copy-to? [Y/n]: " "y n" cpcnf;
    if [ "y" == "$cpcnf" ] || [ -z "$cpcnf" ]; then
        if ! test -f install_copy-conf.sh; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_copy-conf.sh)"
        else
            ./install_copy-conf.sh
        fi
    fi
fi

reade -Q "GREEN" -i "y" -p "Set up an alias so copy-to does a 'run all' when starting up lazygit? [Y/n]: " "y n" nstll
if [ "$nstll" == "y" ]; then
    if ! test -f checks/check_aliases_dir.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)" 
    else
       . ./checks/check_aliases_dir.sh
    fi
    if ! test -f ~/.bash_aliases.d/lazygit.sh; then 
        printf "alias lazygit=\"copy-to run all && lazygit\"\n" > ~/.bash_aliases.d/lazygit.sh
        echo "File in ~/.bash_aliases.d/lazygit.sh"
    fi
fi
unset nstll
