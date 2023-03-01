. ./check_distro.sh
if [[ $dist == "Debian" || $dist == "Raspbian" ]]; then
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo apt-get install \
            ca-certificates \
            curl \
            gnupg \
            lsb-release
    sudo mkdir -m 0755 -p /etc/apt/keyrings
    echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo docker run hello-world
fi
