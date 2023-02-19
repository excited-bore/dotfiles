 # !/bin/bash

. ./check_distro.sh

if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir ~/.config/nvim/
fi

if [[ $dist == "Manjaro" || $dist == "Arch" ]];then
    sudo pacman -Su ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-2048-em ttf-nerd-fonts-symbols-2048-em-mono ranger kitty xclip neovim mono go nodejs jre11-openjdk npm python atool bat calibre elinks ffmpegthumbnailer fontforge highlight imagemagick mupdf-tools odt2txt
elif [ $dist== "Debian" ];then
    sudo apt update && sudo apt upgrade
    sudo apt install kitty ranger build-essential python2 python3 cmake python3-dev python3-pip mono-complete nodejs openjdk-17-jdk openjdk-17-jre npm atool bat elinks ffmpegthumbnailer fontforge highlight imagemagick jq libcaca0 odt2txt mupdf-tools 
    (mkdir ~/.local/share/fonts && cd ~/.local/share/fonts && wget https://github.com/vorillaz/devicons/archive/master.zip && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hermit.zip && unzip master.zip Hermit.zip && yes | rm master.zip Hermit.zip && sudo fc-cache -fv)
fi 

read -p "Install nvim? [Y/n]:" nvim
if [ -z $nvim ] || [ "y" == $nvim ]; then
    ./install_nvim.sh
fi

read -p "Integrate ranger with nvim? (Install nvim ranger plugins) [Y/n]:" rangrvim
if [ -z $rangrvim ] || [ "y" == $rangrvim ]; then
    if ! grep -q "Ranger integration" ~/.config/nvim/init.vim; then
        sed -i s/"\(Plugin 'ycm-core\/YouCompleteMe'\)"/"\1\n\n\"Ranger integration\nPlugin 'francoiscabrol\/ranger.vim'\nPlugin 'rbgrouleff\/bclose.vim'\nlet g:ranger_replace_netrw = 1"/g ~/.config/nvim/init.vim
        nvim +PluginInstall +qall
    fi
fi

read -p "Install rc.conf and rifle.conf? (ranger conf at ~/.conf/ranger/) [Y/n]:" rcc
if [ -z $rcc ] || [ "y" == $rcc ]; then
    mkdir -p ~/.config/ranger/
    cp -f -t ~/.config/ranger ranger/rc.conf ranger/rifle.conf
fi


read -p "Install ranger plugins? (plugins at ~/.conf/ranger/plugins) [Y/n]:" rplg
if [ -z $rplg ] || [ "y" == $rplg ]; then
    mkdir -p ~/.config/ranger/plugins
    git clone https://github.com/cdump/ranger-devicons2 ~/.config/ranger/plugins/devicons2
fi

 read -p "Install kitty conf? (at ~/.config/kitty/kitty.conf) [Y/n]:" kittn
if [ -z $kittn ] || [ "y" == $kittn ]; then
    mkdir -p ~/.config/kitty
    cp -f kitty/kitty.conf ~/.config/kitty/kitty.conf
fi

