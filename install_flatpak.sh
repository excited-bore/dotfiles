#!/usr/bin/env bash

if ! test -f checks/check_all.sh; then
    if type curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
    else 
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n" 
        return 1 || exit 1 
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
     source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh) 
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi


if ! type flatpak &> /dev/null; then
    if [[ "$distro" == "Manjaro" ]]; then
        pamac install flatpak libpamac-flatpak-plugin python
    elif [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins} flatpak python"
    elif [[ "$distro_base" == "Debian" ]]; then
        if [[ "$XDG_CURRENT_DESKTOP" =~ "GNOME" ]]; then
            eval "${pac_ins} gnome-software-plugin-flatpak gir1.2-xdpgtk* gir1.2-flatpak* python3 "
        else 
            eval "${pac_ins} flatpak python3 gir1.2-xdpgtk* gir1.2-flatpak*"
        fi
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
fi

if hash flatpak &> /dev/null && test -z "$FLATPAK"; then
    readyn -p "Add flatpak dirs to path? (XDG_DATA_DIRS)" flpkvrs 
    if [[ "$flpkvrs" == "y" ]]; then
        if grep -q "FLATPAK" $ENV; then
            sed -i 's|.export PATH=$PATH:$HOME/.local/bin|export PATH=$PATH:$HOME/.local/bin|g' $ENV
            sed -i 's|.export FLATPAK=|export FLATPAK=$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share|'  $ENV 
            sed -i 's|.export FLATPAK_ENABLE_SDK_EXT=|export FLATPAK_ENABLE_SDK_EXT=*|' $ENV
            if ! grep -q 'XDG_DATA_DIRS*.*:$FLATPAK' $ENV; then
                sed -i 's|.export XDG_DATA_DIRS=\(.*\) |export XDG_DATA_DIRS=\1:$FLATPAK|' $ENV
            fi
        else
            echo 'export PATH=$PATH:$HOME/.local/bin' >> $ENV
            echo 'export XDG_DATA_DIRS=$XDG_DATA_DIRS:$HOME/.local/bin/flatpak:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share' >> $ENV
        fi
    fi
fi
unset flpkvrs

if ! test -f ~/.bash_aliases.d/flatpacks.sh; then
    readyn -p "Install flatpackwrapper? (For one-word flatpak aliases in terminal)" pam
    if [[ "y" == $pam ]]; then
        if ! test -f install_bashalias_completions.sh; then
             source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashalias_completions.sh) 
        else
             . ./install_bashalias_completions.sh
        fi

        if test -f flatpak/.bash_aliases.d/flatpacks.sh; then
            file=flatpak/.bash_aliases.d/flatpacks.sh
        else
            dir1="$(mktemp -d -t flatpak-XXXXXXXXXX)"
            curl -o $file1/flatpacks.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/flatpak/.bash_aliases.d/flatpacks.sh
            file=$dir1/flatpacks.sh
        fi
         
        if ! test -f ~/.bash_aliases.d/flatpacks.sh; then
            cp $file ~/.bash_aliases.d/ 
            test -n "$BASH_VERSION" && source ~/.bash_aliases.d/flatpacks.sh 
        fi
    fi    
fi
unset pam file dir1

if ! echo $(flatpak list --columns=name) | grep -q "Flatseal"; then
    readyn -p "Install GUI for configuring flatpak permissions - flatseal?" fltseal
    if [[ "y" == $fltseal ]]; then
        flatpak install flatseal
    fi
fi
unset fltseal

if ! sudo test -f /etc/polkit/49-nopasswd_global.pkla && ! sudo test -f /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf && ! sudo test -f /etc/polkit-1/rules.d/90-nopasswd_global.rules; then
    readyn -p "Run installer for no password with pam / polkit?" pam
    if [[ "y" == "$pam" ]]; then
        if ! test -f install_polkit_wheel.sh; then
             source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_polkit_wheel.sh) 
        else
            . ./install_polkit_wheel.sh
        fi
    fi
    unset pam
fi
