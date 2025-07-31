SYSTEM_UPDATED=TRUE

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if [[ "$XDG_CURRENT_DESKTOP" == 'GNOME' ]]; then
    readyn -p "Set ${CYAN}GNOME${GREEN} to remember the numlock state?" rmembr
    if [[ "$rmembr" == 'y' ]]; then
        gsettings set org.gnome.desktop.peripherals.keyboard remember-numlock-state true
    fi
    unset rmembr
elif [[ "$XDG_CURRENT_DESKTOP" == 'xfce' ]]; then
    readyn -p "Set ${CYAN}GNOME${GREEN} to remember the numlock state?" rmembr
    if [[ "$rmembr" == 'y' ]]; then
        gsettings set org.gnome.desktop.peripherals.keyboard remember-numlock-state true
    fi
    unset rmembr
fi
