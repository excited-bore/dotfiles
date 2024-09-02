 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
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

if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi


answer=""
if ! type moar &> /dev/null; then
    
    if [ $distro == "Manjaro" ]; then
        
        reade -Q "GREEN" -i "y" -p "Install moar from packagemanager (y), github binary (b) or not [Y/b/n]: " "b n"  answer
        if [ "$answer" == "y" ] || [ -z "$answer" ] || [ "$answer" == "Y" ]; then
            yes | pamac install moar;
        fi
    
    elif [ $distro == "Arch" ] && ! test -z "$AUR_install"; then
        
        reade -Q "GREEN" -i "y" -p "Install moar from packagemanager (y), github binary (b) or not [Y/b/n]: " "b n"  answer
        if [ "$answer" == "y" ] || [ -z "$answer" ] || [ "$answer" == "Y" ]; then
            eval "$AUR_install moar-git";
        fi
    
    else
        
        printf "Package manager unknown or PM doesn't offer moar (f.ex. apt).\n"; 
        reade -Q "YELLOW" -i "b" -p "Install moar from github binary (b) or not (anything but empty or b) [B/n]: " "n"  answer
        if [ -z "$answer" ] || [ "B" == "$answer" ] || [ "b" == "$answer" ]; then
            if [ $arch == "armv7l" ] || [ $arch == "arm64" ]; then
                arch="arm"
            fi
            if [ $arch == "amd64" ] || [ $arch == "amd32" ]; then
                arch="386"
            fi
            latest=$(curl -sL "https://github.com/walles/moar/tags" | grep "/walles/moar/releases/tag" | perl -pe 's|.*/walles/moar/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}')                          
            tmp=$(mktemp) && curl -o $tmp "https://github.com/walles/moar/releases/download/$latest/moar-$latest-linux-$arch"
            chmod a+x $TMPDIR/moar-*-*-*
            sudo mv $TMPDIR/moar-* /usr/bin/moar
            echo "Done!"
        fi
        
    fi
fi


reade -Q "GREEN" -i "y" -p "Set moar as default pager for $USER? [Y/n]: " "n" moar_usr
if [ -z "$moar_usr" ] || [ "y" == "$moar_usr" ] || [ "Y" == "$moar_usr" ]; then
    
    if grep -q "MOAR" $ENVVAR; then 
        sed -i "s|.export MOAR=|export MOAR=|g" $ENVVAR 
        
        sed -i "s|export MOAR=.*|export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'|g" $ENVVAR 
        sed -i "s|.export PAGER=|export PAGER=|g" $ENVVAR
        sed -i "s|export PAGER=.*|export PAGER=/usr/bin/moar|g" $ENVVAR
        sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=\$PAGER|g" $ENVVAR
        sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENVVAR
    else
        printf "export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'\n" >> $ENVVAR
        printf "export PAGER=/usr/bin/moar\n" >> $ENVVAR
        printf "export SYSTEMD_PAGER=\$PAGER" >> $ENVVAR
        printf "export SYSTEMD_PAGERSECURE=1" >> $ENVVAR
    fi
fi
    
reade -Q "YELLOW" -i "y" -p "Set moar as default pager for root? [Y/n]: " "n" moar_root
if [ -z "$moar_root" ] || [ "y" == "$moar_root" ] || [ "Y" == "$moar_root" ]; then
    if sudo grep -q "MOAR" $ENVVAR_R; then
        sudo sed -i "s|.export MOAR=.*|export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'|g" $ENVVAR_R 
        sudo sed -i "s|.export PAGER=.*|export PAGER=/usr/bin/moar|g" $ENVVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=$PAGER|g" $ENVVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENVVAR_R
    else
        printf "export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'\n" | sudo tee -a $ENVVAR_R
        printf "export PAGER=/usr/bin/moar\n" | sudo tee -a $ENVVAR_R
        printf "export SYSTEMD_PAGER=\$PAGER\n" | sudo tee -a $ENVVAR_R
        printf "export SYSTEMD_PAGERSECURE=1\n" | sudo tee -a $ENVVAR_R
    fi
fi

    #./setup_git_build_from_source.sh "y" "" "https://github.com" "neovim/neovim" "stable" "sudo apt update; sudo apt install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y"


