if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh)" 
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
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

if ! type flatpak &> /dev/null; then
    if test "$distro" == "Manjaro"; then
        pamac install flatpak libpamac-flatpak-plugin python
    elif test "$distro" == "Arch"; then
        sudo pacman -S flatpak python
    elif test "$distro_base" == "Debian"; then
        if [[ "$XDG_CURRENT_DESKTOP" =~ "GNOME" ]]; then
            sudo apt install gnome-software-plugin-flatpak gir1.2-xdpgtk* gir1.2-flatpak* python3 
        else 
            sudo apt install flatpak python3 gir1.2-xdpgtk* gir1.2-flatpak*
        fi
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
fi

if type flatpak &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Add flatpak dirs to path? (XDG_DATA_DIRS) [Y/n]: " "n" flpkvrs 
    if [ "$flpkvrs" == "y" ]; then
        if grep -q "FLATPAK" $ENVVAR; then
            sed -i 's|.export PATH=$PATH:$HOME/.local/bin/flatpak|export PATH=$PATH:$HOME/.local/bin/flatpak|g' $ENVVAR
            sed -i 's|.export FLATPAK=|export FLATPAK=$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share|'  $ENVVAR 
            sed -i 's|.export FLATPAK_ENABLE_SDK_EXT=|export FLATPAK_ENABLE_SDK_EXT=*|' $ENVVAR
            if ! grep -q 'XDG_DATA_DIRS*.*:$FLATPAK' $ENVVAR; then
                sed -i 's|.export XDG_DATA_DIRS=\(.*\) |export XDG_DATA_DIRS=\1:$FLATPAK|' $ENVVAR
            fi
        else
            echo 'export PATH=$PATH:$HOME/.local/bin/flatpak' >> $ENVVAR
            echo 'export XDG_DATA_DIRS=$XDG_DATA_DIRS:$HOME/.local/bin/flatpak:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share' >> $ENVVAR
        fi
    fi
fi
unset flpkvrs

reade -Q "GREEN" -i "y" -p "Install flatpackwrapper? (For one-word flatpak aliases in terminal) [Y/n]: " "n" pam
if [ -z $pam ] || [ "y" == $pam ]; then
    #if [ ! -d ~/.local/bin/flatpak/ ]; then
    #    mkdir -p ~/.local/bin/flatpak/
    #fi
    if ! test -f install_bashalias_completions.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashalias_completions.sh)" 
    else
         ./install_bashalias_completions.sh
    fi
    
    if [ ! -f ~/.bash_aliases.d/flatpacks.sh ]; then
        cp -bfv flatpak/.bash_aliases.d/flatpacks.sh ~/.bash_aliases.d/ 
        #touch ~/.bash_aliases.d/flatpacks.sh
        #printf "function flatpak (){\\n  env -u SESSION_MANAGER flatpak \"\$@\"\\n  if [ \"\$1\" == \"install\" ]; then\\n      python /usr/bin/update_flatpak_cli.py\\n   fi\\n}\\n" >> ~/.bash_aliases.d/flatpacks.sh
    fi
    
    #if ! type python &> /dev/null; then
    #    if test $distro_base == "Debian" && type python3 &> /dev/null; then
    #        sudo apt install python-is-python3
    #    else
    #        if test $distro == "Manjaro" || test $distro == "Arch"; then
    #            sudo pacman -S python
    #        elif test $distro_base == "Debian"; then
    #            sudo apt install python3 python-is-python3
    #        fi
    #    fi
    #fi


    #if ! sudo test -f /usr/bin/update_flatpak_cli.py; then
    #    sudo curl -o /usr/bin/update_flatpak_cli.py https://gist.githubusercontent.com/ssokolow/db565fd8a82d6002baada946adb81f68/raw/c23b3292441e01c6287de1b417b9e573bce6a571/update_flatpak_cli.py
    #    sudo chmod u+x /usr/bin/update_flatpak_cli.py
    #    sudo sed -i 's|\[ -a "|\[ -f "|g' /usr/bin/update_flatpak_cli.py
    #fi
    #  
    #if grep -q "FLATPAK" "$ENVVAR"; then
    #    sed -i 's|^export PATH=$PATH:$HOME/.local/bin/flatpak|export PATH=$PATH:$HOME/.local/bin/flatpak|g' $ENVVAR
    #else
    #    echo 'export PATH=$PATH:$HOME/.local/bin/flatpak' >> $ENVVAR
    #fi
    #echo "Wrapper script are bash-based and installed under '~/.local/bin/flatpak/' "
fi
unset pam

if echo $(flatpak list) | grep -q "Flatseal"; then
    reade -Q "GREEN" -i "y" -p "Install GUI for configuring flatpak permissions - flatseal? [Y/n]: " "n" fltseal
    if [ -z $fltseal ] || [ "y" == $fltseal ]; then
        flatpak install flatseal
    fi
fi
unset fltseal

if ! test -f /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla; then
    reade -Q "GREEN" -i "y" -p "Run installer for no password with pam? [Y/n]: " "n" pam
    if [ -z $pam ] || [ "y" == $pam ]; then
        if ! test -f install_polkit_wheel.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_polkit_wheel.sh)" 
        else
            ./install_polkit_wheel.sh
        fi
    fi
fi
unset pam
