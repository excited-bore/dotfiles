 DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $DIR/check_distro.sh

if [ $dist == "Debian" ]; then
    sudo add-apt-repository ppa:lakinduakash/lwh
    sudo apt install linux-wifi-hotspot
elif [ $dist == "Arch" ]; then
    echo "Install using AUR helper (f.ex. yay -S linux-wifi-hotspot)"
    exit 1
elif [ $dist == "Manjaro" ]; then
    pamac install linux-wifi-hotspot
    sudo aa-complain -d /etc/apparmor.d/ dnsmasq
fi

