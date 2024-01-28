#!/bin/bash
. ./readline/rlwrap_scripts.sh
curl -sS https://starship.rs/install.sh | sh
if ! grep -q "starship" ~/.bashrc; then
    reade -Q "GREEN" -i "y" -p "Install starship for user? (Fancy coloured prompt) [Y/n]:" "y n" strship
    if [ "y" == "$strship" ]; then
        echo "eval \"\$(starship init bash)\"" >> ~/.bashrc
    fi
fi
unset strship

if ! sudo grep -q "starship" /root/.bashrc; then
    reade -Q "YELLOW" -i "y" -p "Install starship for root? (Fancy coloured prompt) [Y/n]:" "y n" strship
    if [ "y" == "$strship" ]; then
        printf "eval \"\$(starship init bash)\"\n" | sudo tee -a /root/.bashrc
    fi
fi
unset strship
