unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

#echo ${machine}

#if [ "$machine" == "Mac" ]; then
#    # code for macOS platform        
#elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
#    # code for GNU/Linux platform
#fi


distro_base=/
distro=/
packagemanager=/
arch=/
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/rpi-issue]=apt
osInfo[/etc/manjaro-release]=pamac
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]};
do
    if [ -f $f ] && [ $f == /etc/alpine-release ] && [ $distro == / ]; then
        packagemanager=${osInfo[$f]}
        distro_base="Gentoo"
        distro="Alpine"
    elif [ -f $f ] && [ $f == /etc/manjaro-release ] && [ $distro == / ]; then
        packagemanager=${osInfo[$f]}
        distro_base="Arch"
        distro="Manjaro"
    elif grep -q "Ubuntu" /etc/issue && [ $distro == / ]; then
        packagemanager=apt
        distro_base="Debian"
        distro="Ubuntu"
    elif [ -f $f ] && [ $f == /etc/SuSE-release ] && [ $distro == / ];then
        packagemanager=${osInfo[$f]}
        distro="Suse"
    elif [ -f $f ] && [ $f == /etc/gentoo-release ] && [ $distro == / ];then
        packagemanager=${osInfo[$f]}
        distro="Gentoo"
    elif [ -f $f ] && [ $f == /etc/redhat-release ] && [ $distro == / ];then
        packagemanager=${osInfo[$f]}
        distro="Redhat"
    elif [ -f $f ] && [ $f == /etc/arch-release ] && [ $distro == / ];then
        packagemanager=${osInfo[$f]}
        distro="Arch"
    elif [ -f $f ] && [ $f == /etc/rpi-issue ] && [ $distro == / ];then
        packagemanager=${osInfo[$f]}
        distro_base="Debian"
        distro="Raspbian"
    elif [ -f $f ] && [ $f == /etc/debian_version ] && [ $distro == / ];then
        packagemanager=${osInfo[$f]}
        distro="Debian"
    fi 
done

if lscpu | grep -q "Intel"; then
    arch="386"
elif lscpu | grep -q "AMD"; then
    if lscpu | grep -q "x86_64"; then 
        arch="amd64"
    else
        arch="amd32"
    fi
elif lscpu | grep -q "armv"; then
    arch="armv7l"
elif lscpu | grep -q "aarch"; then
    arch="arm64"
fi      
