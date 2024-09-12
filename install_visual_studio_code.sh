if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
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

if ! type code &> /dev/null; then
    elif test "$distro_base" == "Arch"; then
        if ! test -z "$AUR_install"; then 
            eval "$AUR_install" visual-studio-code-bin
        else
            reade -Q 'GREEN' -i 'y' -p 'No AUR helper found. Install yay? [Y/n]: ' 'n' ins_yay
            if test $ins_yay == 'y'; then
                if ! test -f AUR_installers/install_yay.sh ; then
                     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/AUR_installers/install_yay.sh )" 
                else
                    . ./AUR_installers/install_yay.sh 
                fi 
            fi
            unset ins_yay 
        fi
    elif [ $distro_base == "Debian" ]; then
        if ! type wget &> /dev/null; then
           sudo apt install wget -y 
        fi
        if test -z $(apt list --installed software-properties-common 2> /dev/null); then
            sudo apt install -y software-properties-common 
        fi
        if test -z $(apt list --installed apt-transport-https 2> /dev/null); then
            sudo apt install -y apt-transport-https 
        fi
        wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - 
        sudo add-apt-repository "deb [arch=$arch] https://packages.microsoft.com/repos/vscode stable main" 
        sudo apt update 
        sudo apt install code 
    fi
fi

