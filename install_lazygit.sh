if ! test -f checks/check_distro.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro)" 
else
    . ./checks/check_distro.sh
fi

reade -Q "GREEN" -i "y" -p "Install lazygit? (Git gui) [Y/n]:" "y n" nstll
if [ "$nstll" == "y" ]; then
    if [ $distro == "Arch" ] || [ $distro_base == "Arch" ]; then
        yes | sudo pacman -Su lazygit
    elif [ $distro == "Debian" ] || [ $distro_base == "Debian" ]; then
        yes | sudo apt update
        yes | sudo apt install lazygit
    fi
    
fi
unset nstll
