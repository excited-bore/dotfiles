#!/bin/bash

mkdir ~/.config/nvim/
cp init.vim ~/.config/nvim/
sudo pacman -Su neovim mono go nodejs jre11-openjdk npm
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
nvim +PluginInstall +qall
python3 ~/.vim/bundle/YouCompleteMe/install.py --all
echo 'alias vim="nvim"' >> ~/.bashrc
echo 'export EDITOR="nvim"' >> ~/.bashrc
