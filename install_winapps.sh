#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"
    else
        continue
    fi
else
    . ./checks/check_all.sh
fi

if [[ "$distro_base" == "Debian" ]]; then
    eval "$pac_ins -y qemu-kvm libvirt-bin bridge-utils virt-manager qemu virt-viewer spice-vdagent"
elif [[ "$distro" == "Arch" ]]; then
    eval "$pac_ins virt-manager qemu bridge-utils spice-vdagent"
fi

sudo systemctl enable --user libvirtd.service
sudo systemctl start --user libvirtd.service

#https://serverfault.com/questions/803283/how-do-i-list-virsh-networks-without-sudo

sudo usermod -aG libvirt $(whoami)
sudo usermod -aG kvm $(whoami)

if ! grep -q "LIBVIRT" $ENVVAR; then
    printf "\n#LIBVIRT\nexport LIBVIRT_DEFAULT_URI=qemu:///system\n" >> $ENVVAR
else
    sed -i "s|.export LIBVIRT_DEFAULT_URI=.*|export LIBVIRT_DEFAULT_URI=qemu:///system|g" $ENVVAR
fi
