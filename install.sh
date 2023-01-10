#!/bin/bash

mkdir ~/.config/nvim/
mv init.vim ~/.config/nvim/

declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
    if [ -f $f ] && [ $f == /etc/arch-release ];then
        echo Package manager: ${osInfo[$f]}
        sudo pacman -Su neovim mono go nodejs jre11-openjdk npm
    elif [ -f $f ] && [ $f == /etc/debian_version ];then
        echo Package manager: ${osInfo[$f]}
        sudo apt install build-essential build-essential cmake vim-nox python3-dev /
        mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
    fi
done
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
nvim +PluginInstall +qall
python3 ~/.vim/bundle/YouCompleteMe/install.py --all

if ! grep -q nvim ~/.vars; then
    echo "Added alias and export for vim in .vars"
    echo 'alias vim="nvim"' >> ~/.vars
    echo 'export EDITOR="nvim"' >> ~/.vars
fi
