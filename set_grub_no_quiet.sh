# !/bin/bash
echo "These next $(tput setaf 1)sudos$(tput sgr0) will remove 'quiet' from 'GRUB_CMDLINE_LINUX_DEFAULT' in /etc/default/grub and re-generate the grub.cfg file"
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT="/ s/quiet//' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
