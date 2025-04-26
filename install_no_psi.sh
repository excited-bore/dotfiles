# https://discussion.fedoraproject.org/t/what-is-psimon-process/108488

if ! sudo grep -q "psi=0 " /etc/default/grub; then
    sudo sed -i 's,GRUB_CMDLINE_LINUX_DEFAULT=",GRUB_CMDLINE_LINUX_DEFAULT="psi=0 ,g' /etc/default/grub
    sudo update-grub
fi

