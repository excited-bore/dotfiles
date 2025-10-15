if ! [ -f checks/check_all.sh ]; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
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
sudo cp doas/doas.conf /etc/doas.conf

#./install_polkit_wheel.sh

readyn -p "Install doas.sh? (~/.aliases.d/doas.sh)" doas
if [[ $doas == 'y' ]]; then 
    if ! [ -d ~/.aliases.d/ ]; then
        mkdir ~/.aliases.d/
    fi
    cp doas/doas.sh ~/.aliases.d/doas.sh
    readyn -p "Install doas.sh globally? (/root/.aliases.d/doas.sh" gdoas
    if [[ $gdoas == 'y' ]]; then
        if ! sudo test -d ~/.aliases.d/ ; then
            sudo mkdir /root/.aliases.d/
        fi
        if ! sudo grep -q "/root/.aliases.d" /root/.bashrc; then

            printf "\nif [[ -d /root/.aliases.d/ ]]; then\n  for alias in /root/.aliases.d/*.sh; do\n      . \"\$alias\" \n  done\nfi" | sudo tee -a /root/.bashrc &> /dev/null
        fi
        sudo cp doas/doas.sh /root/.aliases.d/doas.sh
    fi
fi

echo "Enter: chown root:root -c /etc/doas.conf; chmod 0644 -c /etc/doas.conf; doas -C /etc/doas.conf && echo 'config ok' || echo 'config error' ";
su -;
sudo groupadd wheel && sudo usermod -aG wheel "$USER"
