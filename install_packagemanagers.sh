./readline/rlwrap_scripts.sh
./checks/check_distro.sh

if [ "$distro_base" == "Arch" ]; then
    if [ -x "$(command -v pamac)" ]; then
        printf "Your distro ($distro) seems to use 'pacman' as it's packagemanager, and 'pamac' as a possible AUR helper\n"
        # Check for AUR
        reade -Q "GREEN" -i "y" -p "Enable AUR in pamac? [Y/n]:" "y n" aurset
        if [ "$aurset" == "y" ]; then
            sudo sed -i 's|#EnableAUR|EnableAUR|g' /etc/pamac.conf 
        elif [ "$aurset" == "n" ]; then
            sudo sed -i 's|EnableAUR|#EnableAUR|g' /etc/pamac.conf
        fi
        
        if [ "$aurset" == "y" ]; then
            reade -Q "GREEN" -i "y" -p "Keep build AUR packages? [Y/n]:" "y n" aurset1
            if [ "$aurset1" == "y" ]; then
                sudo sed -i 's|#KeepBuiltPkgs|KeepBuiltPkgs|g' /etc/pamac.conf 
            elif [ "$aurset1" == "n" ]; then
                sudo sed -i 's|KeepBuiltPkgs|#KeepBuiltPkgs|g' /etc/pamac.conf
            fi
            unset aurset1
            
            reade -Q "GREEN" -i "y" -p "Check AUR for updates? [Y/n]:" "y n" aurset1
            if [ "$aurset1" == "y" ]; then
                sudo sed -i 's|#CheckAURUpdates|CheckAURUpdates|g' /etc/pamac.conf 
            elif [ "$aurset1" == "n" ]; then  
                sudo sed -i 's|CheckAURUpdates|#CheckAURUpdates|g' /etc/pamac.conf
            fi
            unset aurset1    
            
            reade -Q "GREEN" -i "y" -p "Check AUR for updates to development packages? [Y/n]:" "y n" aurset1
            if [ "$aurset1" == "y" ]; then
                sudo sed -i 's|#CheckAURVCSUpdates|CheckAURVCSUpdates|g' /etc/pamac.conf 
            elif [ "$aurset1" == "n" ]; then  
                sudo sed -i 's|CheckAURVCSUpdates|#CheckAURVCSUpdates|g' /etc/pamac.conf
            fi
            unset aurset1
        fi
        unset aurset
        
        # Check for flatpak
        if [ ! -x "$(command -v flatpak)" ]; then
            reade -Q "GREEN" -i "y" -p "Install Flatpak? [Y/n]:" "y n" fltpakIns
            if [ "$fltpakIns" == "y" ]; then
                . ./install_flatpak.sh
            fi
        fi
        if [ -x "$(command -v flatpak)" ]; then 
            reade -Q "GREEN" -i "y" -p "Enable flatpak in pamac? [Y/n]:" "y n" fltpak
            if [ "$fltpak" == "y" ]; then
                yes | sudo pacman -Syu libpamac-flatpak-plugin
                sudo sed -i 's|#EnableFlatpak|EnableFlatpak|g' /etc/pamac.conf 
            elif [ "$fltpak" == "n" ]; then  
                sudo sed -i 's|EnableFlatpak|#EnableFlatpak|g' /etc/pamac.conf
            fi
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

        # Check for snap
        if [ ! -x "$(command -v snap)" ]; then
            reade -Q "GREEN" -i "y" -p "Install Snap? [Y/n]:" "y n" snapIns
            if [ "$snapIns" == "y" ]; then
                . ./install_snapd.sh
            fi
        fi
        if [ -x "$(command -v snap)" ]; then
        reade -Q "GREEN" -i "y" -p "Enable snap in pamac? [Y/n]:" "y n" snap
        if [ "$snap" == "y" ]; then
            yes | sudo pacman -Syu libpamac-snap-plugin
            sudo sed -i 's|#EnableSnap|EnableSnap|g' /etc/pamac.conf 
        elif [ "$snap" == "n" ]; then  
            sudo sed -i 's|EnableSnap|#EnableSnap|g' /etc/pamac.conf
        fi
        unset snap
    fi
fi

