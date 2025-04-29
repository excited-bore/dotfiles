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


if ! type wihotspot &> /dev/null; then
    if [[ $distro == "Ubuntu" ]] && [[ $(check-ppa ppa:lakinduakash/lwh) =~ 'OK' ]]; then
        sudo add-apt-repository ppa:lakinduakash/lwh
        sudo apt update
        eval "$pac_ins linux-wifi-hotspot"
    elif [[ $distro == "Arch" ]]; then
        if ! test -z "$AUR_ins"; then
            eval "$AUR_ins" linux-wifi-hotspot
        else
            echo "Install linux-wifi-hotspot from the AUR. If you have an AUR Helper that is not an AUR wrapper, try installing it manually"
        fi
    elif [[ $distro == "Manjaro" ]]; then
        pamac install linux-wifi-hotspot
        sudo aa-complain -d /etc/apparmor.d/ dnsmasq
    else
    #    if test "$distro" == "Fedora" || test "$distro" == "CentOS" || test "$distro" == "RHEL"; then
    #    git clone https://github.com/lakinduakash/linux-wifi-hotspot
    #    cd linux-wifi-hotspot

    #    make

    #    sudo make install
    #fi
fi

wihotspot

if type systemctl &> /dev/null; then
    readyn -Y 'CYAN' -p "Enable hotspot on startup with systemctl?" hotspot
    if [[ $hotspot == "y" ]]; then
        systemctl enable create_ap
    fi
fi
