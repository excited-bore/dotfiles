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
    if grep -q "VIMPAGER_RC" $ENV; then 
        sed -i "s|.export VIMPAGER_RC=|export VIMPAGER_RC=|g" $ENV
        sed -i "s|export VIMPAGER_RC=.*|export VIMPAGER_RC=~/.vimrc|g" $ENV
    else
        printf "\n# VIMPAGER\nexport VIMPAGER_RC=~/.vimrc\n" >> $ENV
    fi
fi

readyn -p "Set vimpager as default pager for $USER?" moar_usr
if [ -z "$moar_usr" ] || [ "y" == "$moar_usr" ] || [ "Y" == "$moar_usr" ]; then
    if grep -q " PAGER=" $ENV; then 
        sed -i "s|.export PAGER=|export PAGER=|g" $ENV
        sed -i "s|export PAGER=.*|export PAGER=$(whereis vimpager | awk '{print $2;}')|g" $ENV
    else
        printf "export PAGER=$(whereis vimpager | awk '{print $2;}')\n" >> $ENV
    fi
fi

reade -Q 'YELLOW' -i 'y' -p "Set .vimrc as default vimpager read config for root?" conf
if test "$conf" == "y"; then
    if sudo grep -q "VIMPAGER_RC" $ENV_R; then 
        sudo sed -i "s|.export VIMPAGER_RC=|export VIMPAGER_RC=|g" $ENV_R
        sudo sed -i "s|export VIMPAGER_RC=.*|export VIMPAGER_RC=~/.vimrc|g" $ENV_R
    else
        printf "\n# VIMPAGER\nexport VIMPAGER_RC=~/.vimrc\n" | sudo tee -a $ENV_R &> /dev/null
    fi
fi

reade -Q "YELLOW" -i "y" -p "Set vimpager default pager for root?" moar_root
if [ -z "$moar_root" ] || [ "y" == "$moar_root" ] || [ "Y" == "$moar_root" ]; then
    if sudo grep -q " PAGER=" $ENV_R; then
        sudo sed -i "s|.export PAGER=|export PAGER=|g" $ENV_R
        sudo sed -i "s|export PAGER=.*|export PAGER=$(whereis vimpager | awk '{print $2;}')|g" $ENV_R
    else
        printf "export PAGER=$(whereis vimpager | awk '{print $2;}')\n" | sudo tee -a $ENV_R &> /dev/null
    fi
fi

