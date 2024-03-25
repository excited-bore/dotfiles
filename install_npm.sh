# !/bin/bash
if ! test -f checks/check_distro.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro.sh)" 
else
    . ./checks/check_distro.sh
fi

if ! type npm &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install npm and nodejs"
    if test $distro_base == "Arch"; then 
        yes | sudo pacman -Su npm nodejs
    elif test $distro_base == "Debian"; then
        yes | sudo apt install npm nodejs
    fi
fi


