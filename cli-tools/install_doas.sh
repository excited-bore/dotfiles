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

if ! test -f $TOP/checks/check_completions_dir.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)
else
    . $TOP/checks/check_completions_dir.sh
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
    cp doas/doas.sh ~/.aliases.d/doas.sh
    readyn -p "Install doas.sh for root? (/root/.aliases.d/doas.sh" gdoas
    if [[ $gdoas == 'y' ]]; then
        sudo cp doas/doas.sh /root/.aliases.d/doas.sh
    fi
fi
unset doas gdoas

echo "Enter manually: chown root:root -c /etc/doas.conf; chmod 0644 -c /etc/doas.conf; doas -C /etc/doas.conf && echo 'config ok' || echo 'config error' ";
su -;
sudo groupadd wheel && sudo usermod -aG wheel "$USER"
