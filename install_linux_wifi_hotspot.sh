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
fi

if ! test -f aliases/.bash_aliases.d/package_managers.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh)" 
else
    source aliases/.bash_aliases.d/package_managers.sh
fi


if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type wihotspot &> /dev/null; then
    if [ $distro == "Ubuntu" ] && [[ $(check-ppa ppa:lakinduakash/lwh) =~ 'OK' ]]; then
        sudo add-apt-repository ppa:lakinduakash/lwh
        sudo apt update
        eval "$pac_ins linux-wifi-hotspot"
    elif [ $distro == "Arch" ]; then
        if ! test -z "$AUR_ins"; then
            eval "$AUR_ins" linux-wifi-hotspot
        else
            echo "Install linux-wifi-hotspot from the AUR. If you have an AUR Helper that is not an AUR wrapper, try installing it manually"
        fi
    elif [ $distro == "Manjaro" ]; then
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

    reade -Q "CYAN" -i "y" -p "Enable hotspot on startup with systemctl? "" hotspot
    if test $hotspot == "y"; then
        systemctl enable create_ap
    fi
fi
