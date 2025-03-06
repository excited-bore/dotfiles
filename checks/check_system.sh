#!/bin/bash

# https://stackoverflow.com/questions/5412761/using-colors-with-printf
# Execute (during printf) for colored prompt
# printf  "${blue}This text is blue${white}\n"

# https://unix.stackexchange.com/questions/139231/keep-aliases-when-i-use-sudo-bash
if type sudo &> /dev/null; then
    alias sudo='sudo '
fi

if type wget &> /dev/null; then
    alias wget='wget --https-only '
fi

if type curl &> /dev/null; then
   alias curl='curl --proto "=https" --tlsv1.2 ' 
fi

# https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash

function version-higher () {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0})); then
            return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 1
        fi
    done
    return 0
}


function compare-tput-escape_color(){
for (( ansi=0; ansi <= 120; ansi++)); do
    printf "$ansi $(tput setaf $ansi) tput foreground $(tput sgr0) $(tput setab $ansi) tput background $(tput sgr0)"; echo -e " \033[$ansi;mEscape\033[0m"
done | $PAGER
unset ansi
}

red=$(tput setaf 1)
red1=$(tput setaf 9)
green=$(tput setaf 2)
green1=$(tput setaf 10)
yellow=$(tput setaf 3)
yellow1=$(tput setaf 11)
blue=$(tput setaf 4)
blue1=$(tput setaf 12)
magenta=$(tput setaf 5)
magenta1=$(tput setaf 13)
cyan=$(tput setaf 6)
cyan1=$(tput setaf 14)
white=$(tput setaf 7)
white1=$(tput setaf 15)
black=$(tput setaf 16)
grey=$(tput setaf 8)

RED=$(tput setaf 1 && tput bold)
RED1=$(tput setaf 9 && tput bold)
GREEN=$(tput setaf 2 && tput bold)
GREEN1=$(tput setaf 10 && tput bold)
YELLOW=$(tput setaf 3 && tput bold)
YELLOW1=$(tput setaf 11 && tput bold)
BLUE=$(tput setaf 4 && tput bold)
BLUE1=$(tput setaf 12 && tput bold)
MAGENTA=$(tput setaf 5 && tput bold)
MAGENTA1=$(tput setaf 13 && tput bold)
CYAN=$(tput setaf 6 && tput bold)
CYAN1=$(tput setaf 14 && tput bold)
WHITE=$(tput setaf 7 && tput bold)
WHITE1=$(tput setaf 15 && tput bold)
BLACK=$(tput setaf 16 && tput bold)
GREY=$(tput setaf 8 && tput bold)

bold=$(tput bold)
underline_on=$(tput smul)
underline_off=$(tput rmul)
bold_on=$(tput smso)
bold_off=$(tput rmso)
half_bright=$(tput dim)
reverse_color=$(tput rev)

# Reset
normal=$(tput sgr0)

# Broken !! (Or im dumb?)
blink=$(tput blink)
underline=$(tput ul)
italic=$(tput it)

# ...
# https://ss64.com/bash/tput.html

# Arguments: Completions(string with space entries, AWK works too),return value(-a password prompt, -c complete filenames, -p prompt flag, -Q prompt colour, -b break-chars (when does a string break for autocomp), -e change char given for multiple autocompletions)
# 'man rlwrap' to see all unimplemented options

if ! test -f /usr/local/bin/reade; then
    if test -f rlwrap-scripts/reade; then
        . ./rlwrap-scripts/reade 1> /dev/null
    else
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/reade)" &> /dev/null 
    fi
fi

if ! test -f /usr/local/bin/readyn; then
    if test -f rlwrap-scripts/readyn; then
        . ./rlwrap-scripts/readyn 1> /dev/null
    else
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/readyn)" &> /dev/null 
    fi
fi


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

