if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if [ "$(which nmap)" == "" ]; then 
    if test "$distro" == "Arch" || test "$distro" == "Manjaro"; then
        sudo pacman -S nmap
    elif test "$distro_base" == "Debian"; then
        sudo apt install nmap 
    fi
fi

