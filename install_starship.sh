#!/usr/bin/env bash
if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
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

if ! type curl &> /dev/null; then
    readyn -p "Curl necessary for curl. Install curl?" tojump
    if [ "$tojump" == "y" ]; then
        if test $distro == "Arch" || test $distro == "Manjaro";then
            eval "$pac_ins curl"
        elif test $distro_base == "Debian"; then
            eval "$pac_ins curl"
        fi
    fi
    unset tojump
fi

# https://unix.stackexchange.com/questions/690233/piping-yes-when-running-scripts-from-curl
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -y -f

readyn -p "Install starship.sh for user?" strship
if [ "y" == "$strship" ]; then
    if ! grep -q "starship" ~/.bashrc; then
        echo "eval \"\$(starship init bash)\"" >> ~/.bashrc
    fi
    if ! test -f checks/check_completions_dir.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
    else
        . ./checks/check_completions_dir.sh
    fi
    starship completions bash > ~/.bash_completion.d/starship
    #if grep -q '[ -f .bash_preexec ]' ~/.bashrc; then
    #    sed -i '/eval "$(starship init bash)"/d' ~/.bashrc
    #    sed -i 's|\(\[ -f ~/.bash_preexec \] \&\& source \~/.bash_preexec\)|\neval "$(starship init bash)"\n\1\n|g' ~/.bashrc 
    #fi
    if [ -d ~/.bash_aliases.d/ ]; then
        if test -f aliases/.bash_aliases.d/starship.sh; then
            cp -bfv aliases/.bash_aliases.d/starship.sh ~/.bash_aliases.d/
        else
            curl -o ~/.bash_aliases.d/starship.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/starship.sh
        fi

        if type gio &> /dev/null && test -f ~/.bash_aliases.d/starship.sh~; then 
            gio trash ~/.bash_aliases.d/starship.sh~
        fi
    fi
fi
unset strship

readyn -p "Install starship.sh for root?" strship
if [ "y" == "$strship" ]; then
    if ! sudo grep -q "starship" /root/.bashrc; then
        printf "eval \"\$(starship init bash)\"\n" | sudo tee -a /root/.bashrc &> /dev/null
        #if sudo grep -q '[ -f .bash_preexec ]' /root/.bashrc; then
            #sudo sed -i '/eval "$(starship init bash)"/d' /root/.bashrc
            #sudo sed -i 's|\(\[ -f ~/.bash_preexec \] \&\& source \~/.bash_preexec\)|\neval "$(starship init bash)"\n\1\n|g' /root/.bashrc 
        #else
        #fi
    fi
    
    if ! test -f checks/check_completions_dir.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
    else
        . ./checks/check_completions_dir.sh
    fi
    sudo touch /root/.bash_completion.d/starship
    starship completions bash | sudo tee -a /root/.bash_completion.d/starship > /dev/null  
    if [ -d /root/.bash_aliases.d/ ]; then
        if test -f aliases/.bash_aliases.d/starship.sh; then
            sudo cp -bfv aliases/.bash_aliases.d/starship.sh /root/.bash_aliases.d/
        else
            sudo curl -o /root/.bash_aliases.d/starship.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/starship.sh
        fi 
        if type gio &> /dev/null && test -f /root/.bash_aliases.d/starship.sh~; then
            sudo gio trash ~/.bash_aliases.d/starship.sh~
        fi
    fi
fi
unset strship

eval "$(starship init bash)"

if ! test -f aliases/.bash_aliases.d/starship.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/starship.sh)" 
else
    . ./aliases/.bash_aliases.d/starship.sh
fi

if type fzf &> /dev/null; then
    starship-presets
elif ! type fzf &> /dev/null && test -f ~/.fzf.bash; then
    echo "No fzf found!!" 
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    starship-presets
fi
