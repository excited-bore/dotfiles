#!/bin/bash

if ! type reade &> /dev/null ; then
   test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh && source ~/.bash_aliases.d/00-rlwrap_scripts.sh 
   test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh && source aliases/.bash_aliases.d/00-rlwrap_scripts.sh 
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
if [[ $machine == 'Windows' ]]; then 
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
       if [[ "$wngt" == 'y' ]]; then
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
       if [[ "$gsdn" == 'y' ]]; then
            ./../install_gsudo.sh
       #else
           #exit 1
       fi
   fi
   if ! type jq &> /dev/null; then
       reade -Q 'GREEN' -i 'y' -p 'Install jq? (Json parser - used in scripts to get latest releases from github) [Y/n]: ' 'n' jqin 
       if [[ $jqin == 'y' ]]; then
            winget install jqlang.jq
       fi
   fi
   unset wngt wmic gsdn jqin
fi

# Shell that script is run in
# https://stackoverflow.com/questions/5166657/how-do-i-tell-what-type-my-shell-is

if test -n "$BASH_VERSION"; then
    SSHELL=bash
elif test -n "$ZSH_VERSION"; then
    SSHELL=zsh
elif test -n "$KSH_VERSION" || test -n "$FCEDIT"; then
    SSHELL=ksh
elif test -n "$PS3"; then
    SSHELL=unknown
else
    SSHELL=sh
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

if test -f /etc/alpine-release && [[ $distro == / ]]; then
    pac="apk"
    distro_base="BSD"
    distro="Alpine"
elif test -f /etc/manjaro-release && [[ $distro == / ]]; then
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
      
elif test -f /etc/issue && grep -q "Ubuntu" /etc/issue && [[ $distro == / ]]; then
    pac="apt"
    pac_up="sudo apt update"
    pac_ins="sudo apt install"
    pac_search="apt search"
    pac_ls_ins="apt list --installed" 

    distro_base="Debian"
    distro="Ubuntu"

    codename="$(lsb_release -a | grep --color=never 'Codename' | awk '{print $2}')"
    release="$(lsb_release -a | grep --color=never 'Release' | awk '{print $2;}')"

elif (test -f == /etc/SuSE-release || test -f == /etc/SUSE-brand) && [[ $distro == / ]]; then
    if ! test -z "$(lsb_release -a | grep Leap)"; then
        pac="zypper_leap"
    else
        pac="zypper_tumble"
    fi
    distro_base="Slackware"
    distro="openSUSE"
elif test -f == /etc/gentoo-release && [[ $distro == / ]]; then
    pac="emerge"
    distro_base="Slackware"
    distro="Gentoo"
elif test -f == /etc/fedora-release && [[ $distro == / ]]; then
    pac="dnf"
    distro_base="RedHat"
    distro="Fedora"
elif test -f == /etc/redhat-release && [[ $distro == / ]]; then
    pac="yum"
    distro_base="RedHat"
    distro="Redhat"
