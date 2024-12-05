if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi 

if ! type thefuck &> /dev/null; then
    if test $machine == 'Mac' && type brew &> /dev/null; then
        brew install thefuck
    elif test $distro == 'Arch'; then
        sudo pacman -S thefuck 
    elif type pkg &> /dev/null; then
        pkg install thefuck
    elif type crew &> /dev/null; then
        crew install thefuck
    else
        if ! type pipx &> /dev/null; then
            if ! test -f install_pipx.sh; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)"
            else
                ./install_pipx.sh
            fi
            if test -f $HOME/.local/bin/pipx && ! type pipx &> /dev/null; then
                $HOME/.local/bin/pipx install --upgrade thefuck
            elif type pipx &> /dev/null; then
                pipx install --upgrade thefuck
            fi
        fi
    fi
fi

if ! grep -q 'eval $(thefuck --alias' ~/.bashrc; then
    reade -Q 'GREEN' -i 'f' -p "Alias for name 'thefuck'? [Empty: 'f' - 'thefuck' cant be used]: " 'fuck fuk hell heck hek egh huhn huh nono again agin asscreamIscream' ansr
    if test $ansr == 'thefuck'; then
        printf "'thefuck' cant be aliased to 'thefuck'\n" 
        printf "Using 'f' as alias\n"
        ansr='f'
    fi
    
    if ! test -z $ansr; then
        printf "eval \$(thefuck --alias $ansr)\n" >> ~/.bashrc  
    fi
    unset ansr 
fi