pthdos2unix=""
if test $machine == 'Windows'; then 
    alias wget='wget.exe' 
    alias curl='curl.exe' 
   # https://stackoverflow.com/questions/13701218/windows-path-to-posix-path-conversion-in-bash 
   pthdos2unix="| sed 's/\\\/\\//g' | sed 's/://' | sed 's/^/\\//g'"
   wmic=$(wmic os get OSArchitecture | awk 'NR>1 {print}')
   if [[ $wmic =~ '64' ]]; then
       export ARCH_WIN='64'
   else
       export ARCH_WIN='32'
   fi
   if ! type winget &> /dev/null; then
       #win_ver=$(cmd /c ver)
       printf "${RED}Winget (official window package manager) not installed - can't run scripts without install programs through it${normal}\n" 
       readyn -p "(Attempt to) Install winget? ${CYAN}(Windows 10 - version 1809 required at mimimum for winget)${GREEN}" wngt
       if test "$wngt" == 'y'; then
            tmpd=$(mktemp -d)
            wget -P $tmpd https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1  
            sudo pwsh $tmpd/winget-install.ps1
       else
            printf "${RED}Can't install scripts without winget${normal}\n" 
            #exit 1 
       fi
   fi
   if ! type sudo &> /dev/null; then
       printf "${RED}Sudo (Commandline tool to install/modify files at higher privilige, as root/admin) not installed - most of the script won't run without without${normal}\n" 
       reade -Q 'GREEN' -i 'y' -p 'Install (g)sudo (unofficial sudo)? [Y/n]: ' 'n' gsdn
       if test $gsdn == 'y'; then
            ./../install_gsudo.sh
       #else
           #exit 1
       fi
   fi
   if ! type jq &> /dev/null; then
       reade -Q 'GREEN' -i 'y' -p 'Install jq? (Json parser - used in scripts to get latest releases from github) [Y/n]: ' 'n' jqin 
       if test $jqin == 'y'; then
            winget install jqlang.jq
       fi
   fi
   unset wngt wmic gsdn jqin
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

if type whereis &> /dev/null; then
    function where_cmd() { 
        eval "whereis $1 $pthdos2unix" | awk '{print $2;}'; 
    } 
elif type where &> /dev/null; then
    function where_cmd() { 
        eval "where $1 $pthdos2unix"; 
    } 
else
    printf "Can't find a 'where' command (whereis/where)\n"
    #exit 1 
fi

# https://unix.stackexchange.com/questions/202891/how-to-know-whether-wayland-or-x11-is-being-used
export X11_WAY="$(loginctl show-session $(loginctl | grep $(whoami) | awk 'NR=1{print $1}') -p Type | awk -F= 'NR==1{print $2}')"



