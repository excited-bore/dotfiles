. ./checks/check_distro.sh

if [ "$distro_base" == "Arch" ];then
    yes | sudo pacman -S snapd
elif [ "$distro_base" == "Debian" ]; then
    yes | sudo apt install snapd
fi
sudo systemctl daemon-reload
sudo snap install core
