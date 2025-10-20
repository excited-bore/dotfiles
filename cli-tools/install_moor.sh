# https://github.com/walles/moor

hash moor &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


if ! hash moor &> /dev/null; then
    
    if [[ "$distro_base" == "Arch" ]]; then 
        
        if ! test -f $TOP/checks/check_AUR.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
        else
            . $TOP/checks/check_AUR.sh
        fi
        
        eval "${AUR_ins_y} moor-git";
    else
        
        printf "Package manager unknown or PM doesn't offer moor (f.ex. apt).\n"; 
        readyn -Y "YELLOW" -p "Install moor from github binary or not?" answer
        if [[ "y" == "$answer" ]]; then
            if ! hash wget &> /dev/null || ! hash jq &> /dev/null; then
                readyn -p "Need wget and jq for this to work (tool to fetch file from the internet and tool to query JSON format). Install wget and jq?"  ins_wget
                if [[ $ins_wget == 'y' ]]; then
                    eval "${pac_ins_y} wget jq"
                fi
                unset ins_wget 
            fi
            if ! test -f $TOP/shell/aliases/.aliases.d/git.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.aliases.d/git.sh)
            else
                . $TOP/shell/aliases/.aliases.d/git.sh
            fi
            
            if [[ $arch == "armv7l" ]] || [[ $arch == "arm64" ]]; then
                archm="arm"
            elif [[ $arch == "amd64" ]] || [[ $arch == "amd32" ]]; then
                archm="386"
            fi
            latest=$(wget-curl "https://api.github.com/repos/walles/moor/releases" | jq '.[0]' -r | jq -r '.assets' | grep --color=never "name" | sed 's/"name"://g' | tr '"' ' ' | tr ',' ' ' | sed 's/[[:space:]]//g')                          
            moor=$(echo "$latest" | grep --color=never "linux-$archm")
            #tmpd=$(mktemp -d)
            #tag=$(echo $moor | sed "s/moor-\(.*\)-linux.*/\1/g") 
            #wget-aria-dir $tmpd https://github.com/walles/moor/releases/download/$tag/$moor
            get-latest-releases-github https://github.com/walles/moor $TMPDIR $moor  
            sudo chmod 0755 $TMPDIR/$moor
            sudo mv $TMPDIR/$moor /usr/bin/moor
            echo "Done!"
            unset archm latest moor
        fi
    fi
fi

if hash moor &> /dev/null; then
    
    moor --help | $PAGER
    
    readyn -p "Set moor as default pager for $USER?" moor_usr
    if [[ "y" == "$moor_usr" ]]; then
        
        if grep -q "moor" $ENV; then 
            sed -i "s|.export moor=| moor=|g" $ENV 
            
            sed -i "s|export moor=.*|export moor='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'|g" $ENV 
            sed -i "s|.export PAGER=|export PAGER=|g" $ENV
            sed -i "s|export PAGER=.*|export PAGER=/usr/bin/moor|g" $ENV
            sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=\$PAGER|g" $ENV
            sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENV
        else
            printf "export moor='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'\n" >> $ENV 1> /dev/null
            printf "export PAGER=/usr/bin/moor\n" >> $ENV 1> /dev/null
            printf "export SYSTEMD_PAGER=\$PAGER" >> $ENV 1> /dev/null
            printf "export SYSTEMD_PAGERSECURE=1" >> $ENV 1> /dev/null
        fi
    fi
        
    readyn -Y 'YELLOW' -p "Set moor as default pager for root?" moor_root
    if [[ "y" == "$moor_root" ]]; then
        if sudo grep -q "moor" $ENV_R; then
            sudo sed -i "s|.export moor=.*|export moor='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'|g" $ENV_R 
            sudo sed -i "s|.export PAGER=.*|export PAGER=/usr/bin/moor|g" $ENV_R
            sudo sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=$PAGER|g" $ENV_R
            sudo sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENV_R
        else
            printf "export moor='--statusbar=bold --colors=auto --render-unprintable=highlight --quit-if-one-screen'\n" | sudo tee -a $ENV_R 1> /dev/null
            printf "export PAGER=/usr/bin/moor\n" | sudo tee -a $ENV_R 1> /dev/null
            printf "export SYSTEMD_PAGER=\$PAGER\n" | sudo tee -a $ENV_R 1> /dev/null
            printf "export SYSTEMD_PAGERSECURE=1\n" | sudo tee -a $ENV_R 1> /dev/null
        fi
    fi
   
    PAGER='moor' 

fi
    #./setup_git_build_from_source.sh "y" "" "https://github.com" "neovim/neovim" "stable" "sudo apt update; eval "$pac_ins ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y""
