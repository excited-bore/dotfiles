 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
    sudo apt update
    yes | sudo apt install docker.io
    yes | sudo apt remove docker docker-engine 
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    echo "You should relogin for docker to work"
elif [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
    yes | sudo pacman -Su docker
    sudo usermod -aG docker $USER
fi
