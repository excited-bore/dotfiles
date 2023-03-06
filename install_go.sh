. ./check_distro.sh

if [[ $dist == "Arch" || $dist == "Manjaro" ]]; then
    sudo pacman -Su go
elif [[ $dist == "Debian" || $dist == "Raspbian" ]]; then
#else
    if [ "$archit" == "armv7l" ]; then
       archit="armv6l"
    elif [ "$archit" == "i386" ]; then
       archit="386" 
    fi
    latest=$(curl -sL "https://github.com/golang/go/tags" |  grep "/golang/go/releases/tag" | perl -pe 's|.*/golang/go/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}')
    file="$latest.linux-$archit.tar.gz"
    
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
            exit 1
        fi
        sudo tar -C /usr/local -xzf $file
        rm $file
        )    
    fi
    
fi
