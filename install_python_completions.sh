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
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi
if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi

if ! type activate-global-python-argcomplete &> /dev/null; then
    if test $distro_base == "Debian"; then
        sudo apt install python3 python-is-python3
    elif test $distro_base == "Arch"; then
        sudo pacman -S python
    fi
fi

if ! type pipx &> /dev/null; then
   if ! test -f install_pipx.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)" 
    else
        ./install_pipx.sh
    fi 
fi

if ! test -z $upg_pipx && test $upg_pipx == 'y'; then
    $HOME/.local/bin/pipx install argcomplete
else
    pipx install argcomplete
fi

if type activate-global-python-argcomplete &> /dev/null; then
    activate-global-python-argcomplete --dest=/home/$USER/.bash_completion.d 
elif type activate-global-python-argcomplete3 &> /dev/null; then
    activate-global-python-argcomplete3 --dest=/home/$USER/.bash_completion.d 
fi
    
#if ! grep -q "python-argcomplete" ~/.bashrc; then
#    echo ". ~/.bash_completion.d/_python-argcomplete" >> ~/.bashrc
#fi

#reade -Q "YELLOW" -i "y" -p "Install python completion system wide? (/root/.bashrc) [Y/n]: " "n" arg
#if [ "y" == "$arg" ]; then 
#    if type activate-global-python-argcomplete &> /dev/null; then
#        sudo activate-global-python-argcomplete --dest=/root/.bash_completion.d
#    elif type activate-global-python-argcomplete3 &> /dev/null; then
#        sudo activate-global-python-argcomplete3 --dest=/root/.bash_completion.d
#    fi
#    #if ! sudo grep -q "python-argcomplete" /root/.bashrc; then
#    #    printf "\n. ~/.bash_completion.d/_python-argcomplete" | sudo tee -a /root/.bashrc
#    #fi
#fi
