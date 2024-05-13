#!/bin/bash 
. ./checks/check_system.sh

if [ $distro_base == "Arch" ];then
    yes | sudo pacman -Su xorg
elif [ $distro_base == "Debian" ];then
    yes | sudo apt install xorg 
fi 

#This should create a xorg.conf.new file in /root/ that you can copy over to /etc/X11/xorg.conf
Xorg :0 -configure
# If already running an X server
#Xorg :2 -configure
#cp /root/xorg.conf.new /etc/X11/xorg.conf
