. ./check_distro.sh

if [[ $dist == "Manjaro" || $dist == "Arch" ]]; then
    sudo pacman -S make cmake
elif [[ $dist == "Debian" || $dist == "Raspbian" ]]; then
    sudo apt install make cmake autoconf g++ gettext libncurses5-dev libtool libtool-bin 
fi

if which pip 2>/dev/null || echo FALSE ; then
    pip install setuptools
fi
if which pip3 2>/dev/null || echo FALSE ; then
    pip3 install setuptools
fi