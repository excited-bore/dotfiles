. ./checks/check_distro.sh
. ./checks/check_pathvar.sh

if [ "$distro_base" == "Arch" ];then
    yes | sudo pacman -S snapd
elif [ "$distro_base" == "Debian" ]; then
    yes | sudo apt install snapd
fi

if grep -q "SNAP" $PATHVAR; then
    sed -i 's|#export PATH=\(/bin/snap.*\)|export PATH=\1|g' "$PATHVAR"
else
    echo "export PATH=/bin/snap:/var/lib/snapd/snap/bin:$PATH" >> "$PATHVAR"
fi

sudo systemctl daemon-reload
sudo snap install core
