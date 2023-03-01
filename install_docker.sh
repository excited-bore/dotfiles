. ./check_distro.sh
if [[ $dist == "Debian" || $dist == "Raspbian" ]]; then
    sudo apt-get remove docker docker-engine docker.io containerd runc
    curl -sSL https://get.docker.com | sh
    sudo docker run hello-world
fi
