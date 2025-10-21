# https://wiki.archlinux.org/title/Doas

hash doas &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


if [[ $distro_base == "Arch" ]]; then
    eval "$pac_ins_y opendoas "
elif [[ $distro_base == "Debian" ]]; then
    eval "$pac_ins_y doas"
fi

sed -i "s/user/$USER/g" $TOP/cli-tools/doas/doas.conf
sudo cp $TOP/cli-tools/doas/doas.conf /etc/doas.conf

#./install_polkit_wheel.sh

if test -d ~/.aliases.d/; then
    readyn -p "Install doas.sh? (~/.aliases.d/doas.sh)" doas
    if [[ $doas == 'y' ]]; then 
        cp $TOP/cli-tools/doas/doas.sh ~/.aliases.d/doas.sh
        #readyn -p "Install doas.sh for root? (/root/.aliases.d/doas.sh" gdoas
        #if [[ $gdoas == 'y' ]]; then
        #    sudo cp $TOP/cli-tools/doas/doas.sh /root/.aliases.d/doas.sh
        #fi
    fi
    unset doas gdoas
fi

echo "Enter manually: chown root:root -c /etc/doas.conf; chmod 0644 -c /etc/doas.conf; doas -C /etc/doas.conf && echo 'config ok' || echo 'config error' ";
su -;
sudo groupadd wheel && sudo usermod -aG wheel "$USER"
