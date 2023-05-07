#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. check_distro.sh

if [ ! -x "$(command -v yt-dlp)" ]; then
    if [ ! -x "$(command -v pip)" ]; then
        if [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
            yes | sudo pacman -Su python-pip
        elif [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
            yes | sudo apt update
            yes | sudo apt install python3-pip
        fi
    fi
    python3 -m pip install yt-dlp
fi
