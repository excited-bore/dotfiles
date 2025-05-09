DLSCRIPT=1

#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if ! test -f checks/check_all.sh; then
    if type curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "Curl not found and uninstallable. Exiting..."
        return 1
    fi
else
    . ./checks/check_all.sh
fi

if ! test -f checks/check_AUR.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
else
    . ./checks/check_AUR.sh
fi



if ! command -v moar &> /dev/null; then
    
    if [[ "$distro_base" == "Arch" ]]; then 
        
        #local answer
        readyn -p "Install moar?"  answer
        if [[ "$answer" == "y" ]]; then
            eval "${AUR_ins} moar-git";
        fi
    	unset answer
    else
        
        printf "Package manager unknown or PM doesn't offer moar (f.ex. apt).\n"; 
        readyn -Y "YELLOW" -p "Install moar from github binary or not?" answer
        if [[ "y" == "$answer" ]]; then
            if ! command -v wget &> /dev/null || ! command -v jq &> /dev/null; then
                readyn -p "Need wget and jq for this to work (tool to fetch file from the internet and tool to query JSON format). Install wget and jq?"  ins_wget
                if [[ $ins_wget == 'y' ]]; then
                    eval "${pac_ins} wget jq"
                fi
                unset ins_wget 
            fi
            if [[ $arch == "armv7l" ]] || [[ $arch == "arm64" ]]; then
                arch="arm"
            fi
            if [[ $arch == "amd64" ]] || [[ $arch == "amd32" ]]; then
                arch="386"
            fi
            latest=$(curl -sL "https://api.github.com/repos/walles/moar/releases" | jq '.[0]' -r | jq -r '.assets' | grep --color=never "name" | sed 's/"name"://g' | tr '"' ' ' | tr ',' ' ' | sed 's/[[:space:]]//g')                          
            moar=$(echo "$latest" | grep --color=never $arch)
            tmpd=$(mktemp -d)
            tag=$(echo $moar | sed "s/moar-\(.*\)-linux.*/\1/g") 
            wget-dir $tmpd https://github.com/walles/moar/releases/download/$tag/$moar
            chmod u+x $tmpd/moar*
            sudo mv $tmpd/moar* /usr/bin/moar
            echo "Done!"
        fi
    fi
fi

if hash moar &> /dev/null; then
    
    moar --help | less -R
    
    readyn -p "Set moar as default pager for $USER?" moar_usr
    if [[ "y" == "$moar_usr" ]]; then
        
        if grep -q "MOAR" $ENV; then 
            sed -i "s|.export MOAR=| MOAR=|g" $ENV 
            
            sed -i "s|export MOAR=.*|export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'|g" $ENV 
            sed -i "s|.export PAGER=|export PAGER=|g" $ENV
            sed -i "s|export PAGER=.*|export PAGER=/usr/bin/moar|g" $ENV
            sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=\$PAGER|g" $ENV
            sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENV
        else
            printf "export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'\n" >> $ENV 1> /dev/null
            printf "export PAGER=/usr/bin/moar\n" >> $ENV 1> /dev/null
            printf "export SYSTEMD_PAGER=\$PAGER" >> $ENV 1> /dev/null
            printf "export SYSTEMD_PAGERSECURE=1" >> $ENV 1> /dev/null
        fi
    fi
        
    readyn -Y 'YELLOW' -p "Set moar as default pager for root?" moar_root
    if [[ "y" == "$moar_root" ]]; then
        if sudo grep -q "MOAR" $ENV_R; then
            sudo sed -i "s|.export MOAR=.*|export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'|g" $ENV_R 
            sudo sed -i "s|.export PAGER=.*|export PAGER=/usr/bin/moar|g" $ENV_R
            sudo sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=$PAGER|g" $ENV_R
            sudo sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENV_R
        else
            printf "export MOAR='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'\n" | sudo tee -a $ENV_R 1> /dev/null
            printf "export PAGER=/usr/bin/moar\n" | sudo tee -a $ENV_R 1> /dev/null
            printf "export SYSTEMD_PAGER=\$PAGER\n" | sudo tee -a $ENV_R 1> /dev/null
            printf "export SYSTEMD_PAGERSECURE=1\n" | sudo tee -a $ENV_R 1> /dev/null
        fi
    fi
fi
    #./setup_git_build_from_source.sh "y" "" "https://github.com" "neovim/neovim" "stable" "sudo apt update; eval "$pac_ins ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y""
