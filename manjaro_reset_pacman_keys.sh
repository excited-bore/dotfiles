printf "This script will: \n - Enable automatic date/time syncing\n - Remove gnupg keys from pacman\n - Reinitialize keys\n - Repopulate keys\n - Reinstall latest keyrings\n - Refresh signature keys\n";
read -p "Ok?[Y/n]: " ansr;
if [ $ansr == "" ] || [ $ansr == "y" ] || [ $ansr == "Y" ]; then
    timedatectl set-ntp true
    timedatectl status
    sudo rm -rf /etc/pacman.d/gnupg
    sudo pacman-key --init
    sudo pacman-key --populate archlinux manjaro
    sudo pacman -Sy gnupg archlinux-keyring manjaro-keyring
    sudo pacman-key --refresh-keys
    read -p "Clear out packages from aborted installations? [Y/n]: " ansr
    if [ $ansr == "" ] || [ $ansr == "y" ] || [ $ansr == "Y" ]; then
        sudo pacman -Sc
    fi
fi
