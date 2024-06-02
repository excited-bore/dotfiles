#!/bin/bash
if ! test -f aliases/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi

curl -sS https://starship.rs/install.sh | sh 

reade -Q "GREEN" -i "y" -p "Install starship for user? [Y/n]:" "y n" strship
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
        cp -bfv aliases/starship.sh ~/.bash_aliases.d/
        if test -f ~/.bash_aliases.d/starship.sh~; then 
            gio trash ~/.bash_aliases.d/starship.sh~
        fi
    fi
fi
unset strship

reade -Q "YELLOW" -i "y" -p "Install starship for root? [Y/n]:" "y n" strship
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
        sudo cp -bfv aliases/starship.sh /root/.bash_aliases.d/
        if test -f /root/.bash_aliases.d/starship.sh~; then
            sudo gio trash ~/.bash_aliases.d/starship.sh~
        fi
    fi
fi
unset strship

source ~/.bashrc
starship-presets
