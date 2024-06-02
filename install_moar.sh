 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if ! test -f aliases/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi


answer=""
if ! type moar &> /dev/null; then
    
    if [ $distro == "Manjaro" ]; then
        
        reade -Q "GREEN" -i "y" -p "Install moar from packagemanager (y), github binary (b) or not [Y/b/n]: " "y b n"  answer
        if [ "$answer" == "y" ] || [ -z "$answer" ] || [ "$answer" == "Y" ]; then
            yes | pamac install moar;
        fi
    
    elif [ $distro == "Arch" ] && type yay &> /dev/null; then
        
        reade -Q "GREEN" -i "y" -p "Install moar from packagemanager (y), github binary (b) or not [Y/b/n]: " "y b n"  answer
        if [ "$answer" == "y" ] || [ -z "$answer" ] || [ "$answer" == "Y" ]; then
            yes | yay -Su moar-git;
        fi
    
    else
        
        printf "Package manager unknown or PM doesn't offer moar (f.ex. apt).\n"; 
        reade -Q "YELLOW" -i "b" -p "Install moar from github binary (b) or not (anything but empty or b) [B/n]: " "b n"  answer
        if [ -z "$answer" ] || [ "B" == "$answer" ] || [ "b" == "$answer" ]; then
            if [ $arch == "armv7l" ] || [ $arch == "arm64" ]; then
                arch="arm"
            fi
            if [ $arch == "amd64" ] || [ $arch == "amd32" ]; then
                arch="386"
            fi
            latest=$(curl -sL "https://github.com/walles/moar/tags" | grep "/walles/moar/releases/tag" | perl -pe 's|.*/walles/moar/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}')                          
            wget -P $TMPDIR "https://github.com/walles/moar/releases/download/$latest/moar-$latest-linux-$arch"
            chmod a+x $TMPDIR/moar-*-*-*
            sudo mv $TMPDIR/moar-* /usr/bin/moar
            echo "Done!"
        fi
        
    fi
fi


reade -Q "GREEN" -i "y" -p "Set moar as default pager for $USER? [Y/n]: " "y n" moar_usr
if [ -z "$moar_usr" ] || [ "y" == "$moar_usr" ] || [ "Y" == "$moar_usr" ]; then
    
    if grep -q "MOAR" $PATHVAR; then 
        sed -i "s|.export MOAR=|export MOAR=|g" $PATHVAR 
        
        sed -i "s|export MOAR=.*|export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'|g" $PATHVAR 
        sed -i "s|.export PAGER=|export PAGER=|g" $PATHVAR
        sed -i "s|export PAGER=.*|export PAGER=/usr/bin/moar|g" $PATHVAR
        sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=\$PAGER|g" $PATHVAR
        sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $PATHVAR
    else
        printf "export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'\n" >> $PATHVAR
        printf "export PAGER=/usr/bin/moar\n" >> $PATHVAR
        printf "export SYSTEMD_PAGER=\$PAGER" >> $PATHVAR
        printf "export SYSTEMD_PAGERSECURE=1" >> $PATHVAR
    fi
fi
    
reade -Q "YELLOW" -i "y" -p "Set moar as default pager for root? [Y/n]: " "y n" moar_root
if [ -z "$moar_root" ] || [ "y" == "$moar_root" ] || [ "Y" == "$moar_root" ]; then
    if sudo grep -q "MOAR" $PATHVAR_R; then
        sudo sed -i "s|.export MOAR=.*|export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'|g" $PATHVAR_R 
        sudo sed -i "s|.export PAGER=.*|export PAGER=/usr/bin/moar|g" $PATHVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=$PAGER|g" $PATHVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $PATHVAR_R
    else
        printf "export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'\n" | sudo tee -a $PATHVAR_R
        printf "export PAGER=/usr/bin/moar\n" | sudo tee -a $PATHVAR_R
        printf "export SYSTEMD_PAGER=\$PAGER\n" | sudo tee -a $PATHVAR_R
        printf "export SYSTEMD_PAGERSECURE=1\n" | sudo tee -a $PATHVAR_R
    fi
fi

    #./setup_git_build_from_source.sh "y" "" "https://github.com" "neovim/neovim" "stable" "sudo apt update; sudo apt install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y"