elif test -f == /etc/arch-release && [[ $distro == / ]]; then
       
    unset ansr ansr1 

    # Extra repositories check 
    if [[ $(grep 'extra' -A2 /etc/pacman.conf) =~ "#Include" ]]; then  
        readyn -p "Include 'extra' repositories for pacman?" ansr
        if [[ "$ansr" == 'y' ]]; then
            sudo sed -i '/^\[extra\]$/,/^$/ { s|#Siglevel =|Siglevel =| }' /etc/pacman.conf 
            sudo sed -i '/^\[extra\]$/,/^$/ { s|#Include =|Include =| }' /etc/pacman.conf 
        fi
    fi

    # Multilib repositories check 
    if [[ $(grep 'multilib' -A2 /etc/pacman.conf) =~ "#Include" ]]; then  
        readyn -p "Include 'multilib' repositories for pacman?" ansr1
        if [[ "$ansr" == 'y' ]]; then
            sudo sed -i '/^\[multilib\]$/,/^$/ { s|#Siglevel =|Siglevel =| }' /etc/pacman.conf 
            sudo sed -i '/^\[multilib\]$/,/^$/ { s|#Include =|Include =| }' /etc/pacman.conf 
        fi
    fi

    [[ "$ansr" == 'y' ]] || [[ "$ansr1" == 'y' ]] && sudo pacman -Syy 
    
    unset ansr ansr1 

    pac="pacman"
    pac_up="sudo pacman -Su"
    pac_ins="sudo pacman -S"
    pac_search="sudo pacman -Ss"
    pac_rm="pacman -R"
    pac_rm_casc="pacman -Rc"
    pac_rm_orph="pacman -Rs"
    pac_clean="sudo pacman -R $(pacman -Qdtq)"
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

        AUR_pac="sudo yay"
        AUR_up="sudo yay -Syu"
        AUR_ins="sudo yay -S"
        AUR_search="sudo yay -Ss"
        AUR_rm="sudo yay -R"
        AUR_rm_casc="sudo yay -Rc"
        AUR_rm_orph="sudo yay -Rs"
        AUR_clean="sudo yay -Sc"
        AUR_clean_cache="sudo yay -Scc"
        AUR_ls_ins="sudo yay -Q" 
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

elif test -f == /etc/rpi-issue && [[ $distro == / ]]; then

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

elif test -f == /etc/debian_version && [[ $distro == / ]]; then
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
    

if type nala &> /dev/null && [[ "$pac" == 'apt' ]]; then
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
if [[ $machine == 'Linux' ]]; then
    arch_cmd="lscpu"
elif [[ $machine == 'Mac' ]]; then
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

if ! test -f ~/.profile; then
    touch ~/.profile
fi

if test -f ~/.bash_profile; then
    export PROFILE=~/.bash_profile
fi

export ENVVAR=~/.bashrc

if test -f ~/.environment.env; then
    export ENVVAR=~/.environment.env
fi

export ALIAS=~/.bashrc

if test -f ~/.bash_aliases; then
    export ALIAS=~/.bash_aliases
fi

if test -d ~/.bash_aliases.d/; then
    export ALIAS_FILEDIR=~/.bash_aliases.d/
fi


export COMPLETION=~/.bashrc

if test -f ~/.bash_completion; then
    export COMPLETION=~/.bash_completion
fi

if test -d ~/.bash_completion.d/; then
    export COMPLETION_FILEDIR=~/.bash_completion.d/
fi


export KEYBIND=~/.bashrc

if test -f ~/.keybinds; then
    export KEYBIND=~/.keybinds
fi

if test -d ~/.keybinds.d/; then
    export KEYBIND_FILEDIR=~/.keybinds.d/
fi


if test -f ~/.bash_profile; then
    export PROFILE=~/.bash_profile
fi


export PROFILE_R=/root/.profile
export ALIAS_R=/root/.bashrc
export COMPLETION_R=/root/.bashrc
export KEYBIND_R=/root/.bashrc
export ENVVAR_R=/root/.bashrc


if test -f /root/.bash_profile; then
    export PROFILE_R=/root/.bash_profile
fi

if test -f /root/.environment.env; then
    export ENVVAR_R=/root/.environment.env
fi

if test -f /root/.bash_aliases; then
    export ALIAS_R=/root/.bash_aliases
fi
if test -d /root/.bash_aliases.d/; then
    export ALIAS_FILEDIR_R=/root/.bash_aliases.d/
fi

if test -f /root/.bash_completion; then
    export COMPLETION_R=/root/.bash_completion
fi

if test -d /root/.bash_completion.d/; then
    export COMPLETION_FILEDIR_R=/root/.bash_completion.d/
fi
if test -f /root/.keybinds  ; then
    export KEYBIND_R=/root/.keybinds
fi

if test -d /root/.keybinds.d/  ; then
    export KEYBIND_FILEDIR_R=/root/.keybindsd.d/
fi

