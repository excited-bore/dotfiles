if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi
if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi

if ! type activate-global-python-argcomplete &> /dev/null; then
    if test $distro_base == "Debian"; then
        sudo apt install python3 pipx
        pipx install argcomplete
    elif test $distro == "Arch" || test $distro == "Manjaro"; then
        sudo pacman -S python python-pipx
        pipx install argcomplete
    fi
fi

if type activate-global-python-argcomplete &> /dev/null; then
    activate-global-python-argcomplete --dest=/home/$USER/.bash_completion.d 
elif type activate-global-python-argcomplete3 &> /dev/null; then
    activate-global-python-argcomplete3 --dest=/home/$USER/.bash_completion.d 
fi
    
#if ! grep -q "python-argcomplete" ~/.bashrc; then
#    echo ". ~/.bash_completion.d/_python-argcomplete" >> ~/.bashrc
#fi

reade -Q "YELLOW" -i "y" -p "Install python completion system wide? (/root/.bashrc) [Y/n]: " "n" arg
if [ "y" == "$arg" ]; then 
    if type activate-global-python-argcomplete &> /dev/null; then
        sudo activate-global-python-argcomplete --dest=/root/.bash_completion.d
    elif type activate-global-python-argcomplete3 &> /dev/null; then
        sudo activate-global-python-argcomplete3 --dest=/root/.bash_completion.d
    fi
    #if ! sudo grep -q "python-argcomplete" /root/.bashrc; then
    #    printf "\n. ~/.bash_completion.d/_python-argcomplete" | sudo tee -a /root/.bashrc
    #fi
fi
