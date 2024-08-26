#!/usr/bin/env bash
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Windows
                win_bash_shell=Cygwin;;
    MINGW*)     machine=Windows
                win_bash_shell=Git;;
    *)          machine="UNKNOWN:${unameOut}";;
esac

if test -z $TMPDIR; then
    TMPDIR=$(mktemp -d)
fi

if test $machine == 'Windows'; then 
   wmic=$(wmic os get OSArchitecture | awk 'NR>1 {print}')
   if [[ $wmic =~ '64' ]]; then
       ARCH_WIN='64'
   else
       ARCH_WIN='32'
   fi
   if ! type sudo &> /dev/null; then
       reade -Q 'GREEN' -i 'y' -p 'Install (g)sudo? [Y/n]: ' 'n' gsdn
       if test $gsdn == 'y'; then
            ./../install_gsudo.sh
       fi
   fi
   if ! type jq &> /dev/null; then
       reade -Q 'GREEN' -i 'y' -p 'Install jq? (Json parser - used in scripts to get latest releases from github) [Y/n]: ' 'n' jqin 
       if test $jqin == 'y'; then
            winget install jqlang.jq
       fi
   fi
   unset wmic gsdn jqin
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
osInfo[/etc/fedora-release]=dnf
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
        distro_base="BSD"
        distro="Alpine"
    elif [ -f $f ] && [ $f == /etc/manjaro-release ] && [ $distro == / ]; then
        packmang="pacman"
        packmang_update="sudo pacman -Su"
        packmang_install="sudo pacman -S"
        AUR_helper="pamac"
        AUR_update="pamac update"
        AUR_install="pamac install"
#        if ! test -f checks/check_pamac.sh; then
#             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)" 
#        else
#            . ./checks/check_pamac.sh
#        fi 
        distro_base="Arch"
        distro="Manjaro"
        # Check for AUR
          
    elif test -f /etc/issue && grep -q "Ubuntu" /etc/issue && [ $distro == / ]; then
        packmang="apt"
        packmang_update="sudo apt update"
        packmang_install="sudo apt install"
        distro_base="Debian"
        distro="Ubuntu"
    elif test -f $f && [[ $f == /etc/SuSE-release || $f == /etc/SUSE-brand ]] && test $distro == /; then
        if ! test -z "$(lsb_release -a | grep Leap)"; then
            packmang="zypper_leap"
        else
            packmang="zypper_tumble"
        fi
        distro_base="Slackware"
        distro="Suse"
    elif [ -f $f ] && [ $f == /etc/gentoo-release ] && [ $distro == / ]; then
        packmang="emerge"
        distro_base="Slackware"
        distro="Gentoo"
    elif [ -f $f ] && [ $f == /etc/fedora-release ] && [ $distro == / ]; then
        packmang="dnf"
        distro_base="RedHat"
        distro="Fedora"
    elif [ -f $f ] && [ $f == /etc/redhat-release ] && [ $distro == / ]; then
        packmang="yum"
        distro_base="RedHat"
        distro="Redhat"
    elif [ -f $f ] && [ $f == /etc/arch-release ] && [ $distro == / ]; then
        packmang="pacman"
        # Check every package manager known by archwiki 
        
        #
        # PACMAN WRAPPERS
        # 
        
        if type pamac &> /dev/null; then
            AUR_helper="pamac"
            AUR_update="pamac update"
            AUR_install="pamac install"    
            if ! test -f checks/check_pamac.sh; then
                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)" 
            else
                . ./checks/check_pamac.sh
            fi
        elif type pikaur &> /dev/null; then
            AUR_helper="pikaur"
            AUR_update="pikaur -Syu"
            AUR_install="pikaur -S"
        elif type yay &> /dev/null; then
            AUR_helper="yay"
            AUR_update="yay -Syu"
            AUR_install="yay -S"
        elif type pacaur &> /dev/null; then
            AUR_helper="pacaur"
            AUR_update="pacaur -Syu"
            AUR_install="pacaur -S"
        elif type aura &> /dev/null; then
            AUR_helper="aura"
            AUR_update="aura -Au"
            AUR_install="aura -A"
        elif type aurman &> /dev/null; then
            AUR_helper="aurman"
            AUR_update="aurman -Syu"
            AUR_install="aurman -S"
        elif type pakku &> /dev/null ; then
            AUR_helper="pakku"
            AUR_update="pakku -Syu"
            AUR_install="pakku -S"
        elif type paru &> /dev/null; then
            AUR_helper="paru"
            AUR_update="paru -Syua"
            AUR_install="paru -S"
        elif type trizen &> /dev/null; then
            AUR_helper="trizen"
            AUR_update="trizen -Syu"
            AUR_install="trizen -S"
        
        #
        # SEARCH AND BUILD
        # 
        
        # Aurutils
        elif type aur &> /dev/null; then
            AUR_helper="aur"
            AUR_update=""
            AUR_install=""
        #elif type repoctl &> /dev/null; then
        #    packmang_AUR="repoctl"
        #elif type yaah &> /dev/null; then
        #    packmang_AUR="yaah"
        #elif type bauerbill &> /dev/null; then
        #    packmang_AUR="bauerbill"
        #elif type PKGBUILDer &> /dev/null; then
        #    packmang_AUR="PKGBUILDer"
        #elif type rua &> /dev/null; then
        #    packmang_AUR="rua"
        #elif type pbget &> /dev/null; then
        #    packmang_AUR="pbget"
        #elif type argon &> /dev/null ; then
        #    packmang_AUR="argon"
        #elif type cylon &> /dev/null; then
        #    packmang_AUR="cylon"
        #elif type kalu &> /dev/null; then
        #    packmang_AUR="kalu"
        #elif type octopi &> /dev/null; then
        #    packmang_AUR="octopi"
        #elif type pacseek &> /dev/null; then
        #    packmang_AUR="pacseek"
        #elif type PkgBrowser &> /dev/null; then
        #    packmang_AUR="PkgBrowser"
        #elif type yup &> /dev/null ; then
        #    packmang_AUR="yup"
        elif type auracle &> /dev/null; then
            AUR_helper="auracle"
            AUR_update="auracle update"
            AUR_install="none"
        else
            printf "Your Arch system seems to have no (known) AUR helper installed\n"
            reade -Q "GREEN" -i "y" -p "Install pikaur ( Pacman wrapper )? [Y/n]: " "y n" insyay
            if [ "y" == "$insyay" ]; then 
                if ! test -f ../AUR_installers/install_pikaur.sh; then
                    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_pikaur.sh)" 
                else
                    eval ../AUR_installers/install_pikaur.sh
                fi
                AUR_helper="pikaur"
                AUR_update="pikaur -Syu"
                AUR_install="pikaur -S"
            fi
            unset insyay 
        fi
        distro_base="Arch"
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

if test $machine == 'Linux'; then
    arch_cmd="lscpu"
elif test $machine == 'Mac'; then
    arch_cmd="sysctl -n machdep.cpu.brand_string"
fi

if eval "$arch_cmd" | grep -q "Intel"; then
    arch="386"
elif eval "$arch_cmd" | grep -q "AMD"; then
    if lscpu | grep -q "x86_64"; then 
        arch="amd64"
    else
        arch="amd32"
    fi
elif eval "$arch_cmd" | grep -q "armv"; then
    arch="armv7l"
elif eval "$arch_cmd" | grep -q "aarch"; then
    arch="arm64"
fi
