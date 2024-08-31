if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! test -f ~/.bash_preexec.sh; then
    wget https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash_preexec 
fi

if grep -q '~/.envvars.env' ~/.bashrc; then
    if grep -q "[ -f ~/.envvars.env ]" ~/.bashrc; then
         sed -i 's|\(\[ -f ~/.envvars.env \] \&\& source \~/.envvars.env\)|\[ -f ~/.bash_preexec \] \&\& source ~/.bash_preexec\n\1\n\n|g' ~/.bashrc
    elif grep -q "[ -f ~/.bash_completion ]" ~/.bashrc; then
         sed -i 's|\(\[ -f ~/.bash_completion \] \&\& source \~/.bash_completion\)|\[ -f ~/.bash_preexec \] \&\& source ~/.bash_preexec\n\n\1\n|g' ~/.bashrc
    elif grep -q "[ -f ~/.bash_aliases ]" ~/.bashrc; then
         sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\[ -f ~/.bash_preexec \] \&\& source ~/.bash_preexec\n\n\1\n|g' ~/.bashrc
    elif grep -q "[ -f ~/.keybinds ]" ~/.bashrc; then
         sed -i 's|\(\[ -f ~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f ~/.bash_preexec \] \&\& source ~/.bash_preexec\n\n\1\n|g' ~/.bashrc
    else
        printf "\n[ -f ~/.envvars.env ] && source ~/.envvars.env\n\n" >> ~/.bashrc
    fi
fi

if test -d /root/; then
    reade -Q 'GREEN' -i 'y' -p 'Install pre-execution hooks for /root as well? [Y/n]: ' bash_r
    if test $bash_r == 'y'; then
        if ! test -f /root/.bash_preexec.sh; then
            sudo wget https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o /root/.bash_preexec 
        fi
        if sudo grep -q '/root/.envvars.env' /root/.bashrc; then
            if sudo grep -q "[ -f /root/.envvars.env ]" /root/.bashrc; then
               sudo sed -i 's|\(\[ -f /root/.envvars.env \] \&\& source \/root/.envvars.env\)|\[ -f /root/.bash_preexec \] \&\& source /root/.bash_preexec\n\1\n\n|g' /root/.bashrc
            elif sudo grep -q "[ -f /root/.bash_completion ]" /root/.bashrc; then
                 sudo sed -i 's|\(\[ -f /root/.bash_completion \] \&\& source \/root/.bash_completion\)|\[ -f /root/.bash_preexec \] \&\& source /root/.bash_preexec\n\n\1\n|g' /root/.bashrc
            elif sudo grep -q "[ -f /root/.bash_aliases ]" /root/.bashrc; then
                 sudo sed -i 's|\(\[ -f /root/.bash_aliases \] \&\& source \/root/.bash_aliases\)|\[ -f /root/.bash_preexec \] \&\& source /root/.bash_preexec\n\n\1\n|g' /root/.bashrc
            elif sudo grep -q "[ -f /root/.keybinds ]" /root/.bashrc; then
                 sudo sed -i 's|\(\[ -f /root/.keybinds \] \&\& source \/root/.keybinds\)|\[ -f /root/.bash_preexec \] \&\& source /root/.bash_preexec\n\n\1\n|g' /root/.bashrc
            else
                printf "\n[ -f /root/.envvars.env ] && source /root/.envvars.env\n\n" | sudo tee -a /root/.bashrc
            fi
        fi
    fi
    unset bash_r 
fi
