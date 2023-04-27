 DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $DIR/check_distro.sh

if [[ $dist == "Manjaro" || $dist == "Arch" ]];then
    sudo pacman -S snapd
elif [[ $dist == "Debian" || $dist == "Raspbian" ]]; then
    sudo apt install snapd
fi
sudo systemctl daemon-reload
sudo snap install core
