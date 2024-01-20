. ./checks/check_distro.sh

if [ ! -x "$(command -v tmux)" ]; then
    if [ $distro_base == "Arch" ]; then
        yes | sudo pacman -Syu tmux
    elif [ $distro_base == "Debian" ]; then
        yes | sudo apt update
        yes | sudo apt install tmux
    fi
fi 
