. ./checks/check_distro.sh
. ./aliases/rlwrap_scripts.sh
. ./checks/check_keybinds.sh
./install_AUR-helper.sh

if [ ! -x "$(command -v autojump)" ]; then
    reade -Q "GREEN" -i "y" -p "Install autojump? [Y/n]:" "y n" tojump
    if [ "$tojump" == "y" ]; then
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
    fi
fi

# If you want Ctrl-j, read this first: 
# https://bestasciitable.com/
reade -Q "GREEN" -i "y" -p "Install autojump keybind at Ctrl-x for user? [Y/n]:" "y n" bnd
if [ "$bnd" == "y" ]; then
    if grep -q 'bind '\''"\\C-x": "j \\C-i"'\''' $KEYBIND; then
        sed -i 's|.*\(bind .*\C-x": "j.*\)|\1|g' $KEYBIND
    else
        printf '# Ctrl-x is for autojump\nbind '\''"\C-x": "j \C-i"'\''\n' >> $KEYBIND
    fi
fi

reade -Q "YELLOW" -i "y" -p "Install autojump keybind at Ctrl-x for root? [Y/n]:" "y n" bnd_r
if [ "$bnd" == "y" ]; then
    if sudo grep -q 'bind '\''"\\C-x": "j \\C-i"'\''' $KEYBIND_R; then
        sudo sed -i 's|.*\(bind .*\C-x": "j.*\)|\1|g'  $KEYBIND_R
    else
        printf '# Ctrl-x is for autojump\nbind '\''"\C-x": "j \C-i"'\''\n' | sudo tee -a $KEYBIND_R
    fi
fi

unset tojump bnd bnd_r
