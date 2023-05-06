 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./checks/check_distro.sh

if [ ! -x "$(command -v rlwrap)" ]; then
    read -p "Install rlwrap (better autocompletion, used a lot in my scripts) [Y/n]:" answr
    if [ "$answr" == "y" ] || [ -z "$answr" ] || [ "Y" == "$answr" ]; then
        if [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
            yes | sudo apt update; 
            yes | sudo apt install rlwrap;
        elif [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
            yes | sudo pacman -Su rlwrap;
        fi
        source ~/.bashrc;
    else
        return 0;
    fi
fi
