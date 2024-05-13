if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f aliases/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if test "$(which vimpager)" == ''; then
    if test $distro_base == "Debian"; then
        (cd $TMPDIR
        git clone https://github.com/rkitover/vimpager
        cd vimpager
        sudo make install-deb
        cd ..
        rm -fr vimpager
        )
    else
        (cd $TMPDIR
        git clone https://github.com/rkitover/vimpager
        cd vimpager
        sudo make install
        cd ..
        rm -fr vimpager
        )
    fi
fi

reade -Q 'GREEN' -i 'y' -p "Set .vimrc as default vimpager read config for $USER? [Y/n]: " "y n" conf
if test "$conf" == "y"; then
    if grep -q "VIMPAGER_RC" $PATHVAR; then 
        sed -i "s|.export VIMPAGER_RC=|export VIMPAGER_RC=|g" $PATHVAR
        sed -i "s|export VIMPAGER_RC=.*|export VIMPAGER_RC=~/.vimrc|g" $PATHVAR
    else
        printf "\n# VIMPAGER\nexport VIMPAGER_RC=~/.vimrc\n" >> $PATHVAR
    fi
fi

reade -Q "GREEN" -i "y" -p "Set vimpager as default pager for $USER? [Y/n]: " "y n" moar_usr
if [ -z "$moar_usr" ] || [ "y" == "$moar_usr" ] || [ "Y" == "$moar_usr" ]; then
    if grep -q " PAGER=" $PATHVAR; then 
        sed -i "s|.export PAGER=|export PAGER=|g" $PATHVAR
        sed -i "s|export PAGER=.*|export PAGER=$(whereis vimpager | awk '{print $2;}')|g" $PATHVAR
    else
        printf "export PAGER=$(whereis vimpager | awk '{print $2;}')\n" >> $PATHVAR
    fi
fi

reade -Q 'YELLOW' -i 'y' -p "Set .vimrc as default vimpager read config for root? [Y/n]: " "y n" conf
if test "$conf" == "y"; then
    if sudo grep -q "VIMPAGER_RC" $PATHVAR_R; then 
        sudo sed -i "s|.export VIMPAGER_RC=|export VIMPAGER_RC=|g" $PATHVAR_R
        sudo sed -i "s|export VIMPAGER_RC=.*|export VIMPAGER_RC=~/.vimrc|g" $PATHVAR_R
    else
        printf "\n# VIMPAGER\nexport VIMPAGER_RC=~/.vimrc\n" | sudo tee -a $PATHVAR_R &> /dev/null
    fi
fi

    
reade -Q "YELLOW" -i "y" -p "Set vimpager default pager for root? [Y/n]: " "y n" moar_root
if [ -z "$moar_root" ] || [ "y" == "$moar_root" ] || [ "Y" == "$moar_root" ]; then
    if sudo grep -q " PAGER=" $PATHVAR_R; then
        sudo sed -i "s|.export PAGER=|export PAGER=|g" $PATHVAR_R
        sudo sed -i "s|export PAGER=.*|export PAGER=$(whereis vimpager | awk '{print $2;}')|g" $PATHVAR_R
    else
        printf "export PAGER=$(whereis vimpager | awk '{print $2;}')\n" | sudo tee -a $PATHVAR_R &> /dev/null
    fi
fi

