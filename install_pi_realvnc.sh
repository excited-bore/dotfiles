 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./checks/check_distro.sh

if [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
    sudo pacman -Su remmina
elif [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
    sudo apt update 
    sudo apt install realvnc-vnc-server realvnc-vnc-viewer
fi

if ! sudo grep -q VncAuth /root/.vnc/config.d/vncserver-x11; then
    echo "Execute: echo \"Authentication=VncAuth\"" | sudo tee -a /root/.vnc/config.d/vncserver-x11
fi
sudo vncpasswd -service
sudo systemctl restart vncserver-x11-serviced.service
