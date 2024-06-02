if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type bashtop &> /dev/null; then
    if test $distro_base == "Debian"; then
       yes | sudo apt install btop
    elif test $distro_base == "Arch"; then
       yes | sudo pacman -Su bashtop
    fi
fi 
