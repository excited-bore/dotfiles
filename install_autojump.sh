if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi 
if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi
if ! test -f checks/check_keybinds.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_keybinds.sh)" 
else
    . ./checks/check_keybinds.sh
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

if type autojump &> /dev/null; then
    if [ "$distro" == "Manjaro" ]; then
        pamac install autojump
    elif test "$distro" == "Arch" && ! test -z "$AUR_install"; then
        eval "$AUR_install" autojump
    elif [ $distro_base == "Debian" ]; then
        sudo apt install autojump                                                              
    fi
fi

if ! grep -q "autojump" ~/.bashrc; then
    printf "[ -s /etc/profile.d/autojump.sh ] && source /etc/profile.d/autojump.sh\n" >> ~/.bashrc
&> /dev/null
fi
if ! sudo grep -q "autojump" /root/.bashrc; then
    printf "[ -s /etc/profile.d/autojump.sh ] && source /etc/profile.d/autojump.sh\n" | sudo tee -a /root/.bashrc &> /dev/null
fi

# If you want Ctrl-j, read this first: 
# https://bestasciitable.com/
reade -Q "GREEN" -i "y" -p "Install autojump keybind at Ctrl-x j for user? [Y/n]: " "n" bnd
if [ "$bnd" == "y" ]; then
    if grep -q 'j \\C-i' $KEYBIND; then
        sed -i 's|.*\(bind .*\C-x\\C-j": "j.*\)|\1|g' $KEYBIND
    else
        printf '# Ctrl-x Ctrl-j for autojump\nbind -m emacs-standard '\''"\C-x\C-j": "j \C-i"'\''\nbind -m vi-command     '\''"\C-x\C-j": "j \C-i"'\''\nbind -m vi-insert      '\''"\C-x\C-j": "j \C-i"'\''\n' >> $KEYBIND &> /dev/null
    fi
fi

reade -Q "YELLOW" -i "y" -p "Install autojump keybind at Ctrl-x j for root? [Y/n]: " "n" bnd_r
if [ "$bnd" == "y" ]; then
    if sudo grep -q 'j \\C-i' $KEYBIND_R; then
        sudo sed -i 's|.*\(bind .*\C-x\C-j": "j.*\)|\1|g'  $KEYBIND_R
    else
        printf '# Ctrl-x Ctrl-j for autojump\nbind -m emacs-standard '\''"\C-x\C-j": "j \C-i"'\''\nbind -m vi-command     '\''"\C-x\C-j": "j \C-i"'\''\nbind -m vi-insert      '\''"\C-x\C-j": "j \C-i"'\''\n' | sudo tee -a $KEYBIND_R &> /dev/null
    fi
fi

unset tojump bnd bnd_r
