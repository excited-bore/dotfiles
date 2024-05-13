. ./checks/check_system.sh
if [ ! -x "$(command -v fzf)" ]; then
    ./install_fzf.sh
fi

./install_AUR-helper.sh


pmSearch="" 
pmInstall=""
pmRemove=""

if [ "$distro_base" == "Arch" ]; then
    pmSearch="sudo pacman -Ss"
    pmInstall="sudo pacman -Su"
    pmRemove="sudo pacman -R"
    if [ "$disto" == "Manjaro" ]; then
        pmSearch="pamac search"
        pmInstall="pamac install"
        pmInstall="pamac remove"
    fi
fi

