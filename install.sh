#!/bin/bash

cp .vimrc ~/.vimrc
sudo pacman -Su mono go nodejs jre11-openjdk npm
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
python3 ~/.vim/bundle/YouCompleteMe/install.py --all
