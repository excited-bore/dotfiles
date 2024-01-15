. ./checks/check_distro.sh

if [  $distro_base == "Arch" ]; then
    yes | sudo pacman -Su go
elif [ $distro_base == "Debian" ]; then
    if [ "$arch" == "armv7l" ]; then
       arch="armv6l"
    elif [ "$arch" == "i386" ]; then
       arch="386" 
    fi
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
    
fi
