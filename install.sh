#!/bin/bash

if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir ~/.config/nvim/
fi
cp -f init.vim ~/.config/nvim/
cp -f .tmux.conf ~/.tmux.conf
cp -f .bash_aliases ~/.bash_aliases

grep -q ".bash_aliases" ~/.bashrc 
if [[ $? -eq 0 ]]; then
    echo "if [[ -f .bash_aliases ]]; then" >> ~/.bashrc
    echo "  . .bashrc" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    . ~/.bashrc
fi


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
        sudo apt install build-essential build-essential cmake vim-nox python3-dev mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
    fi
done

if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
    rm -rf ~/.vim/bundle/Vundle.vim
fi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
nvim +PluginInstall +qall
python3 ~/.vim/bundle/YouCompleteMe/install.py --all

if ! grep -q nvim ~/.bashrc; then
    echo "Added alias and export for vim in .vars"
    echo 'alias vim="nvim"' >> ~/.bashrc
    echo 'export EDITOR="nvim"' >> ~/.bashrc
fi
