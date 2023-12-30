# !/bin/bash
. ./checks/check_distro.sh

if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir ~/.config/nvim/
fi

#(mkdir ~/.local/share/fonts && cd ~/.local/share/fonts && wget https://github.com/vorillaz/devicons/archive/master.zip && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hermit.zip && unzip master.zip Hermit.zip && rm -f master.zip Hermit.zip && sudo fc-cache -fv)

read -p "Install Neovim? [Y/n]: " nvim
if [[ -z $nvim || "y" == $nvim ]]; then
    ./install_nvim.sh
fi

read -p "Install Ranger [Y/n]: " ranger
if [[ -z $ranger || "y" == $ranger ]]; then
    ./install_ranger.sh
fi

read -p "Install kitty? [Y/n]: " ktty
if [[ -z $ktty || "y" == $ktty ]]; then
    if [ $distro_base == "Arch" ]; then
        yes | sudo pacman -Su kitty 
    elif [ $distro_base == "Debian" ]; then    
        yes | sudo apt update 
        yes | sudo apt install kitty 
    fi
    read -p "Install kitty conf? (at ~/.config/kitty/kitty.conf) [Y/n]:" kittn
    if [ -z $kittn ] || [ "y" == $kittn ]; then
        mkdir -p ~/.config/kitty
        cp -f kitty/kitty.conf ~/.config/kitty/kitty.conf
    fi
fi
