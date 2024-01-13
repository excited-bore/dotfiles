. ./checks/check_distro.sh
. ./readline/rlwrap_scripts.sh

if [ "$distro" == "Arch" ] || [ "$distro_base" == "Arch" ]; then
    yes | sudo pacman -Su kitty 
elif [ "$distro" == "Debian" ] || [ "$distro_base" == "Debian" ]; then    
    yes | sudo apt update 
    yes | sudo apt install kitty 
fi

reade -Q "GREEN" -i "y" -p "Install kitty conf? (at ~/.config/kitty/kitty.conf) [Y/n]:" "y n" kittn
if [ "y" == "$kittn" ]; then
    mkdir -p ~/.config/kitty
    cp -f kitty/kitty.conf ~/.config/kitty/kitty.conf
fi
unset kittn

#if [ -x "$(command -v xdg-open)" ]; then
#    reade -Q "GREEN" -p -i "y" "Set kitty as default terminal? [Y/n]:" "y n" kittn
#    if [ "y" == "$kittn" ]; then
#        
#    fi
#fi
