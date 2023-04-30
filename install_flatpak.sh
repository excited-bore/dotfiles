. ./checks/check_distro.sh

if [ $distro == "Manjaro" ]; then
    yes | pamac install flatpak libpamac-flatpak-plugin
elif [ $distro == "Arch" ]; then
    yes | sudo pacman -Su flatpak
elif [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
    sudo apt update
    if $XDG_CURRENT_DESKTOP == "GNOME"; then
        yes | sudo apt install gnome-software-plugin-flatpak
    else 
        yes | sudo apt install flatpak
    fi
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

read -p "Run installer for no password with pam conf? [Y/n]:" pam
if [[ -z $pam || "y" == $pam ]]; then
    . ./install_polkit_wheel.sh
fi
