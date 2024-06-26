#!/bin/bash
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
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if ! type curl &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Curl necessary for curl. Install curl? [Y/n]:" "y n" tojump
    if [ "$tojump" == "y" ]; then
        if test $distro == "Arch" || test $distro == "Manjaro";then
            sudo pacman -S curl
        elif test $distro_base == "Debian"; then
            sudo apt install curl
        fi
    fi
    unset tojump
fi

# https://unix.stackexchange.com/questions/690233/piping-yes-when-running-scripts-from-curl
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -y -f

reade -Q "GREEN" -i "y" -p "Install starship.sh for user? [Y/n]: " "n" strship
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
    if [ -d ~/.bash_aliases.d/ ]; then
        if test -f aliases/.bash_aliases.d/starship.sh; then
            cp -bfv aliases/.bash_aliases.d/starship.sh ~/.bash_aliases.d/
        else
            wget -O ~/.bash_aliases.d/starship.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/starship.sh
        fi

        if test -f ~/.bash_aliases.d/starship.sh~; then 
            gio trash ~/.bash_aliases.d/starship.sh~
        fi
    fi
fi
unset strship

reade -Q "YELLOW" -i "y" -p "Install starship.sh for root? [Y/n]: " "n" strship
if [ "y" == "$strship" ]; then
    if ! sudo grep -q "starship" /root/.bashrc; then
        printf "eval \"\$(starship init bash)\"\n" | sudo tee -a /root/.bashrc &> /dev/null
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
            sudo wget -O /root/.bash_aliases.d/starship.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/starship.sh
        fi 
        if test -f /root/.bash_aliases.d/starship.sh~; then
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
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    starship-presets
fi
