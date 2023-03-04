if sudo test -d /etc/network/interfaces.d/; then
    sudo touch /etc/network/interfaces.d/eth0-dhcp
    printf "auto eth0\nallow-hotplug eth0\niface eth0 inet dhcp" | sudo tee /etc/network/interfaces.d/eth0-dhcp
    echo "Rules added in /etc/network/interfaces.d/eth0-dhcp"
fi
