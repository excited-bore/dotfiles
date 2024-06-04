if ! test -f checks/check_pathvar.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if [ "$distro" == "Manjaro" ]; then
    pamac install virt-manager qemu bridge-utils spice-vdagent
elif [ "$distro_base" == "Debian" ]; then
    sudo apt install -y qemu-kvm libvirt-bin bridge-utils virt-manager qemu virt-viewer spice-vdagent
elif [ "$distro" == "Arch" ]; then
    sudo pacman -S virt-manager qemu bridge-utils spice-vdagent
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
