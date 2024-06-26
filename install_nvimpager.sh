if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
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

if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if ! type nvim > /dev/null ; then
   if ! test -f ./install_nvim.sh; then
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/install_fzf.sh)" 
    else
        ./install_nvim.sh
    fi 
fi

if ! type scdoc &> /dev/null; then
    if test $distro_base == "Debian"; then
       sudo apt install scdoc
    elif test $distro == "Arch" || test $distro == "Manjaro"; then
       sudo pacman -S scdoc
    fi
fi

if ! type nvimpager &> /dev/null; then
    (cd $TMPDIR
    git clone https://github.com/lucc/nvimpager
    cd nvimpager
    make PREFIX=$HOME/.local install
    cd ..
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
    if grep -q "PAGER" $PATHVAR; then 
        sed -i "s|.export PAGER=|export PAGER=|g" $PATHVAR
        sed -i "s|export PAGER=.*|export PAGER=$(whereis nvimpager | awk '{print $2;}')|g" $PATHVAR
    else
        printf "export PAGER=$(whereis nvimpager | awk '{print $2;}')\n" >> $PATHVAR
    fi
fi
    
reade -Q "YELLOW" -i "y" -p "Set nvimpager default pager for root? [Y/n]: " "y n" moar_root
if [ -z "$moar_root" ] || [ "y" == "$moar_root" ] || [ "Y" == "$moar_root" ]; then
    if sudo grep -q "PAGER" $PATHVAR_R; then
        sudo sed -i "s|.export PAGER=|export PAGER=|g" $PATHVAR_R
        sudo sed -i "s|export PAGER=.*|export PAGER=$(whereis nvimpager | awk '{print $2;}')|g" $PATHVAR_R
    else
        printf "export PAGER=$(whereis nvimpager | awk '{print $2;}')\n" | sudo tee -a $PATHVAR_R
    fi
fi
