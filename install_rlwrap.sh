. ./check_distro.sh

if [[ $dist == "Raspbian" || $dist == "Debian" ]]; then
    sudo apt update && sudo apt install rlwrap
elif [[ $dist == "Arch" || $dist == "Manjaro" ]]; then
    sudo pacman -Su rlwrap
fi
