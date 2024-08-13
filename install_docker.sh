 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if test $distro_base == "Debian"; then
    sudo apt install docker.io
    sudo apt remove docker docker-engine 
    curl -sSL https://get.docker.com | sh
    sudo usermod -aG docker $USER
    echo "You should relogin for docker to work"
elif test $distro == "Arch" || test $distro == "Manjaro"; then
    sudo pacman -S docker
    sudo usermod -aG docker $USER
fi
