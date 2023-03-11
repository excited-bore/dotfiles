if sudo grep -q "quiet " /etc/default/grub; then
    sudo sed -i "s,quiet ,,g" /etc/default/grub
fi

