#!/bin/bash 
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
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if test $distro == "Arch" || test $distro == "Manjaro"; then
    sudo pacman -S xorg
elif [ $distro_base == "Debian" ];then
    sudo apt install xorg 
fi 

#This should create a xorg.conf.new file in /root/ that you can copy over to /etc/X11/xorg.conf
Xorg :0 -configure
# If already running an X server
#Xorg :2 -configure
#cp /root/xorg.conf.new /etc/X11/xorg.conf
