 # !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
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

RIFLE_INS=""
if type rifle &> /dev/null && ! type ranger &> /dev/null; then
    RIFLE_INS=$(mktemp -d -t ranger-XXXXXXXXXX)
    sudo mv /usr/bin/rifle $RIFLE_INS
fi

# Ranger (File explorer)
if ! type ranger &> /dev/null; then
     if test $distro == "Arch" || test $distro == "Manjaro"; then
        sudo pacman -S ranger python python-pipx
    elif [ $distro_base == "Debian" ]; then    
        sudo apt install ranger python3 python3-dev pipx
    fi
fi

if ! test -z $RIFLE_INS; then
    sudo mv -f $RIFLE_INS/rifle /usr/bin/rifle
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
    if ! test -f ranger/.bash_aliases.d/ranger.sh ; then
        wget -O ~/.bash_aliases.d/ranger.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/.bash_aliases.d/ranger.sh
    else
        cp -bfv ranger/.bash_aliases.d/ranger.sh ~/.bash_aliases.d/ranger.sh
    fi
    if test -f ~/.bash_aliases.d/ranger.sh~; then
        gio trash ~/.bash_aliases.d/ranger.sh~
    fi
fi

if ! [ -d ranger/.config/ranger/ ]; then
    tmpdir=$(mktemp -d -t ranger-XXXXXXXXXX)
    wget -O $tmpdir/rc.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/.config/ranger/rc.conf
    wget -O $tmpdir/scope.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/.config/ranger/scope.sh
    wget -O $tmpdir/rifle.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/.config/ranger/rifle.conf
    dir=$tmpdir
else
    dir=ranger/.config/ranger
fi

rangr_cnf() {
    if ! [ -d ~/.config/ranger/ ]; then 
        mkdir -p ~/.config/ranger/
    fi
    
    cp -bfv -t ~/.config/ranger $dir/rc.conf $dir/rifle.conf $dir/scope.sh
    if test -f ~/.config/ranger/rc.conf~; then
        gio trash ~/.config/ranger/rc.conf~ 
    fi
    if test -f ~/.config/ranger/rifle.conf~; then
        gio trash ~/.config/ranger/rifle.conf~ 
    fi
    if test -f ~/.config/ranger/scope.sh~; then
        gio trash ~/.config/ranger/scope.sh~ 
    fi
}
yes_edit_no rangr_cnf "$dir/rc.conf $dir/rifle.conf $dir/scope.sh" "Install predefined configuration (rc.conf,rifle.conf and scope.sh at ~/.config/ranger/)? " "edit" "GREEN"

reade -Q "GREEN" -i "y" -p "F2 for Ranger? [Y/n]: " "n" rf2
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

if ! test -d ~/.config/ranger/plugins/devicons2; then
    reade -Q "GREEN" -i "y" -p "Install ranger (dev)icons? (ranger plugin at ~/.conf/ranger/plugins) [Y/n]: " "n" rplg
    if [ -z $rplg ] || [ "y" == $rplg ]; then
        mkdir -p ~/.config/ranger/plugins
        git clone https://github.com/cdump/ranger-devicons2 ~/.config/ranger/plugins/devicons2
        if test "$distro" == "Arch" || test $distro == "Manjaro" ;then
            sudo pacman -S ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
        elif [ "$distro_base" == "Debian" ]; then    
            reade -Q "YELLOW" -i "y" -p "Install Nerdfonts from binary - no apt? (Special FontIcons) [Y/n]: " "n" nrdfnts
            if [ -z $nrdfnts ] || [ "Y" == $nrdfnts ] || [ $nrdfnts == "y" ]; then
                if ! test -f ./install_nerdfonts.sh; then
                    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nerdfonts.sh)" 
                else
                    ./install_nerdfonts.sh
                fi
            fi
        fi
    fi
fi

#reade -Q "GREEN" -i "y" -p "Install and enable ranger image previews? (Installs terminology) [Y/n]:" "n" rplg
#sed -i 's|set preview_images false|set preview_images true|g' ~/.config/ranger/rc.conf
#if [ -z $rplg ] || [ "y" == $rplg ]; then
#    if test $distro == "Arch" || test $distro == "Manjaro";then
#       sudo pacman -S terminology
#    elif test $distro_base == "Debian"; then 
#       sudo apt install terminology
#    fi
#fi

if [ -x "$(command -v nvim)" ]; then
    reade -Q "GREEN" -i "y" -p "Integrate ranger with nvim? (Install nvim ranger plugins) [Y/n]: " "n" rangrvim
    if [[ -z $rangrvim || "y" == $rangrvim ]]; then
        if test -f  ~/.config/nvim/init.vim && ! grep -q "Ranger integration" ~/.config/nvim/init.vim; then
            sed -i 's|"Plug '\''francoiscabrol/ranger.vim'\''|Plug '\''francoiscabrol/ranger.vim'\''|g' ~/.config/nvim/init.vim
            sed -i 's|"Plug '\''rbgrouleff/bclose.vim'\''|Plug '\''rbgrouleff/bclose.vim'\''|g' ~/.config/nvim/init.vim
            sed -i 's|"let g:ranger_replace_netrw = 1|let g:ranger_replace_netrw = 1|g' ~/.config/nvim/init.vim
            sed -i 's|"let g:ranger_map_keys = 0|let g:ranger_map_keys = 0|g' ~/.config/nvim/init.vim
            nvim +PlugInstall
        fi
    fi
fi
#fi
