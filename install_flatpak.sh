. ./checks/check_distro.sh
. ./checks/check_pathvar.sh
. ./readline/rlwrap_scripts.sh

if [ $distro == "Manjaro" ]; then
    yes | pamac install flatpak libpamac-flatpak-plugin python
elif [ $distro == "Arch" ]; then
    yes | sudo pacman -Su flatpak python
elif [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
    sudo apt update
    if "$XDG_CURRENT_DESKTOP" == "GNOME"; then
        yes | sudo apt install gnome-software-plugin-flatpak gir1.2-xdpgtk* gir1.2-flatpak* python3 
    else 
        yes | sudo apt install flatpak python3 gir1.2-xdpgtk* gir1.2-flatpak*
    fi
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

if [ -x "$(command -v flatpak)" ]; then
    reade -Q "GREEN" -i "y" -p "Add flatpak dirs to path? (XDG_DATA_DIRS) [Y/n]:" "y n" flpkvrs 
    if [ "$flpkvrs" == "y" ]; then
        if grep -q "FLATPAK" $PATHVAR; then
            sed -i 's|.export PATH=$PATH:$HOME/.local/bin/flatpak|export PATH=$PATH:$HOME/.local/bin/flatpak|g' $PATHVAR
            sed -i 's|.export FLATPAK=|export FLATPAK=$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share|'  $PATHVAR 
            sed -i 's|.export FLATPAK_ENABLE_SDK_EXT=|export FLATPAK_ENABLE_SDK_EXT=|' $PATHVAR
            if ! grep -q 'XDG_DATA_DIRS*.*:$FLATPAK' $PATHVAR; then
                sed -i 's|.export XDG_DATA_DIRS=\(.*\) |export XDG_DATA_DIRS=\1:$FLATPAK|' $PATHVAR
            fi
        else
            echo 'export PATH=$PATH:$HOME/.local/bin/flatpak' >> $PATHVAR
            echo 'export XDG_DATA_DIRS=$XDG_DATA_DIRS:$HOME/.local/bin/flatpak:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share' >> $PATHVAR
        fi
    fi
fi
unset flpkvrs

reade -Q "GREEN" -i "y" -p "Install flatpackwrapper? (For one-word flatpak apps in terminal) [Y/n]:" "y n" pam
if [ -z $pam ] || [ "y" == $pam ]; then
    if [ ! -d ~/.local/bin/flatpak/ ]; then
        mkdir -p ~/.local/bin/flatpak/
    fi
    if [ ! -f /usr/bin/update_flatpak_cli.py ]; then
        sudo wget -P /usr/bin/ https://gist.githubusercontent.com/ssokolow/db565fd8a82d6002baada946adb81f68/raw/c23b3292441e01c6287de1b417b9e573bce6a571/update_flatpak_cli.py
        sudo chmod u+x /usr/bin/update_flatpak_cli.py
    fi
    if [ ! -f ~/.bash_aliases.d/flatpackwrapper.sh ]; then
        touch ~/.bash_aliases.d/flatpackwrapper.sh
        printf "function flatpak (){\\n  env -u SESSION_MANAGER flatpak \"\$@\"\\n   python /usr/bin/update_flatpak_cli.py\\n}\\n" >> ~/.bash_aliases.d/flatpackwrapper.sh
    fi
    if grep -q "FLATPAK" "$PATHVAR"; then
        sed -i 's|.export PATH=$PATH:$HOME/.local/bin/flatpak|export PATH=$PATH:$HOME/.local/bin/flatpak|g' $PATHVAR
    else
        echo 'export PATH=$PATH:$HOME/.local/bin/flatpak' >> $PATHVAR
    fi
fi
unset pam

reade -Q "GREEN" -i "y" -p "Run installer for no password with pam? [Y/n]:" "y n" pam
if [ -z $pam ] || [ "y" == $pam ]; then
    ./install_polkit_wheel.sh
fi
unset pam

flatpak update
