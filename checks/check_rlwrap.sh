 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./check_distro.sh

if [ ! -x "$(command -v rlwrap)" ]; then
    echo "This will install rlwrap, used for autocompletion in bash scripts"
    echo "Interrupt the script to cancel installation"
    sleep 10
    if [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
        yes | sudo apt update && sudo apt install rlwrap
    elif [[ $distro == "Arch" || $distro_base == "Arch" ]]; then
        yes | sudo pacman -Su rlwrap
    fi
fi
