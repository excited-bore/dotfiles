 # !/bin/bash
. ./checks/check_system.sh
. ./checks/check_pathvar.sh 
. ./aliases/rlwrap_scripts.sh

 # Ranger (File explorer)
 if [ -x "$(command -v ranger)" ]; then
     if [ $distro_base == "Arch" ];then
        yes | sudo pacman -Su ranger python python-pipx
    elif [ $distro_base == "Debian" ]; then    
        yes | sudo apt install ranger python3 python3-dev pipx
    fi
fi

# Remove message ('Removed /tmp/ranger_cd54qzd') after quitting ranger
if [ -f /usr/bin/ranger ] && ! grep -q 'rm -f -- "$temp_file" 2>/dev/null' /usr/bin/ranger; then
   sudo sed -i 's|rm -f -- "$temp_file"|rm -f -- "$temp_file" 2>/dev/null|g' /usr/bin/ranger; 
fi

# Remove message ('Removed /tmp/ranger_cd54qzd') after quitting ranger
if [ -f /home/burp/.local/bin/ranger ] && ! grep -q 'rm -f -- "$temp_file" 2>/dev/null' /home/burp/.local/bin/ranger; then
   sudo sed -i 's|rm -f -- "$temp_file"|rm -f -- "$temp_file" 2>/dev/null|g' /home/burp/.local/bin/ranger; 
fi


#ranger --copy-config=all
ranger --confdir=/home/$USER/.config/ranger --copy-config=all
if [ "$PATHVAR" == ~/.pathvariables.env ]; then
    sed -i 's|#export RANGER_LOAD_DEFAULT_RC=|export RANGER_LOAD_DEFAULT_RC=|g' $PATHVAR
    sudo sed -i 's|#export RANGER_LOAD_DEFAULT_RC=|export RANGER_LOAD_DEFAULT_RC=|g' $PATHVAR_R
else
    echo "export RANGER_LOAD_DEFAULT_RC=FALSE" >> $PATHVAR
    printf "export RANGER_LOAD_DEFAULT_RC=FALSE\n" | sudo tee -a $PATHVAR_R
fi
if [ -d ~/.bash_aliases.d/ ]; then
    cp -bfv ./aliases/ranger.sh ~/.bash_aliases.d/ranger.sh
    gio trash ~/.bash_aliases.d/ranger.sh~
fi


rangr_cnf() {
    if ! [ -d ~/.config/ranger/ ]; then 
        mkdir -p ~/.config/ranger/
    fi
    cp -bfv -t ~/.config/ranger ./ranger/rc.conf ./ranger/rifle.conf ./ranger/scope.sh
    gio trash ~/.config/ranger/rc.conf~ ~/.config/ranger/rifle.conf~ ~/.config/ranger/scope.sh~
}
yes_edit_no rangr_cnf "ranger/rc.conf ranger/rifle.conf" "Install predefined configuration (rc.conf,rifle.conf and scope.sh at ~/.config/ranger/)? " "edit" "GREEN"

reade -Q "GREEN" -i "y" -p "F2 for Ranger? [Y/n]:" "y n" rf2
if [ -z "$rf2" ] || [ "y" == "$rf2" ]; then
    binds=~/.bashrc
    if [ -f ~/.keybinds.d/keybinds.bash ]; then
        binds=~/.keybinds.d/keybinds.bash
    fi
    if [ -f ~/.keybinds.d/keybinds.bash ]; then
        if grep -q '#bind -x '\''"\\201": ranger'\''' ~/.keybinds.d/keybinds.bash; then
            sed -i 's|#bind -x '\''"\\201": ranger'\''|bind -x '\''"\\201": ranger'\''|g' ~/.keybinds.d/keybinds.bash
            sed -i 's|#bind '\''"\\eOQ": "\\201\\n\\C-l"'\''|bind '\''"\\eOQ": "\\201\\n\\C-l"'\''|g' ~/.keybinds.d/keybinds.bash
        fi
    elif ! grep -q 'bind -x '\''"\\201": ranger'\''' ~/.bashrc; then
        echo 'bind -x '\''"\\201": ranger'\''' >> ~/.bashrc
        echo 'bind '\''"\\eOQ": \\201\\n\\C-l'\''' >> ~/.bashrc
    fi 
fi

reade -Q "GREEN" -i "y" -p "Install ranger (dev)icons? (ranger plugin at ~/.conf/ranger/plugins) [Y/n]:" "y n" rplg
if [ -z $rplg ] || [ "y" == $rplg ]; then
    mkdir -p ~/.config/ranger/plugins
    git clone https://github.com/cdump/ranger-devicons2 ~/.config/ranger/plugins/devicons2
    if [ $distro_base == "Arch" ];then
        yes | sudo pacman -Su ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
    elif [ $distro_base == "Debian" ]; then    
        reade -Q "YELLOW" -i "y" -p "Install Nerdfonts from binary - no apt? (Special FontIcons) [Y/n]: " "y n" nrdfnts
        if [ -z $nrdfnts ] || [ "Y" == $nrdfnts ] || [ $nrdfnts == "y" ]; then
            ./install_nerdfonts.sh
        fi
    fi
fi

#reade -Q "GREEN" -i "y" -p "Install and enable ranger image previews? (Installs terminology) [Y/n]:" "y n" rplg
#sed -i 's|set preview_images false|set preview_images true|g' ~/.config/ranger/rc.conf
#if [ -z $rplg ] || [ "y" == $rplg ]; then
#    if [ $distro_base == "Arch" ];then
#        yes | sudo pacman -Su terminology
#    elif [ $distro_base == "Debian" ]; then 
#        yes | sudo apt install terminology
#    fi
#fi

if [ -x "$(command -v nvim)" ]; then
    reade -Q "GREEN" -i "y" -p "Integrate ranger with nvim? (Install nvim ranger plugins) [Y/n]:" "y n" rangrvim
    if [[ -z $rangrvim || "y" == $rangrvim ]]; then
        if ! grep -q "Ranger integration" ~/.config/nvim/init.vim; then
            sed -i 's|"Plug '\''francoiscabrol/ranger.vim'\''|Plug '\''francoiscabrol/ranger.vim'\''|g'
            sed -i 's|"Plug '\''rbgrouleff/bclose.vim'\''|Plug '\''rbgrouleff/bclose.vim'\''|g'
            sed -i 's|"let g:ranger_replace_netrw = 1|let g:ranger_replace_netrw = 1|g'
            sed -i 's|"let g:ranger_map_keys = 0|let g:ranger_map_keys = 0|g'
            nvim +PlugInstall
        fi
    fi
fi
#fi
