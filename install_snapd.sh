. ./checks/check_distro.sh
. ./checks/check_pathvar.sh

if [ "$distro_base" == "Arch" ];then
    yes | sudo pacman -S snapd
elif [ "$distro_base" == "Debian" ]; then
    yes | sudo apt install snapd
fi

if [ "$PATHVAR" == ~/.pathvariables.sh ]; then
   sed -i 's|#export SNAP=|export SNAP=|g' ~/.pa
fi

sudo systemctl daemon-reload
sudo snap install core
