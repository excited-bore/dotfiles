. ./check_distro.sh

if [ $dist == "Manjaro" ]; then
    pamac install flatpak libpamac-flatpak-plugin
elif [ $dist == "Arch" ]; then
    sudo pacman -S flatpak
elif [[ $dist == "Debian" || $dist == "Raspbian" ]]; thena
    sudo apt install flatpak
    if $XDG_CURRENT_DESKTOP == "GNOME"; then
        sudo apt install gnome-software-plugin-flatpak
    fi
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

read -p "Run installer for no password with pam conf? [Y/n]:" pam
if [[ -z $pam || "y" == $pam ]]; then
    . ./install_polkit_wheel.sh
fi