no_aur=''

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
        pac="apk"
        distro_base="BSD"
        distro="Alpine"
    elif [ -f $f ] && [ $f == /etc/manjaro-release ] && [ $distro == / ]; then
        pac="pacman"
        pac_up="sudo pacman -Su"
        pac_ins="sudo pacman -S"
        pac_search="sudo pacman -Ss"
        pac_rm="sudo pacman -R"
        pac_rm_casc="sudo pacman -Rc"
        pac_rm_orph="sudo pacman -Rs"
        pac_clean_cache="sudo pacman -Scc"
        pac_ls_ins="pacman -Q"
         
        AUR_pac="pamac"
        AUR_up="pamac update"
        AUR_ins="pamac install"
        AUR_search="pamac search"
        AUR_rm="pamac remove" 
        AUR_rm_casc="pamac remove --cascade" 
        AUR_rm_orph="pamac remove --orphans"
        AUR_clean_cache="pamac clean"
        AUR_ls_ins="pamac list --installed"
         

        distro_base="Arch"
        distro="Manjaro"
          
    elif test -f /etc/issue && grep -q "Ubuntu" /etc/issue && [ $distro == / ]; then
        pac="apt"
        pac_up="sudo apt update"
        pac_ins="sudo apt install"
        pac_search="apt search"
        pac_ls_ins="apt list --installed" 

        distro_base="Debian"
        distro="Ubuntu"

        codename="$(lsb_release -a | grep --color=never 'Codename' | awk '{print $2}')"
        release="$(lsb_release -a | grep --color=never 'Release' | awk '{print $2;}')"

    elif test -f $f && [[ $f == /etc/SuSE-release || $f == /etc/SUSE-brand ]] && test $distro == /; then
        if ! test -z "$(lsb_release -a | grep Leap)"; then
            pac="zypper_leap"
        else
            pac="zypper_tumble"
        fi
        distro_base="Slackware"
        distro="openSUSE"
    elif [ -f $f ] && [ $f == /etc/gentoo-release ] && [ $distro == / ]; then
        pac="emerge"
        distro_base="Slackware"
        distro="Gentoo"
    elif [ -f $f ] && [ $f == /etc/fedora-release ] && [ $distro == / ]; then
        pac="dnf"
        distro_base="RedHat"
        distro="Fedora"
    elif [ -f $f ] && [ $f == /etc/redhat-release ] && [ $distro == / ]; then
        pac="yum"
        distro_base="RedHat"
        distro="Redhat"
    elif [ -f $f ] && [ $f == /etc/arch-release ] && [ $distro == / ]; then
           
        unset ansr ansr1 

        # Extra repositories check 
        if [[ $(grep 'extra' -A2 /etc/pacman.conf) =~ "#Include" ]]; then  
            readyn -p "Include 'extra' repositories for pacman?" ansr
            if test "$ansr" == 'y'; then
                sudo sed -i '/^\[extra\]$/,/^$/ { s|#Siglevel =|Siglevel =| }' /etc/pacman.conf 
                sudo sed -i '/^\[extra\]$/,/^$/ { s|#Include =|Include =| }' /etc/pacman.conf 
            fi
        fi

        # Multilib repositories check 
        if [[ $(grep 'multilib' -A2 /etc/pacman.conf) =~ "#Include" ]]; then  
            readyn -p "Include 'multilib' repositories for pacman?" ansr1
            if test "$ansr" == 'y'; then
                sudo sed -i '/^\[multilib\]$/,/^$/ { s|#Siglevel =|Siglevel =| }' /etc/pacman.conf 
                sudo sed -i '/^\[multilib\]$/,/^$/ { s|#Include =|Include =| }' /etc/pacman.conf 
            fi
        fi

        test "$ansr" == 'y' || test "$ansr1" == 'y' && sudo pacman -Syy 
        
        unset ansr ansr1 

        pac="pacman"
        pac_up="sudo pacman -Su"
        pac_ins="sudo pacman -S"
        pac_search="sudo pacman -Ss"
        pac_rm="pacman -R"
        pac_rm_casc="pacman -Rc"
        pac_rm_orph="pacman -Rs"
        pac_clean_cache="pacman -Scc"
        pac_ls_ins="pacman -Q" 

        
        #
        # PACMAN WRAPPERS
        # 
        
        # Check every package manager known by archwiki 
        #
        if type pamac &> /dev/null; then

            AUR_pac="pamac"
            AUR_up="pamac update"
            AUR_ins="pamac install"
            AUR_search="pamac search"
            AUR_rm="pamac remove" 
            AUR_rm_casc="pamac remove --cascade" 
            AUR_rm_orph="pamac remove --orphans"
            AUR_clean_cache="pamac clean"
            AUR_ls_ins="pamac list --installed"    
        elif type yay &> /dev/null; then

            AUR_pac="yay"
            AUR_up="yay -Syu"
            AUR_ins="yay -S"
            AUR_search="yay -Ss"
            AUR_rm="yay -R"
            AUR_rm_casc="yay -Rc"
            AUR_rm_orph="yay -Rs"
            AUR_clean="yay -Sc"
            AUR_clean_cache="yay -Scc"
            AUR_ls_ins="yay -Q" 
        elif type pikaur &> /dev/null; then

            AUR_pac="pikaur"
            AUR_up="pikaur -Syu"
            AUR_ins="pikaur -S"
            AUR_search="pikaur -Ss"
            AUR_rm="pikaur -R"
            AUR_rm_casc="pikaur -Rc"
            AUR_rm_orph="pikaur -Rs"
            AUR_clean="pikaur -Sc"
            AUR_clean_cache="pikaur -Scc"
            AUR_ls_ins="pikaur -Q"
        elif type pacaur &> /dev/null; then

            AUR_pac="pacaur"
            AUR_up="pacaur -Syu"
            AUR_ins="pacaur -S"
            AUR_search="pacaur -Ss"
            AUR_clean="pacaur -Sc"
            AUR_ls_ins="pacaur -Q"

        elif type aura &> /dev/null; then

            AUR_pac="aura"
            AUR_up="aura -Au"
            AUR_ins="aura -A"
            AUR_search="aura -Ss"
            AUR_ls_ins="aura -Q"
             
        elif type aurman &> /dev/null; then

            AUR_pac="aurman"
            AUR_up="aurman -Syu"
            AUR_ins="aurman -S"
            AUR_search="aurman -Ss"
            AUR_ls_ins="aurman -Q"

        elif type pakku &> /dev/null ; then

            AUR_pac="pakku"
            AUR_up="pakku -Syu"
            AUR_ins="pakku -S"
            AUR_search="pakku -Ss"
            AUR_ls_ins="pakku -Q"
             
        elif type paru &> /dev/null; then
            AUR_pac="paru"
            AUR_up="paru -Syua"
            AUR_ins="paru -S"
            AUR_search="paru -Ss"
            AUR_search="paru -Q"
             
        elif type trizen &> /dev/null; then
            AUR_pac="trizen"
            AUR_up="trizen -Syu"
            AUR_ins="trizen -S"
            AUR_search="trizen -Ss"
            AUR_ls_ins="trizen -Q"

        #
        # SEARCH AND BUILD
        # 
        
        # Aurutils
        elif type aur &> /dev/null; then
            AUR_pac="aur"
            AUR_up=""
            AUR_ins=""
            AUR_search="aur search"
             
        #elif type repoctl &> /dev/null; then
        #    pac_AUR="repoctl"
        #elif type yaah &> /dev/null; then
        #    pac_AUR="yaah"
        #elif type bauerbill &> /dev/null; then
        #    pac_AUR="bauerbill"
        #elif type PKGBUILDer &> /dev/null; then
        #    pac_AUR="PKGBUILDer"
        #elif type rua &> /dev/null; then
        #    pac_AUR="rua"
        #elif type pbget &> /dev/null; then
        #    pac_AUR="pbget"
        #elif type argon &> /dev/null ; then
        #    pac_AUR="argon"
        #elif type cylon &> /dev/null; then
        #    pac_AUR="cylon"
        #elif type kalu &> /dev/null; then
        #    pac_AUR="kalu"
        #elif type octopi &> /dev/null; then
        #    pac_AUR="octopi"
        #elif type PkgBrowser &> /dev/null; then
        #    pac_AUR="PkgBrowser"
        #elif type yup &> /dev/null ; then
        #    pac_AUR="yup"
        elif type auracle &> /dev/null; then

            AUR_pac="auracle"
            AUR_up="auracle update"
            AUR_ins=""
            AUR_search="auracle search"
             
        else
            no_aur='TRUE' 
        fi

        distro_base="Arch"
        distro="Arch"

    elif [ -f $f ] && [ $f == /etc/rpi-issue ] && [ $distro == / ];then

        pac="apt"
        pac_ins="sudo apt install"
        pac_up="sudo apt update"
        pac_upg="sudo apt upgrade"
        pac_search="apt search"
        pac_rm="sudo apt remove"
        pac_rm_orph="sudo apt purge"
        pac_clean="sudo apt autoremove"
        pac_clean_cache="sudo apt clean"
        pac_ls_ins="apt list --installed"
                     
        distro_base="Debian"
        distro="Raspbian"

    elif [ -f $f ] && [ $f == /etc/debian_version ] && [ $distro == / ];then
        pac="apt"
        pac_ins="sudo apt install"
        pac_up="sudo apt update"
        pac_upg="sudo apt upgrade"
        pac_search="apt search"
        pac_rm="sudo apt remove"
        pac_rm_orph="sudo apt purge"
        pac_clean="sudo apt autoremove"
        pac_clean_cache="sudo apt clean"
        pac_ls_ins="apt list --installed"
         
        distro_base="Debian"   
        distro="Debian"
    fi 
