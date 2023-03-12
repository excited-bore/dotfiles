. ./check_distro.sh

if [ ! -x "$(command -v rlwrap)" ]; then
    echo "This will install rlwrap, used for autocompletion in bash scripts"
    echo "Interrupt the script to cancel installation"
    sleep 10
    if [[ $dist == "Raspbian" || $dist == "Debian" ]]; then
        yes | sudo apt update && sudo apt install rlwrap
    elif [[ $dist == "Arch" || $dist == "Manjaro" ]]; then
        yes | sudo pacman -Su rlwrap
    fi
fi
