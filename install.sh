#!/bin/bash

if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir ~/.config/nvim/
fi
cp -f init.vim ~/.config/nvim/
cp -f .tmux.conf ~/.tmux.conf
cp -f .bash_aliases ~/.bash_aliases

if ! grep -q .bash_aliases ~/.bashrc; then
    echo "if [[ -f ~/.bash_aliases ]]; then" >> ~/.bashrc
    echo "  . ~/.bash_aliases" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    . ~/.bash_aliases 
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
        sudo pacman -Su sshfs neovim mono go nodejs jre11-openjdk npm python ranger atool bat calibre elinks ffmpegthumbnailer fontforge highlight imagemagick kitty mupdf-tools odt2txt
    elif [ -f $f ] && [ $f == /etc/debian_version ];then
        echo Package manager: ${osInfo[$f]}
        pm=${osInfo[$f]}
        sudo apt install build-essential python2 python3 sshfs cmake vim-nox python3-dev python3-pip mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm ranger atool bat elinks ffmpegthumbnailer fontforge highlight imagemagick jq kitty libcaca0 odt2txt mupdf-tools
    fi 
done
    ranger --copy-config=all
    cp -f rc.conf ~/.config/ranger/

if [[ -d ~/.vim/bundle/YouCompleteMe/ ]];then
    sudo rm -rf ~/.vim/bundle/YouCompleteMe/
fi

if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
    sudo rm -rf ~/.vim/bundle/Vundle.vim
fi

if [[ -d ~/.tmux/plugins/tpm ]]; then
    sudo rm -rf ~/.tmux/plugins/tpm
fi

if [[ -d ~/.tmux/plugins/tmux-yank ]]; then
    sudo rm -rf ~/.tmux/plugins/tmux-yank
fi

if [[ -d ~/.config/ranger/plugins/ ]]; then
    sudo rm -rf ~/.config/ranger/plugins/
fi
mkdir ~/.config/ranger/plugins/

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tmux-yank ~/.tmux/plugins/tmux-yank
git clone https://github.com/joouha/ranger_tmux ~/.config/ranger/plugins/ranger_tmux
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
python -m ranger_tmux install
python -m ranger_tmux --tmux install
nvim +PluginInstall +qall

if [ $pm == /etc/arch-release ]; then
    python ~/.vim/bundle/YouCompleteMe/install.py --all
elif [ $pm == /etc/debian_version ];then  
    python3 ~/.vim/bundle/YouCompleteMe/install.py --all
else
    python ~/.vim/bundle/YouCompleteMe/install.py --all
fi

if ! grep -q nvim ~/.bashrc; then
    echo "Added alias and export for vim in .bashrc"
    echo 'alias vim="nvim"' >> ~/.bashrc
    echo 'export EDITOR="nvim"' >> ~/.bashrc
fi
echo "Done! Don't forget to open tmux and Prefix+I !"
