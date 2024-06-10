if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro)" 
else
    . ./checks/check_system.sh
fi 

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi
if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi

answer=""
if [ ! -x "$(command -v most)" ]; then
    if test $distro_base == "Debian" ; then
        sudo apt install most
    elif test $distro == "Arch" || test $distro == "Manjaro"; then
        sudo pacman -S most
    fi
fi

most=$(whereis most)
reade -Q "GREEN" -i "y" -p "Set most default pager for $USER? [Y/n]: " "y n" most_usr
if [ "y" == "$most_usr" ]; then
    if grep -q "MOST" $PATHVAR; then 
        sed -i "s|.export MOST_SWITCHES=|export MOST_SWITCHES=|g" $PATHVAR 
        sed -i "s|.export PAGER=|export PAGER=|g" $PATHVAR
        sed -i "s|export PAGER=.*|export PAGER=$most|g" $PATHVAR
        sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=\$PAGER|g" $PATHVAR
        sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $PATHVAR
    else
        printf "export PAGER=$most\n" >> $PATHVAR
        printf "export SYSTEMD_PAGER=\$PAGER" >> $PATHVAR
        printf "export SYSTEMD_PAGERSECURE=1" >> $PATHVAR
    fi
fi
    
reade -Q "YELLOW" -i "y" -p "Set most default pager for root? [Y/n]: " "y n" most_root
if [ "y" == "$most_root" ]; then
    if sudo grep -q "MOST" $PATHVAR_R; then
        sudo sed -i "s|.export MOST_SWITCHES=.*|export MOST_SWITCHES=.*|g" $PATHVAR_R 
        sudo sed -i "s|.export PAGER=.*|export PAGER=$most|g" $PATHVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=$PAGER|g" $PATHVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $PATHVAR_R
    else
        printf "export PAGER=$most\n" | sudo tee -a $PATHVAR_R
        printf "export SYSTEMD_PAGER=\$PAGER\n" | sudo tee -a $PATHVAR_R
        printf "export SYSTEMD_PAGERSECURE=1\n" | sudo tee -a $PATHVAR_R
    fi
fi
