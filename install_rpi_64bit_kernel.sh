 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
    update-system
else
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if [ $distro == "Raspbian" ]; then
    sudo rpi-update
    if ! sudo grep -q "arm_64bit=1" /boot/config.txt; then
        sudo sed -i "s,\[pi4\],[pi4]\narm_64bit=1,g" /boot/config.txt
        read -p "You should reboot before further install [Y/n]: " pmpt
        if [[ -z $pmpt || "y" == $pmpt ]]; then
            sudo reboot
        fi
    fi
fi
