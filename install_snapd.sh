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
    update_system
else
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi 

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if test "$distro" == "Arch" || test "$distro" == "Manjaro"; then
    sudo pacman -S snapd
elif [ "$distro_base" == "Debian" ]; then
    sudo apt install snapd
fi

if grep -q "SNAP" $PATHVAR; then
    sed -i 's|#export PATH=\(/bin/snap.*\)|export PATH=\1|g' "$PATHVAR"
else
    echo "export PATH=/bin/snap:/var/lib/snapd/snap/bin:$PATH" >> "$PATHVAR"
fi

sudo systemctl daemon-reload
sudo snap install core
