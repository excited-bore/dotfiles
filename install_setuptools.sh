. ./checks/check_distro.sh

if [ $distro_base == "Arch" ]; then
    yes | sudo pacman -S make cmake
elif [ $distro_base == "Debian" ]; then
    yes | sudo apt install make cmake autoconf g++ gettext libncurses5-dev libtool libtool-bin 
fi

if which pip 2>/dev/null || echo FALSE ; then
    pip install setuptools
fi
if which pip3 2>/dev/null || echo FALSE ; then
    pip3 install setuptools
fi