done
    


if ! type curl &> /dev/null && ! test -z "$pac_ins"; then
    ${pac_ins} curl
fi

if ! type jq &> /dev/null && ! test -z "$pac_ins"; then
    ${pac_ins} jq
fi


if type pamac &> /dev/null; then
    if ! test -f checks/check_pamac.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)" 
    else
        . ./checks/check_pamac.sh
    fi
fi

if ! test -z "$no_aur"; then
    printf "Your Arch system seems to have no (known) AUR helper installed\n"
    readyn -Y 'CYAN' -p "Install yay ( AUR helper/wrapper )?" insyay
    if [ "y" == "$insyay" ]; then 

        if ! test -f ../AUR_installers/install_yay.sh; then 
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_yay.sh)" 
        else
            eval ../AUR_installers/install_yay.sh
        fi

        AUR_pac="yay"
        AUR_up="yay -Syu"
        AUR_ins="yay -S"
        AUR_search="yay -Ss"
        AUR_rm="yay -R"
        AUR_rm_casc="yay -Rc"
        AUR_rm_orph="yay -Rs"
        AUR_clean="yay -Sc"
        AUR_clean_cache="yay -Scc"
        AUR_ls_ins="yay -Q" 
         
    fi
    unset insyay 
fi


if type nala &> /dev/null && test "$pac" == 'apt'; then
    pac="nala"
    pac_ins="sudo nala install"
    pac_up="sudo nala update"
    pac_upg="sudo nala upgrade"
    pac_search="nala search"
    pac_rm="sudo nala remove"
    pac_rm_orph="sudo nala purge"
    pac_clean="sudo nala autoremove"
    pac_clean_cache="sudo nala clean"
    pac_ls_ins="nala list --installed"
