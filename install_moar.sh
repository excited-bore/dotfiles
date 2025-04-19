#!/bin/bash

#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if ! test -f checks/check_all.sh; then
    if type curl &> /dev/null; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"
    else
        printf "Curl not found and uninstallable. Exiting..."
        return 1
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f checks/check_AUR.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)"
else
    . ./checks/check_AUR.sh
fi


answer=""

if ! type moar &> /dev/null; then
    
    if [[ "$distro_base" == "Arch" ]]; then 
        printf "Moar is a part of the AUR, need an AUR installer / pacman wrapper for that.${CYAN}yay${normal} is recommended for this\n"
        readyn -p "Install yay?" insyay
        if [[ "y" == "$insyay" ]]; then
            if type curl &>/dev/null && ! test -f $SCRIPT_DIR/AUR_installers/install_yay.sh; then
                source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_yay.sh)
            else
                . $SCRIPT_DIR/AUR_installers/install_yay.sh
            fi
            AUR_pac="yay"
            AUR_up="yay -Syu"
            AUR_ins="yay -S"
            AUR_search="yay -Ss"
            AUR_ls_ins="yay -Q"
        fi
         
        reade -Q 'GREEN' -i 'y b n' -p "Install moar from packagemanager (y), github binary (b) or not [Y/b/n]: "  answer
        if [[ "$answer" == "y" ]]; then
            eval "${AUR_ins} moar-git";
        fi
    
    else
        
        printf "Package manager unknown or PM doesn't offer moar (f.ex. apt).\n"; 
        readyn -Y "YELLOW" -p "Install moar from github binary or not?" answer
        if [[ "y" == "$answer" ]]; then
            if ! type wget &> /dev/null; then
                readyn -p "Need wget for this to work (tool to fetch file from the internet). Install wget?"  ins_wget
                if [[ $ins_wget == 'y' ]]; then
                    eval "${pac_ins} wget"
                fi
                unset ins_wget 
            fi
            if [[ $arch == "armv7l" ]] || [[ $arch == "arm64" ]]; then
                arch="arm"
            fi
            if [[ $arch == "amd64" ]] || [[ $arch == "amd32" ]]; then
                arch="386"
            fi
            latest=$(curl -sL "https://github.com/walles/moar/tags" | grep "/walles/moar/releases/tag" | perl -pe 's|.*/walles/moar/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}')                          
            tmpd=$(mktemp -d) 
            wget -P $tmpd https://github.com/walles/moar/releases/download/$latest/moar-$latest-linux-$arch
            chmod a+x $tmpd/moar-*
            sudo mv $tmpd/moar-* /usr/bin/moar
            echo "Done!"
        fi
    fi
fi


readyn -p "Set moar as default pager for $USER?" moar_usr
if [[ "y" == "$moar_usr" ]]; then
    
    if grep -q "MOAR" $ENVVAR; then 
        sed -i "s|.export MOAR=| MOAR=|g" $ENVVAR 
        
        sed -i "s|export MOAR=.*|export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'|g" $ENVVAR 
        sed -i "s|.export PAGER=|export PAGER=|g" $ENVVAR
        sed -i "s|export PAGER=.*|export PAGER=/usr/bin/moar|g" $ENVVAR
        sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=\$PAGER|g" $ENVVAR
        sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENVVAR
    else
        printf "export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'\n" >> $ENVVAR 1> /dev/null
        printf "export PAGER=/usr/bin/moar\n" >> $ENVVAR 1> /dev/null
        printf "export SYSTEMD_PAGER=\$PAGER" >> $ENVVAR 1> /dev/null
        printf "export SYSTEMD_PAGERSECURE=1" >> $ENVVAR 1> /dev/null
    fi
fi
    
readyn -p "Set moar as default pager for root?" moar_root
if [[ "y" == "$moar_root" ]]; then
    if sudo grep -q "MOAR" $ENVVAR_R; then
        sudo sed -i "s|.export MOAR=.*|export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'|g" $ENVVAR_R 
        sudo sed -i "s|.export PAGER=.*|export PAGER=/usr/bin/moar|g" $ENVVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=$PAGER|g" $ENVVAR_R
        sudo sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENVVAR_R
    else
        printf "export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'\n" | sudo tee -a $ENVVAR_R 1> /dev/null
        printf "export PAGER=/usr/bin/moar\n" | sudo tee -a $ENVVAR_R 1> /dev/null
        printf "export SYSTEMD_PAGER=\$PAGER\n" | sudo tee -a $ENVVAR_R 1> /dev/null
        printf "export SYSTEMD_PAGERSECURE=1\n" | sudo tee -a $ENVVAR_R 1> /dev/null
    fi
fi

    #./setup_git_build_from_source.sh "y" "" "https://github.com" "neovim/neovim" "stable" "sudo apt update; eval "$pac_ins ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y""
