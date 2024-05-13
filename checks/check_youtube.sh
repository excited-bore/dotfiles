#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./checks/check_system.sh

if [ ! -x "$(command -v yt-dlp)" ]; then
    if [ ! -x "$(command -v pipx)" ]; then
        if [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
            yes | sudo pacman -Su python-pipx
        elif [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
            yes | sudo apt update
            yes | sudo apt install python3-pip
        fi
    fi
    python3 -m pipx install yt-dlp
fi