fi

# TODO: Change this to uname -sm?
if test $machine == 'Linux'; then
    arch_cmd="lscpu"
elif test $machine == 'Mac'; then
    arch_cmd="sysctl -n machdep.cpu.brand_string"
fi

if ${arch_cmd} | grep -q "Intel"; then
    arch="386"
elif ${arch_cmd} | grep -q "AMD"; then
    if lscpu | grep -q "x86_64"; then 
        arch="amd64"
    else
        arch="amd32"
    fi
elif ${arch_cmd} | grep -q "armv"; then
    arch="armv7l"
elif ${arch_cmd} | grep -q "aarch"; then
    arch="arm64"
fi

# VARS

export PROFILE=~/.profile

if ! [ -f ~/.profile ]; then
    touch ~/.profile
fi

if [ -f ~/.bash_profile ]; then
    export PROFILE=~/.bash_profile
fi

export ENVVAR=~/.bashrc

if [ -f ~/.environment.env ]; then
    export ENVVAR=~/.environment.env
fi

export ALIAS=~/.bashrc

if [ -f ~/.bash_aliases ]; then
    export ALIAS=~/.bash_aliases
fi

if [ -d ~/.bash_aliases.d/ ]; then
    export ALIAS_FILEDIR=~/.bash_aliases.d/
fi


export COMPLETION=~/.bashrc

if [ -f ~/.bash_completion ]; then
    export COMPLETION=~/.bash_completion
fi

if [ -d ~/.bash_completion.d/ ]; then
    export COMPLETION_FILEDIR=~/.bash_completion.d/
fi


export KEYBIND=~/.bashrc

if [ -f ~/.keybinds ]; then
    export KEYBIND=~/.keybinds
fi

if [ -d ~/.keybinds.d/ ]; then
    export KEYBIND_FILEDIR=~/.keybinds.d/
fi


if [ -f ~/.bash_profile ]; then
    export PROFILE=~/.bash_profile
fi


export PROFILE_R=/root/.profile
export ALIAS_R=/root/.bashrc
export COMPLETION_R=/root/.bashrc
export KEYBIND_R=/root/.bashrc
export ENVVAR_R=/root/.bashrc

#echo "This next $(tput setaf 1)sudo$(tput sgr0) checks for the profile, environment, bash_alias, bash_completion and keybind files and dirs in '/root/' to generate global variables.";

if ! sudo test -f /root/.profile; then
    sudo touch /root/.profile
fi

if sudo test -f /root/.bash_profile; then
    export PROFILE_R=/root/.bash_profile
fi

if sudo test -f /root/.environment.env; then
    export ENVVAR_R=/root/.environment.env
fi

if sudo test -f /root/.bash_aliases; then
    export ALIAS_R=/root/.bash_aliases
fi
if sudo test -d /root/.bash_aliases.d/; then
    export ALIAS_FILEDIR_R=/root/.bash_aliases.d/
fi

if sudo test -f /root/.bash_completion; then
    export COMPLETION_R=/root/.bash_completion
fi

if sudo test -d /root/.bash_completion.d/; then
    export COMPLETION_FILEDIR_R=/root/.bash_completion.d/
fi
if sudo test -f /root/.keybinds  ; then
    export KEYBIND_R=/root/.keybinds
fi