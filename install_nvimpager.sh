if ! test -f checks/check_distro.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro.sh)" 
else
    . ./checks/check_distro.sh
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

if ! type nvim > /dev/null ; then
   if ! test -f ./install_nvim.sh; then
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/install_fzf.sh)" 
    else
        ./install_nvim.sh
    fi 
fi

if test "$(which scdoc)" == ''; then
    if test $distro_base == "Debian"; then
       yes | sudo apt install scdoc
    elif test $distro_base == "Arch"; then
       yes | sudo pacman -Su scdoc
    fi
fi

if test "$(which nvimpager)" == ''; then
    mkdir $TMPDIR/nvimpager
    (cd $TMPDIR/nvimpager
    git clone https://github.com/lucc/nvimpager
    cd nvimpager
    make PREFIX=$HOME/.local install
    cd ../..
    rm -fr nvimpager
    )
fi

reade -Q 'GREEN' -i 'y' -p 'Copy configuration from ~/.config/nvim/ to ~/.config/nvimpager/ ? [Y/n]: ' "y n" conf
if test "$conf" == "y"; then
    if ! test -d ~/.config/nvimpager; then
        mkdir ~/.config/nvimpager
    fi
    cp -fv ~/.config/nvim/* ~/.config/nvimpager/ 
fi

reade -Q "GREEN" -i "y" -p "Set nvimpager as default pager for $USER? [Y/n]: " "y n" moar_usr
if [ -z "$moar_usr" ] || [ "y" == "$moar_usr" ] || [ "Y" == "$moar_usr" ]; then
    if grep -q "nvimpager" $PATHVAR; then 
        sed -i "s|.export PAGER=|export PAGER=|g" $PATHVAR
        sed -i "s|export PAGER=.*|export PAGER=$(whereis nvimpager | awk '{print $2;}')|g" $PATHVAR
        sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=\$PAGER|g" $PATHVAR
        sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $PATHVAR
    else
        printf "export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight'\n" >> $PATHVAR
        printf "export PAGER=$(whereis nvimpager | awk '{print $2;}')\n" >> $PATHVAR
        printf "export SYSTEMD_PAGER=\$PAGER" >> $PATHVAR
        printf "export SYSTEMD_PAGERSECURE=1" >> $PATHVAR
    fi
fi
    
reade -Q "YELLOW" -i "y" -p "Set nvimpager default pager for root? [Y/n]: " "y n" moar_root
if [ -z "$moar_root" ] || [ "y" == "$moar_root" ] || [ "Y" == "$moar_root" ]; then
    if sudo grep -q "nvimpager" $PATHVAR_R; then
        sudo sed -i "s|.export PAGER=|export PAGER=|g" $PATHVAR_R
        sudo sed -i "s|export PAGER=.*|export PAGER=$(whereis nvimpager | awk '{print $2;}')|g" $PATHVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=$PAGER|g" $PATHVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $PATHVAR_R
    else
        printf "export PAGER=$(whereis nvimpager | awk '{print $2;}')\n" | sudo tee -a $PATHVAR_R
        printf "export SYSTEMD_PAGER=\$PAGER\n" | sudo tee -a $PATHVAR_R
        printf "export SYSTEMD_PAGERSECURE=1\n" | sudo tee -a $PATHVAR_R
    fi
fi
