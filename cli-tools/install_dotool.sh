# https://sr.ht/~geb/dotool/
# Based on https://gist.github.com/GodSpoon/7323c34660796715f93277e39a6b4199

if hash dotool &> /dev/null ; then 
    SYSTEM_UPDATED=TRUE
fi

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! hash dotool &> /devv/null; then
    if [[ "$distro_base" == 'Debian' ]]; then
        if ! test -f pkgmngrs/install_go.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/pkgmngrs/install_go.sh) 
        else
            . pkgmngrs/install_go.sh
        fi
        eval "${pac_ins_y} libxkbcommon-dev git scdoc"  
        tempd=$(mktemp -d) 
        git clone https://git.sr.ht/~geb/dotool $tempd
        (cd $tempd
        ./build.sh 
        sudo ./build.sh install
        cd ..
        command rm -rf dotool)
        
        # Configure udev rules for proper permissions
        echo 'KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/60-dotool.rules 
        
        # Reload udev rules
        sudo udevadm control --reload-rules
        sudo udevadm trigger
       
        if ! [[ $(groups) =~ 'input' ]]; then 
            # Add current user to input group
            sudo usermod -aG input $USER
            echo "${green}Group ${GREEN}input${green} added to $USER groups${normal}" 
            echo "${GREEN}Logging out and back in (or rebooting your system)${green} is required for the change to take effect${normal}"
        fi
       
        # Restart udev service
        sudo systemctl restart udev 
    fi
fi

dotool --help
