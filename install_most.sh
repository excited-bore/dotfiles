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

SCRIPT_DIR=$(get-script-dir)

if ! test -f checks/check_envvar.sh; then
     source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh) 
else
    . ./checks/check_envvar.sh
fi

if ! command -v most &> /dev/null; then
    if [[ $distro_base == "Arch" ]] || [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins most"
    fi
fi

most=$(whereis most)
readyn -p "Set most default pager for $USER?" most_usr
if [[ "y" == "$most_usr" ]]; then
    if grep -q "MOST" $ENVVAR; then 
        sed -i "s|.export MOST_SWITCHES=|export MOST_SWITCHES=|g" $ENVVAR 
        sed -i "s|.export PAGER=|export PAGER=|g" $ENVVAR
        sed -i "s|export PAGER=.*|export PAGER=$most|g" $ENVVAR
        sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=\$PAGER|g" $ENVVAR
        sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENVVAR
    else
        printf "export PAGER=$most\n" >> $ENVVAR
        printf "export SYSTEMD_PAGER=\$PAGER" >> $ENVVAR
        printf "export SYSTEMD_PAGERSECURE=1" >> $ENVVAR
    fi
fi
    
readyn -Y 'YELLOW' -p "Set most default pager for root?" most_root
if [[ "y" == "$most_root" ]]; then
    if sudo grep -q "MOST" $ENVVAR_R; then
        sudo sed -i "s|.export MOST_SWITCHES=.*|export MOST_SWITCHES=.*|g" $ENVVAR_R 
        sudo sed -i "s|.export PAGER=.*|export PAGER=$most|g" $ENVVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=$PAGER|g" $ENVVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENVVAR_R
    else
        printf "export PAGER=$most\n" | sudo tee -a $ENVVAR_R
        printf "export SYSTEMD_PAGER=\$PAGER\n" | sudo tee -a $ENVVAR_R
        printf "export SYSTEMD_PAGERSECURE=1\n" | sudo tee -a $ENVVAR_R
    fi
fi
