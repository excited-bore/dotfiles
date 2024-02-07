. ./checks/check_distro.sh
. ./checks/check_pathvar.sh

if [ "$dist" == "Manjaro" ]; then
    pamac install virt-manager qemu bridge-utils spice-vdagent
elif [ "$dist_base" == "Debian" ]; then
    sudo apt install -y qemu-kvm libvirt-bin bridge-utils virt-manager qemu virt-viewer spice-vdagent
elif [ "$dist_base" == "Arch" ]; then
    sudo pacman -Su virt-manager qemu bridge-utils spice-vdagent
fi

sudo systemctl enable --user libvirtd.service
sudo systemctl start --user libvirtd.service

#https://serverfault.com/questions/803283/how-do-i-list-virsh-networks-without-sudo

sudo usermod -aG libvirt $(whoami)
sudo usermod -aG kvm $(whoami)

if ! grep -q "LIBVIRT" $PATHVAR; then
    printf "\n#LIBVIRT\nexport LIBVIRT_DEFAULT_URI=qemu:///system\n" >> $PATHVAR
else
    sed -i "s|.export LIBVIRT_DEFAULT_URI=.*|export LIBVIRT_DEFAULT_URI=qemu:///system|g" $PATHVAR
fi
