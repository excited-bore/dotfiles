. ./check_distro.sh
if [[ $dist == "Debian" || $dist == "Raspbian" ]]; then
    sudo apt remove docker docker-engine docker.io containerd runc
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    sudo docker run hello-world
    echo "You should relogin for docker to work"
elif [[ $dist == "Arch" || $dist == "Manjaro" ]]; then
    sudo pacman -Su docker
fi
