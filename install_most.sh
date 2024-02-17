. ./checks/check_distro.sh
. ./checks/check_pathvar.sh
. ./aliases/rlwrap_scripts.sh

answer=""
if [ ! -x "$(command -v most)" ]; then
    if test $distro_base == "Debian" ; then
        yes | sudo apt install most
    elif test $distro_base == "Arch"; then
        yes | sudo pacman -Su most
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
