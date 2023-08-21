 # !/bin/bash
. ./checks/check_distro.sh
. ./readline/rlwrap_scripts.sh

 # Ranger (File explorer)
reade -Q "GREEN" -i "y" -p "Install Ranger? (Terminal file explorer - keybinding F2 [Y/n]: " "y n" rngr
if [ -z $rngr ] || [ "Y" == $rngr ] || [ $rngr == "y" ]; then
    if [ $distro_base == "Arch" ];then
        yes | sudo pacman -Su ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono ranger python 
    elif [ $distro_base == "Debian" ]; then    
        sudo apt update 
        yes | sudo apt install ranger python3 python3-dev python3-pip 
        sudo apt install kitty atool bat elinks ffmpegthumbnailer fontforge highlight imagemagick jq libcaca0 odt2txt mupdf-tools 
        reade -Q "YELLOW" -i "y" -p "Install Nerdfonts from binary - no apt? (Special FontIcons) [Y/n]: " "y n" nrdfnts
        if [ -z $nrdfnts ] || [ "Y" == $nrdfnts ] || [ $nrdfnts == "y" ]; then
            . install_nerdfonts.sh
        fi
    fi
    
    ranger --confdir=/home/$USER/.config/ranger --copy-config=all
    ranger --copy-config=all
    
    reade -Q "GREEN" -i "y" -p "Install rc.conf and rifle.conf? (ranger conf at ~/.conf/ranger/) [Y/n]:" "y n" rcc
    if [ -z $rcc ] || [ "y" == $rcc ]; then
        mkdir -p ~/.config/ranger/
        cp -f -t ~/.config/ranger ranger/rc.conf ranger/rifle.conf
    fi

    reade -Q "GREEN" -i "y" -p "F2 for Ranger? [Y/n]:" "y n" rf2
    if [ -z $rf2 ] || [ "y" == $rf2 ]; then
        binds=~/.bashrc
        if [ -f ~/.bash_aliases/shell_keybindings ]; then
            binds=~/.bash_aliases/shell_keybindings
        fi
        if grep -q "bind -x '\"\\\eOQ\": ranger'" $binds; then
            sed -i 's|#bind -x '\''"\\eOQ\": ranger'\''|bind -x '\''"\\eOQ\": ranger'\''|g' $binds
        fi
    fi

    reade -Q "GREEN" -i "y" -p "Install ranger plugins? (plugins at ~/.conf/ranger/plugins) [Y/n]:" "y n" rplg
    if [ -z $rplg ] || [ "y" == $rplg ]; then
        mkdir -p ~/.config/ranger/plugins
        git clone https://github.com/cdump/ranger-devicons2 ~/.config/ranger/plugins/devicons2
    fi
     
    # TODO Fixthis
    #if [ -x "$(command -v nvim)" ]; then
    #    read -p "Integrate ranger with nvim? (Install nvim ranger plugins) [Y/n]:" rangrvim
    #    if [[ -z $rangrvim || "y" == $rangrvim ]]; then
    #        if ! grep -q "Ranger integration" ~/.config/nvim/init.vim; then
                #sed -i s/"\(Plugin 'ycm-core\/YouCompleteMe'\)"/"\1\n\n\"Ranger integration\nPlugin 'francoiscabrol\/ranger.vim'\nPlugin 'rbgrouleff\/bclose.vim'\nlet g:ranger_replace_netrw = 1"/g ~/.config/nvim/init.vim
                #nvim +PlugInstall +qall
    #        fi
    #    fi
fi
