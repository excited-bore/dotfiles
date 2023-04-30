DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $DIR/check_distro.sh

if [[ $dist == "Arch" || $dist == "Manjaro" ]]; then
    sudo pacman -Su python-pip
elif [[ $dist == "Debian" || $dist == "Raspbian" || $dist == "Ubuntu" ]]; then
    sudo apt install python3-pip
fi
python3 -m pip install yt-dlp
