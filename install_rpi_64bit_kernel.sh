. ./check_distro.sh

if [ $dist == "Raspbian" ]; then
    sudo rpi-update
    if ! sudo grep -q "arm_64bit=1" /boot/config.txt; then
        sudo sed -i "s,\[pi4\],[pi4]\narm_64bit=1,g" /boot/config.txt
        read -p "You should reboot before further install [Y/n]: " pmpt
        if [[ -z $pmpt || "y" == $pmpt ]]; then
            sudo reboot
        fi
    fi
fi
