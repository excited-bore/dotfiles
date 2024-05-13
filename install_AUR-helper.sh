. ./aliases/rlwrap_scripts.sh
. ./checks/check_system.sh

if [ "$distro_base" == "Arch" ]; then
    if [ ! -x "$(command -v auracle-git)" ] && \
       [ ! -x "$(command -v pbget)" ] && \
       [ ! -x "$(command -v repoctl)" ] && \
       [ ! -x "$(command -v yaah)" ] && \
       [ ! -x "$(command -v aurutils)" ] && \
       [ ! -x "$(command -v bauerbill)" ] && \
       [ ! -x "$(command -v PKGBUILDer)" ] && \
       [ ! -x "$(command -v rua)" ] && \
       [ ! -x "$(command -v aura)" ] && \
       [ ! -x "$(command -v aurman)" ] && \
       [ ! -x "$(command -v pacaur)" ] && \
       [ ! -x "$(command -v pakku)" ] && \
       [ ! -x "$(command -v paru)" ] && \
       [ ! -x "$(command -v pikaur)" ] && \
       [ ! -x "$(command -v trizen)" ] && \
       [ ! -x "$(command -v yay)" ] && \
       [ ! -x "$(command -v argon)" ] && \
       [ ! -x "$(command -v cylon)" ] && \
       [ ! -x "$(command -v kalu)" ] && \
       [ ! -x "$(command -v octopi)" ] && \
       [ ! -x "$(command -v pacseek)" ] && \
       [ ! -x "$(command -v pamac)" ] && \
       [ ! -x "$(command -v PkgBrowser)" ] && \
       [ ! -x "$(command -v yup)" ]; then
        
        # Install AUR helper since none known by Arch wiki have been detected
        
        printf "Your distro ($distro) seems to use 'pacman', yet no AUR helper has been detected\n"
        reade -Q "GREEN" -i "y" -p "Install an AUR helper ( yay )? [Y/n]:" "y n" insyay
        if [ "y" == "$insyay" ]; then 
           ./install_yay.sh
        fi
        unset insyay

    elif [ -x "$(command -v pamac)" ]; then
        printf "Your distro ($distro) seems to use 'pamac' as a possible AUR helper\n"
        # Check for AUR
        if grep -q "#EnableAUR" /etc/pamac.conf; then
            reade -Q "GREEN" -i "y" -p "Enable AUR in pamac? [Y/n]:" "y n" aurset
            if [ "$aurset" == "y" ]; then
                sudo sed -i 's|#EnableAUR|EnableAUR|g' /etc/pamac.conf 
            elif [ "$aurset" == "n" ]; then
                sudo sed -i 's|EnableAUR|#EnableAUR|g' /etc/pamac.conf
            fi
            unset aurset
        fi

        if grep -q "#KeepBuiltPkgs" /etc/pamac.conf; then
            reade -Q "GREEN" -i "y" -p "Keep build AUR packages? [Y/n]:" "y n" aurset1
            if [ "$aurset1" == "y" ]; then
                sudo sed -i 's|#KeepBuiltPkgs|KeepBuiltPkgs|g' /etc/pamac.conf 
            elif [ "$aurset1" == "n" ]; then
                sudo sed -i 's|KeepBuiltPkgs|#KeepBuiltPkgs|g' /etc/pamac.conf
            fi
            unset aurset1
        fi
        
        if grep -q "#CheckAURUpdates" /etc/pamac.conf; then
            reade -Q "GREEN" -i "y" -p "Check AUR for updates? [Y/n]:" "y n" aurset1
            if [ "$aurset1" == "y" ]; then
                sudo sed -i 's|#CheckAURUpdates|CheckAURUpdates|g' /etc/pamac.conf 
            elif [ "$aurset1" == "n" ]; then  
                sudo sed -i 's|CheckAURUpdates|#CheckAURUpdates|g' /etc/pamac.conf
            fi
            unset aurset1    
        fi

        if grep -q "#CheckAURVCSUpdates" /etc/pamac.conf; then
            reade -Q "GREEN" -i "y" -p "Check AUR for updates to development packages? [Y/n]:" "y n" aurset1
            if [ "$aurset1" == "y" ]; then
                sudo sed -i 's|#CheckAURVCSUpdates|CheckAURVCSUpdates|g' /etc/pamac.conf 
            elif [ "$aurset1" == "n" ]; then  
                sudo sed -i 's|CheckAURVCSUpdates|#CheckAURVCSUpdates|g' /etc/pamac.conf
            fi
            unset aurset1
        fi
        
        # Check for flatpak
        if [ ! -x "$(command -v flatpak)" ]; then
            reade -Q "GREEN" -i "y" -p "Install Flatpak? [Y/n]:" "y n" fltpakIns
            if [ "$fltpakIns" == "y" ]; then
                ./install_flatpak.sh
            fi
        fi
        
        if [ -x "$(command -v flatpak)" ]; then 
            if grep -q "#EnableFlatpak" /etc/pamac.conf; then
                reade -Q "GREEN" -i "y" -p "Enable flatpak in pamac? [Y/n]:" "y n" fltpak
                if [ "$fltpak" == "y" ]; then
                    yes | sudo pacman -Syu libpamac-flatpak-plugin
                    sudo sed -i 's|#EnableFlatpak|EnableFlatpak|g' /etc/pamac.conf 
                elif [ "$fltpak" == "n" ]; then  
                    sudo sed -i 's|EnableFlatpak|#EnableFlatpak|g' /etc/pamac.conf
                fi
                if grep -q "#CheckFlatpakUpdates" /etc/pamac.conf; then
                    if [ "$fltpak" == "y" ]; then 
                        reade -Q "GREEN" -i "y" -p "Check flatpak for updates? [Y/n]:" "y n" fltpak1
                        if [ "$fltpak1" == "y" ]; then
                            sudo sed -i 's|#CheckFlatpakUpdates|CheckFlatpakUpdates|g' /etc/pamac.conf 
                        elif [ "$fltpak1" == "n" ]; then  
                            sudo sed -i 's|CheckFlatpakUpdates|#CheckFlatpakUpdates|g' /etc/pamac.conf
                        fi
                        unset fltpak1
                    fi
                    unset fltpak
                fi
            fi
        fi

        # Check for snap
        if [ ! -x "$(command -v snap)" ]; then
            reade -Q "GREEN" -i "y" -p "Install Snap? [Y/n]:" "y n" snapIns
            if [ "$snapIns" == "y" ]; then
                ./install_snapd.sh
            fi
        fi
        if [ -x "$(command -v snap)" ]; then
            if grep -q "#EnableSnap" /etc/pamac.conf; then
                reade -Q "GREEN" -i "y" -p "Enable snap in pamac? [Y/n]:" "y n" snap
                if [ "$snap" == "y" ]; then
                    yes | sudo pacman -Syu libpamac-snap-plugin
                    sudo sed -i 's|#EnableSnap|EnableSnap|g' /etc/pamac.conf 
                elif [ "$snap" == "n" ]; then  
                    sudo sed -i 's|EnableSnap|#EnableSnap|g' /etc/pamac.conf
                fi
            unset snapIns snap
            fi
        fi
    fi
fi

