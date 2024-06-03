unameOut="$(uname-s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Windows;;
    MINGW*)     machine=Windows;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if test -z $TMPDIR; then
    TMPDIR=$(mktemp -d)
fi

if test -z $EDITOR; then
    if type nano &> /dev/null; then
        EDITOR=nano
    elif type vi &> /dev/null; then
        EDITOR=vi
    else
        EDITOR=edit
    fi
fi


distro_base=/
distro=/
packagemanager=/
arch=/
declare -A osInfo;
osInfo[/etc/alpine-release]=apk
osInfo[/etc/arch-release]=pacman
osInfo[/etc/debian_version]=apt
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/manjaro-release]=pamac
osInfo[/etc/redhat-release]=yum
osInfo[/etc/rpi-issue]=apt
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/SUSE-brand]=zypp

for f in ${!osInfo[@]};
do
    if [ -f $f ] && [ $f == /etc/alpine-release ] && [ $distro == / ]; then
        packmang="apk"
        distro_base="Slackware"
        distro="Alpine"
    elif [ -f $f ] && [ $f == /etc/manjaro-release ] && [ $distro == / ]; then
        packmang="pacman"
        AUR_helper="pamac"
        AUR_update="pamac update"
        AUR_install="pamac install"
        if ! test -f checks/check_pamac.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)" 
        else
            . ./checks/check_pamac.sh
        fi 
        distro_base="Slackware"
        distro="Manjaro"
        # Check for AUR
          
    elif grep -q "Ubuntu" /etc/issue && [ $distro == / ]; then
        packmang="apt"
        distro_base="Debian"
        distro="Ubuntu"
    elif test -f $f && [[ $f == /etc/SuSE-release || $f == /etc/SUSE-brand ]] && test $distro == /;then
        if ! test -z "$(lsb_release -a | grep Leap)"; then
            packmang="zypper_leap"
        else
            packmang="zypper_tumble"
        fi
        distro_base="Slackware"
        distro="Suse"
    elif [ -f $f ] && [ $f == /etc/gentoo-release ] && [ $distro == / ];then
        packmang="emerge"
        distro_base="Slackware"
        distro="Gentoo"
    elif [ -f $f ] && [ $f == /etc/redhat-release ] && [ $distro == / ];then
        packmang="yum"
        distro_base="Slackware"
        distro="Redhat"
    elif [ -f $f ] && [ $f == /etc/arch-release ] && [ $distro == / ];then
        packmang="pacman"
        # Check every package manager known by archwiki 
        
        #
        # PACMAN WRAPPERS
        # 
        
        if test -x "$(command -v pamac)"; then
            AUR_helper="pamac"
            AUR_update="pamac update"
            AUR_install="pamac install"    
            if ! test -f checks/check_pamac.sh; then
                 eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)" 
            else
                . ./checks/check_pamac.sh
            fi
        elif test -x "$(command -v pikaur)"; then
            AUR_helper="pikaur"
            AUR_update="pikaur -Syu"
            AUR_install="pikaur -S"
        elif test -x "$(command -v yay)"; then
            AUR_helper="yay"
            AUR_update="yay -Syu"
            AUR_install="yay -S"
        elif test -x "$(command -v aura)"; then
            AUR_helper="aura"
            AUR_update="aura -Au"
            AUR_install="aura -A"
        elif test -x "$(command -v aurman)"; then
            AUR_helper="aurman"
            AUR_update="aurman -Syu"
            AUR_install="aurman -S"
        elif test -x "$(command -v pacaur)"; then
            AUR_helper="pacaur"
            AUR_update="pacaur -Syu"
            AUR_install="pacaur -S"
        elif test -x "$(command -v pakku)" ; then
            AUR_helper="pakku"
            AUR_update="pakku -Syu"
            AUR_install="pakku -S"
        elif test -x "$(command -v paru)"; then
            AUR_helper="paru"
            AUR_update="paru -Syua"
            AUR_install="paru -S"
        elif test -x "$(command -v trizen)"; then
            AUR_helper="trizen"
            AUR_update="trizen -Syu"
            AUR_install="trizen -S"
        
        #
        # SEARCH AND BUILD
        # 
        
        elif test -x "$(command -v aur)"; then
            AUR_helper="aur"
            AUR_update=""
            AUR_install=
        elif test -x "$(command -v repoctl)"; then
            packmang_AUR="repoctl"
        elif test -x "$(command -v yaah)"; then
            packmang_AUR="yaah"
        elif test -x "$(command -v bauerbill)"; then
            packmang_AUR="bauerbill"
        elif test -x "$(command -v PKGBUILDer)"; then
            packmang_AUR="PKGBUILDer"
        elif test -x "$(command -v rua)"; then
            packmang_AUR="rua"
        elif test -x "$(command -v pbget)"; then
            packmang_AUR="pbget"
        elif test -x "$(command -v argon)" ; then
            packmang_AUR="argon"
        elif test -x "$(command -v cylon)"; then
            packmang_AUR="cylon"
        elif test -x "$(command -v kalu)"; then
            packmang_AUR="kalu"
        elif test -x "$(command -v octopi)"; then
            packmang_AUR="octopi"
        elif test -x "$(command -v pacseek)"; then
            packmang_AUR="pacseek"
        elif test -x "$(command -v PkgBrowser)"; then
            packmang_AUR="PkgBrowser"
        elif test -x "$(command -v yup)" ; then
            packmang_AUR="yup"
        elif test -x "$(command -v auracle)"; then
            AUR_helper="auracle"
        #
        # PACMAN WRAPPERS
        # 
            AUR_update="auracle update"
            AUR_install="none"
        else
            printf "Your Arch system seems to have no (known) AUR helper installed\n"
            reade -Q "GREEN" -i "y" -p "Install yay ( Pacman wrapper )? [Y/n]: " "y n" insyay
            if [ "y" == "$insyay" ]; then 
               if ! test -f ../install_yay.sh; then
                    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_yay.sh)" 
                else
                    eval ../install_yay.sh
                fi
                AUR_helper="yay"
                AUR_update="yay -Syu"
                AUR_install="yay -S"
            fi
            unset insyay 
        fi
        distro_base="Slackware"
        distro="Arch"
    elif [ -f $f ] && [ $f == /etc/rpi-issue ] && [ $distro == / ];then
        packmang="apt"
        distro_base="Debian"
        distro="Raspbian"
    elif [ -f $f ] && [ $f == /etc/debian_version ] && [ $distro == / ];then
        packmang="apt"
        distro_base="Debian"   
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
