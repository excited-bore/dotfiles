#if ! type QtTinySA &> /dev/null; then
    gtb_link="https://github.com/g4ixt/QtTinySA"
    new_url="$(echo "$(echo "$gtb_link" | sed 's|https://github.com|https://api.github.com/repos|g')/releases/latest")" 
    ltstv=$(curl -sL "$new_url" | jq -r ".assets" | grep --color=never "name" | sed 's/"name"://g' | tr '"' ' ' | tr ',' ' ' | sed 's/[[:space:]]//g')
    versn=$(curl -sL "$new_url" | jq -r '.tag_name')
    link="$gtb_link/releases/download/$versn/QtTinySA.bin" 
    
    if test -z "$ltstv"; then
        printf "${red}No releases found.${normal}\n"
        exit 1 
    fi
    tmpd=$(mktemp -d)     
    wget -P $tmpd "$link"
    mv $tmpd/QtTinySA.bin $tmpd/QtTinySA  
    if ! groups $USER | grep -qw 'dialout'; then
        echo "$(tput bold && tput setaf 1)User '$USER' is not added to the group 'dialout'$(tput sgr0) which is needed to gain access to serial ports"
        reade -Q 'GREEN' -i 'y' -p 'Add them to the group? [Y/n]: ' 'n' add_togr
        if test $add_togr == 'y'; then
            if ! test $(getent group dialout); then
               groupadd dialout
            fi
            echo "This next $(tput setaf 1)sudo$(tput sgr0) will add the group 'dialout' as a secondary group for $USER";
            sudo usermod -aG dialout $USER  
            echo "Dont forget to log out and in again for changing/adding of groups to take effect"
        else
            exit 1
        fi
    fi
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install QtTinySA under $(tput bold)/usr/bin/$(tput sgr0)";
    sudo install -Dm777 $tmpd/"QtTinySA" -t "/usr/bin/" && echo "$(tput bold)QtTinySA.bin installed!$(tput sgr0)" || echo "$(tput setaf 1 && tput bold)Something went wrong!$(tput sgr0)" 
#fi 
