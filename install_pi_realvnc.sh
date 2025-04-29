#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

if test $distro == "Arch" || test $distro == "Manjaro"; then
    eval "$pac_ins remmina"
elif test $distro_base == "Debian"; then
    eval "$pac_ins realvnc-vnc-server realvnc-vnc-viewer"
fi

if ! sudo grep -q VncAuth /root/.vnc/config.d/vncserver-x11; then
    echo "Execute: echo \"Authentication=VncAuth\"" | sudo tee -a /root/.vnc/config.d/vncserver-x11
fi
sudo vncpasswd -service
sudo systemctl restart vncserver-x11-serviced.service
