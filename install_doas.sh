#!/usr/bin/env bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

if [[ $distro_base == "Arch" ]]; then
    eval "$pac_ins opendoas "
elif [[ $distro_base == "Debian" ]]; then
    eval "$pac_ins doas"
fi

sed -i "s/user/$USER/g" doas/doas.conf
sudo cp -f doas/doas.conf /etc/doas.conf

#./install_polkit_wheel.sh

readyn -p "Install doas.sh? (~/.bash_aliases.d/doas.sh)" doas
if [ -z $doas ]; then 
    if ! [ -d ~/.bash_aliases.d/ ]; then
        mkdir ~/.bash_aliases.d/
    fi
    cp -f doas/doas.sh ~/.bash_aliases.d/doas.sh
    readyn -p "Install doas.sh globally? (/root/.bash_aliases.d/doas.sh" gdoas
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
