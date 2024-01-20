#!/bin/bash
if [ -x $(command -v yay) ]; then
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    yay --version
    echo "Yay installed!"
fi
