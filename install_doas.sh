#!/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if test $distro == "Arch" || test $distro == "Manjaro"; then
    sudo pacman -S opendoas 
elif test $distro_base == "Debian"; then
    sudo apt install doas
fi 

sed -i "s/user/$USER/g" doas/doas.conf
sudo cp -f doas/doas.conf /etc/doas.conf

#./install_polkit_wheel.sh

read -p "Install doas.sh? (~/.bash_aliases.d/doas.sh) [Y/n]:" doas
if [ -z $doas ]; then 
    if [ ! -d ~/.bash_aliases.d/ ]; then
        mkdir ~/.bash_aliases.d/
    fi
    cp -f doas/doas.sh ~/.bash_aliases.d/doas.sh
    read -p "Install doas.sh globally? (/root/.bash_aliases.d/doas.sh [Y/n]:" gdoas  
    if [ -z $gdoas ]; then
        if ! sudo test -d ~/.bash_aliases.d/ ; then
            sudo mkdir /root/.bash_aliases.d/
        fi
        if ! sudo grep -q "/root/.bash_aliases.d" /root/.bashrc; then

            printf "\nif [[ -d /root/.bash_aliases.d/ ]]; then\n  for alias in /root/.bash_aliases.d/*.sh; do\n      . \"\$alias\" \n  done\nfi" | sudo tee -a /root/.bashrc > /dev/null
        fi
        sudo cp -f doas/doas.sh /root/.bash_aliases.d/doas.sh
    fi
fi

echo "Enter: chown root:root -c /etc/doas.conf; chmod 0644 -c /etc/doas.conf; doas -C /etc/doas.conf && echo 'config ok' || echo 'config error' ";
su -;
sudo groupadd wheel && sudo usermod -aG wheel "$USER"
