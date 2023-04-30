#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./check_distro.sh

if [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
    sudo pacman -Su python-pip
elif [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
    sudo apt install python3-pip
fi
python3 -m pip install yt-dlp
