sudo sed -i 's|^GRUB_TIMEOUT_STYLE=hidden|#GRUB_TIMEOUT_STYLE=hidden|g' /etc/default/grub
sudo sed -i 's|#GRUB_HIDDEN_TIMEOUT=|GRUB_HIDDEN_TIMEOUT=|g' /etc/default/grub
sudo sed -i 's|GRUB_HIDDEN_TIMEOUT=0|GRUB_HIDDEN_TIMEOUT=5|g' /etc/default/grub
sudo update-grub
