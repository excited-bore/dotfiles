# https://github.com/lakinduakash/linux-wifi-hotspot 

hash wihotspot &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


if ! hash wihotspot &> /dev/null; then
    if [[ $distro == "Ubuntu" ]] && [[ $(check-ppa ppa:lakinduakash/lwh) =~ 'OK' ]]; then
        sudo add-apt-repository ppa:lakinduakash/lwh
        sudo apt update
        eval "$pac_ins linux-wifi-hotspot"
    elif [[ $distro_base == "Arch" ]]; then
        if ! test -z "$AUR_ins"; then
            eval "$AUR_ins" linux-wifi-hotspot
        else
            echo "Install linux-wifi-hotspot from the AUR. If you have an AUR Helper that is not an AUR wrapper, try installing it manually"
        fi
    if [[ $distro == "Manjaro" ]]; then
        sudo aa-complain -d /etc/apparmor.d/ dnsmasq
    fi 
    #else
    #    if test "$distro" == "Fedora" || test "$distro" == "CentOS" || test "$distro" == "RHEL"; then
    #    git clone https://github.com/lakinduakash/linux-wifi-hotspot
    #    cd linux-wifi-hotspot

    #    make

    #    sudo make install
    fi
fi

wihotspot

if hash systemctl &> /dev/null; then
    readyn -Y 'CYAN' -p "Enable hotspot on startup with systemctl?" hotspot
    if [[ $hotspot == "y" ]]; then
        systemctl enable create_ap
    fi
fi
