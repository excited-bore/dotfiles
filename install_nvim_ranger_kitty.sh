 # !/bin/bash

if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir ~/.config/nvim/
fi
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk

pm=/
for f in ${!osInfo[@]}
do
    if [ -f $f ] && [ $f == /etc/arch-release ];then
            echo Package manager: ${osInfo[$f]}
            pm=${osInfo[$f]}
            sudo pacman -Su tttf-nerd-fonts-symbols-common tf-nerd-fonts-symbols-2048-em ttf-nerd-fonts-symbols-2048-em-mono ranger kitty xclip sshfs neovim mono go nodejs jre11-openjdk npm python atool bat calibre elinks ffmpegthumbnailer fontforge highlight imagemagick mupdf-tools odt2txt btm
    elif [ -f $f ] && [ $f == /etc/debian_version ];then
        echo Package manager: ${osInfo[$f]}
        pm=${osInfo[$f]}
        sudo apt update && sudo apt upgrade
        sudo apt install kitty ranger build-essential python2 python3 cmake neovim python3-dev python3-pip mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm atool bat elinks ffmpegthumbnailer fontforge highlight imagemagick jq libcaca0 odt2txt mupdf-tools 
        (mkdir ~/.local/share/fonts && cd ~/.local/share/fonts && wget https://github.com/vorillaz/devicons/archive/master.zip && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hermit.zip && unzip master.zip Hermit.zip && yes | rm master.zip Hermit.zip && sudo fc-cache -fv)
    fi 
done


./install_nvim.sh


read -p "Install rc.conf and rifle.conf? (ranger conf at ~/.conf/ranger/) [Y/n]:" rcc
if [ -z $rcc ]; then
    mkdir -p ~/.config/ranger/
    cp -f -t ~/.config/ranger ranger/rc.conf ranger/rifle.conf
fi

read -p "Install ranger plugins? (plugins at ~/.conf/ranger/plugins) [Y/n]:" rplg
if [ -z $rplg ]; then
    mkdir -p ~/.config/ranger/plugins
    git clone https://github.com/cdump/ranger-devicons2 ~/.config/ranger/plugins/devicons2
fi

 read -p "Install kitty conf? (at ~/.config/kitty/kitty.conf) [Y/n]:" kittn
if [ -z $kittn ]; then
    mkdir -p ~/.config/kitty
    cp -f kitty/kitty.conf ~/.config/kitty/kitty.conf
fi

