. ./check_distro.sh
if [[ $dist == "Debian" || $dist == "Raspbian" ]]; then
    yes | sudo apt install docker.io
    yes | sudo apt remove docker docker-engine 
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    sudo docker run hello-world
    echo "You should relogin for docker to work"
elif [[ $dist == "Arch" || $dist == "Manjaro" ]]; then
    yes | sudo pacman -Su docker
    sudo usermod -aG docker $USER
fi
