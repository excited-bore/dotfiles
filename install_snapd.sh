if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if test "$distro" == "Arch" || test "$distro" == "Manjaro"; then
    sudo pacman -S snapd
elif [ "$distro_base" == "Debian" ]; then
    sudo apt install snapd
fi

if grep -q "SNAP" $ENVVAR; then
    sed -i 's|#export PATH=\(/bin/snap.*\)|export PATH=\1|g' "$ENVVAR"
else
    echo "export PATH=/bin/snap:/var/lib/snapd/snap/bin:$PATH" >> "$ENVVAR"
fi

sudo systemctl daemon-reload
sudo snap install core
