. ./check_distro.sh

if [[ $dist == "Manjaro" || $dist == "Arch" ]];then
    sudo pacman -S snapd
elif [ $dist == "Debian" ]; then
    sudo apt install snapd
fi
sudo systemctl daemon-reload
