. ./checks/check_distro.sh
. ./readline/rlwrap_scripts.sh
. ./checks/check_pathvar.sh

reade -Q "GREEN" -i "y" -p "Source installed go binaries? (Set GOPATH/GOROOT):" "y n" gopth
if [ "y" == "$gopth" ]; then
    reade -Q "CYAN" -i "$HOME/.local" -p "Set GOPATH (go packages): " -e gopth
    echo "${CYAN}Only GOPATH is necessary. Setting GOROOT is usually for development reasons${normal}"
    reade -Q "CYAN" -p "Set custom GOROOT? (Go tools, empty means leave default): " -e goroot
    
    if grep -q "GOPATH" $PATHVAR; then
        if [ -z "$goroot" ]; then
            sed -i "s|.export GOPATH=|export GOPATH=|g" $PATHVAR
            sed -i "s|export GOPATH=.*|export GOPATH=$gopth|g" $PATHVAR
            sed -i "s|.export PATH=\$PATH:\$GOPATH|export PATH=\$PATH:\$GOPATH|g" $PATHVAR
        else
            sed -i "s|.export GOPATH=|export GOPATH=|g" $PATHVAR
            sed -i "s|export GOPATH=.*|export GOPATH=$gopth|g" $PATHVAR
            sed -i "s|.export GOROOT=|export GOROOT=|g" $PATHVAR
            sed -i "s|export GOROOT=.*|export GOROOT=$goroot|g" $PATHVAR
            sed -i "s|.export PATH=\$PATH:\$GOPATH|export PATH=\$PATH:\$GOPATH:\$GOROOT|g" $PATHVAR
        fi
    else
         if [ -z "$goroot" ]; then   
            echo "export GOPATH=$gopth" >> $PATHVAR
            echo "export PATH=\$PATH:\$GOPATH" >> $PATHVAR
        else
            echo "export GOPATH=$gopth" >> $PATHVAR
            echo "export GOROOT=$goroot" >> $PATHVAR
            echo "export PATH=\$PATH:\$GOPATH:\$GOROOT" >> $PATHVAR
        fi
    fi
fi 
unset gopth goroot


if [  $distro_base == "Arch" ]; then
    yes | sudo pacman -Su go
elif [ $distro_base == "Debian" ]; then
    if [ "$arch" == "armv7l" ]; then
       arch="armv6l"
        #elif [ "$arch" == "i386" ]; then
        #   arch="386" 
        latest=$(curl -sL "https://github.com/golang/go/tags" |  grep "/golang/go/releases/tag" | perl -pe 's|.*/golang/go/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}')
        file="$latest.linux-$arch.tar.gz"
        
        checksum=$(curl -sL "https://golang.google.cn/dl/" | awk 'BEGIN{FS="\n"; RS=""} $0 ~ /'$file'/ &&  $0 ~ /<\/tt>/ {print $0;}' | grep "<tt>" | sed "s,.*<tt>\(.*\)</tt>.*,\1,g")
        if [ ! -x "$(command -v go version)" ] || [[ ! "$(go version)" =~ $latest ]]; then
            (
            cd /tmp
            wget https://golang.google.cn/dl/$file
            sum=$(sha256sum $file | awk '{print $1;}')
            echo "Checksum golang website: $checksum"
            echo "Checksum file: $sum"
            if [ ! "$sum" == "$checksum" ]; then
                echo "Checksums are different; Aborting"
                exit
            fi
            sudo tar -C /usr/local -xzf $file
            rm $file
            )    
        fi
    else
        yes | sudo apt update
        yes | sudo apt install go
    fi
    
fi    

source ~/.bashrc
