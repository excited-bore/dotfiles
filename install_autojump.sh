. ./checks/check_distro.sh
. ./aliases/rlwrap_scripts.sh
. ./checks/check_keybinds.sh
./install_AUR-helper.sh

    
if [ $distro == "Manjaro" ]; then
    pamac install autojump
elif [ $distro_base == "Debian" ]; then
    yes | sudo apt install autojump
fi
if ! grep "autojump" ~/.bashrc; then
    printf "[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh\n" >> ~/.bashrc
fi
if ! sudo grep "autojump" /root/.bashrc; then
    printf "[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh\n" | sudo tee -a /root/.bashrc
fi

# If you want Ctrl-j, read this first: 
# https://bestasciitable.com/
reade -Q "GREEN" -i "y" -p "Install autojump keybind at Ctrl-x j for user? [Y/n]:" "y n" bnd
if [ "$bnd" == "y" ]; then
    if grep -q 'bind .*'\''"\\C-x j": "j'\''' $KEYBIND; then
        sed -i 's|.*\(bind .*\C-x j": "j.*\)|\1|g' $KEYBIND
    else
        printf '# Ctrl-x j for autojump\nbind -m emacs-standard '\''"\C-x j": "j \C-i"'\''\nbind -m vi-command     '\''"\C-x j": "j \C-i"'\''\nbind -m vi-insert      '\''"\C-x j": "j \C-i"'\''\n' >> $KEYBIND
    fi
fi

reade -Q "YELLOW" -i "y" -p "Install autojump keybind at Ctrl-x j for root? [Y/n]:" "y n" bnd_r
if [ "$bnd" == "y" ]; then
    if sudo grep -q 'bind .* '\''"\\C-x j": "j'\''' $KEYBIND_R; then
        sudo sed -i 's|.*\(bind .*\C-x j": "j.*\)|\1|g'  $KEYBIND_R
    else
        printf '# Ctrl-x j for autojump\nbind -m emacs-standard '\''"\C-x j": "j \C-i"'\''\nbind -m vi-command     '\''"\C-x j": "j \C-i"'\''\nbind -m vi-insert      '\''"\C-x j": "j \C-i"'\''\n' | sudo tee -a $KEYBIND_R
    fi
fi

unset tojump bnd bnd_r
