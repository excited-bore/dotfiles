#!/bin/bash
. ./readline/rlwrap_scripts.sh
curl -sS https://starship.rs/install.sh | sh
if ! grep -q "starship" ~/.bashrc; then
    reade -Q "GREEN" -i "y" -p "Install starship for user? [Y/n]:" "y n" strship
    if [ "y" == "$strship" ]; then
        echo "eval \"\$(starship init bash)\"" >> ~/.bashrc
        . ./checks/check_completions_dir.sh
        starship completions bash > ~/.bash_completion.d/starship
        if [ -d ~/.bash_aliases.d/ ]; then
            cp -bfv aliases/starship.sh ~/.bash_aliases.d/
            gio trash ~/.bash_aliases.d/starship.sh~
        fi
    fi
fi
unset strship

if ! sudo grep -q "starship" /root/.bashrc; then
    reade -Q "YELLOW" -i "y" -p "Install starship for root? [Y/n]:" "y n" strship
    if [ "y" == "$strship" ]; then
        printf "eval \"\$(starship init bash)\"\n" | sudo tee -a /root/.bashrc
        . ./checks/check_completions_dir.sh
        sudo touch /root/.bash_completion.d/starship
        starship completions bash | sudo tee -a /root/.bash_completion.d/starship > /dev/null  
        if [ -d /root/.bash_aliases.d/ ]; then
            sudo cp -bfv aliases/starship.sh /root/.bash_aliases.d/
            sudo gio trash ~/.bash_aliases.d/starship.sh~
        fi
    fi
fi
unset strship

source ~/.bashrc
