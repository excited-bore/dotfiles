if ! test -f checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        continue
    fi
else
    . ./checks/check_all.sh
fi

if ! hash go &> /dev/null; then 
    if [[ $distro_base == "Arch" ]]; then
        eval "${pac_ins} go"
    elif [[ $distro_base == "Debian" ]]; then
        if [[ "$arch" =~ "arm"* ]]; then
           arch="armv6l"
        elif [[ "$arch" == "i386" ]]; then
           arch="386"
        elif [[ "$arch" == "amd64" ]]; then
           arch="amd64"
        fi
        sudo rm -rf /usr/local/go 
        latest=$(curl -sL "https://github.com/golang/go/tags" | grep --color=never "/golang/go/releases/tag" | perl -pe 's|.*/golang/go/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}')
        file="$latest.linux-$arch.tar.gz"
        checksum=$(curl -sL "https://golang.google.cn/dl/" | awk 'BEGIN{FS="\n"; RS=""} $0 ~ /'$file'/ &&  $0 ~ /<\/tt>/ {print $0;}' | grep --color=never "<tt>" | sed "s,.*<tt>\(.*\)</tt>.*,\1,g")
        if ! hash go &> /dev/null || ! [[ "$(go version)" =~ $latest ]]; then
            test -z $TMPDIR && TMPDIR=$(mktemp -d) 
            wget-aria-dir $TMPDIR https://golang.google.cn/dl/$file
            file=$TMPDIR/$file
            sum=$(sha256sum $file | awk '{print $1;}')
            echo "Checksum golang website: $checksum"
            echo "Checksum file: $sum"
            if ! [[ "$sum" == "$checksum" ]]; then
                echo "Checksums are different; Aborting"
            else 
                if ! hash tar &> /dev/null; then
                    eval "$pac_ins tar" 
                fi
                sudo tar -C /usr/local -xzf $file
                rm -rf $file
            fi
            
            if ! [[ $PATH =~ /usr/local/go/bin ]]; then
                if grep -q 'GOPATH' $ENV; then
                    sed -i 's|.export PATH=$PATH:/usr/local/go/bin|export PATH=$PATH:/usr/local/go/bin|g' $ENV
                    sed -i 's|.export PATH=$PATH:$(go env GOPATH)/bin|export PATH=$PATH:$(go env GOPATH)/bin|g' $ENV
                else
                    printf "# GO\nexport PATH=\$PATH:/usr/local/go/bin\n" >> $ENV 
                    printf "export PATH=\$PATH:\$(go env GOPATH)/bin\n" >> $ENV        
                fi 
                
                source $ENV
            fi
        fi
    fi
fi

go help | $PAGER

if ! [[ $PATH =~ "\$(go env GOPATH)/bin" ]]; then
    if grep -q 'GOPATH' $ENV; then
        sed -i 's|.export PATH=$PATH:$(go env GOPATH)/bin|export PATH=$PATH:$(go env GOPATH)/bin|g' $ENV
    else
        if grep -q '# GO' $ENV; then
            printf "export PATH=\$PATH:\$(go env GOPATH)/bin\n" >> $ENV        
        else 
            printf "# GO\nexport PATH=\$PATH:\$(go env GOPATH)/bin\n" >> $ENV 
        fi
    fi 
    
    source $ENV

fi


hash go && gopath=$(go env | grep --color=never GOPATH | cut -d= -f2 | sed "s/'//g")

echo "This next $(tput setaf 1)sudo$(tput sgr0) will check if something along the lines of '$gopath/bin' is being kept in /etc/sudoers";

if test -f /etc/sudoers && hash go && ! sudo grep -q "$gopath/bin" /etc/sudoers; then
    readyn -p "Add ${RED}$gopath/bin${GREEN} to /etc/sudoers? (let go applications installed with 'go install' can be executed using sudo)?" ansr
    if [[ "$ansr" == 'y' ]]; then
        sudo sed -i 's,Defaults secure_path="\(.*\)",Defaults secure_path="\1:'"$gopath"'/bin/",g' /etc/sudoers
        echo "Added ${GREEN}'$gopath/bin'${normal} to ${RED}secure_path${normal} in /etc/sudoers!"
    fi
fi

#if command -v go &> /dev/null && echo $(go env) | grep -q "GOPATH=$HOME/go"; then
#    readyn -p "Source installed go outside of $HOME/go? (Set GOPATH):" gopth
#    if [[ "y" == "$gopth" ]]; then
#        reade -Q "CYAN" -i "$HOME/.local" -p "GOPATH: " -e gopth
#        #echo "${CYAN}Only GOPATH is necessary. Setting GOROOT is usually for development reasons${normal}"
#        #reade -Q "CYAN" -p "Set custom GOROOT? (Go tools, empty means leave default): " -e goroot
#
#        go env -w GO111MODULE=auto
#        go env -w GOPATH=$gopth
#         #if grep -q "GOPATH" $ENV; then
#         #   sed -i "s|.export GOPATH=|export GOPATH=|g" $ENV
#         #   sed -i "s|export GOPATH=.*|export GOPATH=$gopth|g" $ENV
#         #   sed -i "s|.export PATH=\$PATH:\$GOPATH|export PATH=\$PATH:\$GOPATH|g" $ENV
#         #else
#         #   echo "export GOPATH=$gopth" >> $ENV
#         #   echo "export PATH=\$PATH:\$GOPATH" >> $ENV
#         #fi
#    fi
#fi
