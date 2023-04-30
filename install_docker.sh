 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./checks/check_distro.sh

if [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
    sudo apt update
    yes | sudo apt install docker.io
    yes | sudo apt remove docker docker-engine 
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    sudo docker run hello-world
    echo "You should relogin for docker to work"
elif [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
    yes | sudo pacman -Su docker
    sudo usermod -aG docker $USER
fi
