 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
    update_system
else
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
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
