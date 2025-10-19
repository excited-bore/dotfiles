SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if [[ $distro == "Raspbian" ]]; then
    sudo rpi-update
    if ! sudo grep -q "arm_64bit=1" /boot/config.txt; then
        sudo sed -i "s,\[pi4\],[pi4]\narm_64bit=1,g" /boot/config.txt
        readyn -p "You should reboot before further install" pmpt
        if [[ "y" == $pmpt ]]; then
            sudo reboot
        fi
    fi
fi
