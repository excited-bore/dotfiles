TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if [[ $distro_base == "Arch" ]]; then
    eval "$pac_ins_y remmina"
elif [[ $distro_base == "Debian" ]]; then
    eval "$pac_ins realvnc-vnc-server realvnc-vnc-viewer"
fi

if ! sudo grep -q VncAuth /root/.vnc/config.d/vncserver-x11; then
    echo "Execute: echo \"Authentication=VncAuth\"" | sudo tee -a /root/.vnc/config.d/vncserver-x11
fi
sudo vncpasswd -service
sudo systemctl restart vncserver-x11-serviced.service
