 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f checks/check_distro.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro.sh)" 
else
    . ./checks/check_distro.sh
fi

if [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
    yes | sudo pacman -S remmina
elif [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
    yes | sudo apt install realvnc-vnc-server realvnc-vnc-viewer
fi

if ! sudo grep -q VncAuth /root/.vnc/config.d/vncserver-x11; then
    echo "Execute: echo \"Authentication=VncAuth\"" | sudo tee -a /root/.vnc/config.d/vncserver-x11
fi
sudo vncpasswd -service
sudo systemctl restart vncserver-x11-serviced.service
