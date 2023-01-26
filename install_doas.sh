#!/bin/bash
read -p "Installed with sudo? (Ctrl-c to try again) [y/n]: " resp
if [ "$resp" = "y" ]; then

    declare -A osInfo;
    osInfo[/etc/redhat-release]=yum
    osInfo[/etc/arch-release]=pacman
    osInfo[/etc/gentoo-release]=emerge
    osInfo[/etc/SuSE-release]=zypp
    osInfo[/etc/debian_version]=apt
    osInfo[/etc/alpine-release]=apk

    pm=/
    for f in ${!osInfo[@]}
    do
        if [ -f $f ] && [ $f == /etc/arch-release ];then
            echo Package manager: ${osInfo[$f]}
            pm=${osInfo[$f]}
            sudo pacman -Su opendoas 
        elif [ -f $f ] && [ $f == /etc/debian_version ];then
            echo Package manager: ${osInfo[$f]}
            pm=${osInfo[$f]}
            sudo apt install doas
        fi 
    done
    sed -i "s/user/$USER/g" doas.conf
    sudo cp -f doas.conf /etc/doas.conf

    read -p "Add polkit rules? (Only for systems with map at /etc/polkit-1/rules.d/) [y/n]: " resp1
    if [ $resp1 = "y" ]; then
        sudo cp -f 49-nopasswd_global.rules /etc/polkit-1/rules.d/49-nopasswd_global.rules
    fi
    echo "Enter: chown root:root -c /etc/doas.conf; chmod 0644 -c /etc/doas.conf; doas -C /etc/doas.conf && echo 'config ok' || echo 'config error' ";
    su -;

    sudo groupadd wheel && sudo usermod -aG wheel "$USER"
fi
