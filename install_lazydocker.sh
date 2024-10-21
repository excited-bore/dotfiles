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
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi


if ! type lazydocker &> /dev/null; then
    if test $distro_base == "Arch" && ! test -z "$AUR_ins"; then
        eval "$AUR_ins lazydocker"
    else
        if ! type go &> /dev/null || [[ $(go version | awk '{print $3}' | cut -c 3-) < 1.19 ]]; then
           if ! test -f install_go.sh; then
                 tmp=$(mktemp) && wget -O $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh
                ./$tmp 
            else
                ./install_go.sh
            fi 
            go install github.com/jesseduffield/lazydocker@latest 
        fi
        #if ! type curl &> /dev/null; then
        #    if test $distro_base == 'Debian'; then
        #        eval "$pac_ins curl"
        #    elif test $distro_base == 'Arch'; then
        #        eval "$pac_ins curl  "
        #    fi
        #fi
        #curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    fi
    lazydocker --version
    unset nstll
fi
