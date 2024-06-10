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

if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checksum/check_pathvar.sh
fi


if test $distro == "Arch" || test $distro == "Manjaro"; then
    sudo pacman -S go
elif [ $distro_base == "Debian" ]; then
    if [[ "$arch" =~ "arm"* ]]; then
       arch="armv6l"
        #elif [ "$arch" == "i386" ]; then
        #   arch="386" 
        rm -rf /usr/local/go 
        latest=$(curl -sL "https://github.com/golang/go/tags" |  grep "/golang/go/releases/tag" | perl -pe 's|.*/golang/go/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}')
        file="$latest.linux-$arch.tar.gz"
        
        checksum=$(curl -sL "https://golang.google.cn/dl/" | awk 'BEGIN{FS="\n"; RS=""} $0 ~ /'$file'/ &&  $0 ~ /<\/tt>/ {print $0;}' | grep "<tt>" | sed "s,.*<tt>\(.*\)</tt>.*,\1,g")
        if [ ! -x "$(command -v go version)" ] || [[ ! "$(go version)" =~ $latest ]]; then
            wget -P $TMPDIR https://golang.google.cn/dl/$file
            file=$TMPDIR/$file
            sum=$(sha256sum $file | awk '{print $1;}')
            echo "Checksum golang website: $checksum"
            echo "Checksum file: $sum"
            if [ ! "$sum" == "$checksum" ]; then
                echo "Checksums are different; Aborting"
                exit
            fi
            sudo tar -C /usr/local -xzf $file
            rm $file
            #if grep -q "GOROOT" $PATHVAR; then
            #    sed -i "s|.export GOROOT=|export GOROOT=|g" $PATHVAR
            #    sed -i "s|export GOROOT=.*|export GOROOT=$goroot|g" $PATHVAR
            #    sed -i "s|.export PATH=\$PATH:\$GOROOT|export PATH=\$PATH:\$GOROOT|g" $PATHVAR
            #    
            #else
            #    echo "export GOROOT=$goroot" >> $PATHVAR
            #    echo "export PATH=\$PATH:\$GOROOT" >> $PATHVAR
            #fi
        fi
    else
        yes | sudo apt install go
    fi
    
fi    

if echo $(go env) | grep -q "GOPATH=$HOME/go"; then
    reade -Q "GREEN" -i "y" -p "Source installed go outside of $HOME/go? (Set GOPATH):" "y n" gopth
    if [ "y" == "$gopth" ]; then
        reade -Q "CYAN" -i "$HOME/.local" -p "GOPATH: " -e gopth
        #echo "${CYAN}Only GOPATH is necessary. Setting GOROOT is usually for development reasons${normal}"
        #reade -Q "CYAN" -p "Set custom GOROOT? (Go tools, empty means leave default): " -e goroot
        
        go env -w GO111MODULE=auto
        go env -w GOPATH=$gopth
         #if grep -q "GOPATH" $PATHVAR; then
         #   sed -i "s|.export GOPATH=|export GOPATH=|g" $PATHVAR
         #   sed -i "s|export GOPATH=.*|export GOPATH=$gopth|g" $PATHVAR
         #   sed -i "s|.export PATH=\$PATH:\$GOPATH|export PATH=\$PATH:\$GOPATH|g" $PATHVAR
         #else
         #   echo "export GOPATH=$gopth" >> $PATHVAR
         #   echo "export PATH=\$PATH:\$GOPATH" >> $PATHVAR
         #fi
    fi
fi
