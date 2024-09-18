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
    elif test "$distro_base" == "Arch"; then
        eval "$pac_ins flatpak python"
    elif test "$distro_base" == "Debian"; then
        if [[ "$XDG_CURRENT_DESKTOP" =~ "GNOME" ]]; then
            eval "$pac_ins gnome-software-plugin-flatpak gir1.2-xdpgtk* gir1.2-flatpak* python3 "
        else 
            eval "$pac_ins flatpak python3 gir1.2-xdpgtk* gir1.2-flatpak*"
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

if ! test -f ~/.bash_aliases.d/flatpacks.sh; then
    reade -Q "GREEN" -i "y" -p "Install flatpackwrapper? (For one-word flatpak aliases in terminal) [Y/n]: " "n" pam
    if [ -z $pam ] || [ "y" == $pam ]; then
        if ! test -f install_bashalias_completions.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashalias_completions.sh)" 
        else
             ./install_bashalias_completions.sh
        fi

        if test -f flatpak/.bash_aliases.d/flatpacks.sh; then
            file=flatpak/.bash_aliases.d/flatpacks.sh
        else
            dir1="$(mktemp -d -t tmux-XXXXXXXXXX)"
            curl -s -o $file1/flatpacks.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/flatpak/.bash_aliases.d/flatpacks.sh
            file=$dir1/flatpacks.sh
        fi
         
        if [ ! -f ~/.bash_aliases.d/flatpacks.sh ]; then
            cp -bfv $file ~/.bash_aliases.d/ 
            source ~/.bash_aliases.d/flatpacks.sh 
        fi
    fi    
fi
unset pam file

if ! echo $(flatpak list --columns=name) | grep -q "Flatseal"; then
    reade -Q "GREEN" -i "y" -p "Install GUI for configuring flatpak permissions - flatseal? [Y/n]: " "n" fltseal
    if [ -z $fltseal ] || [ "y" == $fltseal ]; then
        flatpak install flatseal
    fi
fi
unset fltseal

localauth=$(test -d /etc/polkit-1/localauthority/50-local.d && ! test -f /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla)
localauth_conf=$(test -d /etc/polkit-1/localauthority.conf.d/ && ! test -f /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf)
rules_d=$(test -d /etc/polkit-1/rules.d/ && ! test -f /etc/polkit-1/rules.d/90-nopasswd_global.rules)

if $localauth || $localauth_conf || $rules_d; then
    reade -Q "GREEN" -i "y" -p "Run installer for no password with pam? [Y/n]: " "n" pam
    if [ "y" == $pam ]; then
        if ! test -f install_polkit_wheel.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_polkit_wheel.sh)" 
        else
            ./install_polkit_wheel.sh
        fi
    fi
fi
unset pam
