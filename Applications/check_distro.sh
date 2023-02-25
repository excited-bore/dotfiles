#!/bin/bash
dist=/
pm=/
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/rpi-issue]=apt
osInfo[/etc/manjaro-release]=pamac
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]};
do
    if [ -f $f ] && [ $f == /etc/alpine-release ] && [ $dist == / ]; then
        pm=${osInfo[$f]}
        dist="Alpine"
    elif [ -f $f ] && [ $f == /etc/manjaro-release ] && [ $dist == / ]; then
        pm=${osInfo[$f]}
        dist="Manjaro"
    elif [ -f $f ] && [ $f == /etc/SuSE-release ] && [ $dist == / ];then
        pm=${osInfo[$f]}
        dist="Suse"
    elif [ -f $f ] && [ $f == /etc/gentoo-release ] && [ $dist == / ];then
        pm=${osInfo[$f]}
        dist="Gentoo"
    elif [ -f $f ] && [ $f == /etc/redhat-release ] && [ $dist == / ];then
        pm=${osInfo[$f]}
        dist="Redhat"
    elif [ -f $f ] && [ $f == /etc/arch-release ] && [ $dist == / ];then
        pm=${osInfo[$f]}
        dist="Arch"
    elif [ -f $f ] && [ $f == /etc/rpi-issue ] && [ $dist == / ];then
        pm=${osInfo[$f]}
        dist="Raspbian"
    elif [ -f $f ] && [ $f == /etc/debian_version ] && [ $dist == / ];then
        pm=${osInfo[$f]}
        dist="Debian"
    fi 
done
