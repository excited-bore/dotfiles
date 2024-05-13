 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./checks/check_system.sh

if [ $distro == "Ubuntu" ]; then
    sudo add-apt-repository ppa:lakinduakash/lwh
    sudo apt install linux-wifi-hotspot
elif [ $distro == "Arch" ]; then
    echo "Install using AUR helper (f.ex. yay -S linux-wifi-hotspot)"
    exit 1
elif [ $distro == "Manjaro" ]; then
    pamac install linux-wifi-hotspot
    sudo aa-complain -d /etc/apparmor.d/ dnsmasq
fi

