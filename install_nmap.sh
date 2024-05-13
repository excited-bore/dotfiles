if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro)" 
else
    . ./checks/check_system.sh
fi

if [ "$(which nmap)" == "" ]; then 
    if [ $distro_base == "Arch" ];then
        yes | sudo pacman -Su nmap
    elif [ $distro_base == "Debian" ]; then
        yes | sudo apt install nmap 
    fi
fi

