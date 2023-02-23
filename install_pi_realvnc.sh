. ./check_distro.sh

if [[ $dist == "Manjaro" || $dist== "Arch" ]]; then
    sudo pacman -Su remmina
elif [[ $dist == "Debian" || $dist == "Raspbian" ]]; then
    sudo apt update && sudo apt install realvnc-vnc-server realvnc-vnc-viewer
fi

if ! sudo grep -q VncAuth /root/.vnc/config.d/vncserver-x11; then
    echo "Execute: echo \"Authentication=VncAuth\" >> /root/.vnc/config.d/vncserver-x11"
    sudo -i
fi
sudo vncpasswd -service
sudo systemctl restart vncserver-x11-serviced.service
