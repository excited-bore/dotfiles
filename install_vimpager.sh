#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi


if type nvimpager &> /dev/null; then
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

readyn -p "Set .vimrc as default vimpager read config for $USER?" conf
if [[ "$conf" == "y" ]]; then
    if grep -q "VIMPAGER_RC" $ENVVAR; then 
        sed -i "s|.export VIMPAGER_RC=|export VIMPAGER_RC=|g" $ENVVAR
        sed -i "s|export VIMPAGER_RC=.*|export VIMPAGER_RC=~/.vimrc|g" $ENVVAR
    else
        printf "\n# VIMPAGER\nexport VIMPAGER_RC=~/.vimrc\n" >> $ENVVAR
    fi
fi

readyn -p "Set vimpager as default pager for $USER?" moar_usr
if [ -z "$moar_usr" ] || [ "y" == "$moar_usr" ] || [ "Y" == "$moar_usr" ]; then
    if grep -q " PAGER=" $ENVVAR; then 
        sed -i "s|.export PAGER=|export PAGER=|g" $ENVVAR
        sed -i "s|export PAGER=.*|export PAGER=$(whereis vimpager | awk '{print $2;}')|g" $ENVVAR
    else
        printf "export PAGER=$(whereis vimpager | awk '{print $2;}')\n" >> $ENVVAR
    fi
fi

reade -Q 'YELLOW' -i 'y' -p "Set .vimrc as default vimpager read config for root?" conf
if test "$conf" == "y"; then
    if sudo grep -q "VIMPAGER_RC" $ENVVAR_R; then 
        sudo sed -i "s|.export VIMPAGER_RC=|export VIMPAGER_RC=|g" $ENVVAR_R
        sudo sed -i "s|export VIMPAGER_RC=.*|export VIMPAGER_RC=~/.vimrc|g" $ENVVAR_R
    else
        printf "\n# VIMPAGER\nexport VIMPAGER_RC=~/.vimrc\n" | sudo tee -a $ENVVAR_R &> /dev/null
    fi
fi

reade -Q "YELLOW" -i "y" -p "Set vimpager default pager for root?" moar_root
if [ -z "$moar_root" ] || [ "y" == "$moar_root" ] || [ "Y" == "$moar_root" ]; then
    if sudo grep -q " PAGER=" $ENVVAR_R; then
        sudo sed -i "s|.export PAGER=|export PAGER=|g" $ENVVAR_R
        sudo sed -i "s|export PAGER=.*|export PAGER=$(whereis vimpager | awk '{print $2;}')|g" $ENVVAR_R
    else
        printf "export PAGER=$(whereis vimpager | awk '{print $2;}')\n" | sudo tee -a $ENVVAR_R &> /dev/null
    fi
fi

