# Uncomplicated Firewall

hash ufw &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! [[ -f ../checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash ufw &>/dev/null; then
    if [[ "$distro_base" == "Arch" || $distro_base == "Debian" ]]; then
        eval "${pac_ins_y}" ufw
    fi
fi

if ! hash gufw &>/dev/null; then
    readyn -p 'Also install GUI for uncomplicated firewall?' ins_gui
    if [[ $ins_gui == 'y' ]]; then
        if [[ "$distro_base" == "Arch" || $distro_base == "Debian" ]]; then
            eval "${pac_ins_y}" gufw
        fi
    fi
fi
unset ins_gui
