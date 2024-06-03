if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type neofetch &> /dev/null; then
    if test $distro_base == "Debian"; then
       sudo apt install neofetch
    elif test $distro == "Arch" || test $distro == "Manjaro"; then
       sudo pacman -S neofetch
    fi
fi
