if ! type reade &>/dev/null; then
    test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh && source aliases/.bash_aliases.d/00-rlwrap_scripts.sh ||
    test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh && source ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) machine=Linux ;;
Darwin*) machine=Mac ;;
CYGWIN*)
    machine=Windows
    win_bash_shell=Cygwin
    ;;
MINGW*)
    machine=Windows
    win_bash_shell=Git
    ;;
*) machine="UNKNOWN:${unameOut}" ;;
esac

if test -z "$TMPDIR"; then
    if test -d /tmp; then
        TMPDIR=/tmp
    else
        TMPDIR=$(mktemp -d)
    fi
fi

if test -z "$TMP"; then
    TMP=$TMPDIR
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
    if ! hash winget &>/dev/null; then
        #win_ver=$(cmd /c ver)
        printf "${RED}Winget (official window package manager) not installed - can't run scripts without install programs through it${normal}\n"
        readyn -p "(Attempt to) Install winget? ${CYAN}(Windows 10 - version 1809 required at mimimum for winget)${GREEN}" wngt
        if [[ "$wngt" == 'y' ]]; then
            tmpd=$(mktemp -d)
            wget-dir $tmpd https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1
            sudo pwsh $tmpd/winget-install.ps1
        else
            printf "${RED}Can't install scripts without winget${normal}\n"
            #exit 1
        fi
    fi
    if ! hash sudo &>/dev/null; then
        printf "${RED}Sudo (Commandline tool to install/modify files at higher privilige, as root/admin) not installed - most of the script won't run without without${normal}\n"
        reade -Q 'GREEN' -i 'y n' -p 'Install (g)sudo (unofficial sudo)? [Y/n]: ' gsdn
        if [[ "$gsdn" == 'y' ]]; then
            ./../install_gsudo.sh
            #else
            #exit 1
        fi
    fi
    if ! hash jq &>/dev/null; then
        reade -Q 'GREEN' -i 'y n' -p 'Install jq? (Json parser - used in scripts to get latest releases from github) [Y/n]: ' jqin
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

if test -z "$EDITOR"; then
    if hash nano &>/dev/null; then
        EDITOR=nano
    elif hash vi &>/dev/null; then
        EDITOR=vi
    else
        EDITOR=edit
    fi
fi

if hash whereis &>/dev/null; then
    function where_cmd() {
        eval "whereis $1 $pthdos2unix" | awk '{print $2;}'
    }
elif hash where &>/dev/null; then
    function where_cmd() {
        eval "where $1 $pthdos2unix"
    }
else
    printf "Can't find a 'where' command (whereis/where)\n"
    #exit 1
fi

if [[ $machine == 'Mac' ]] && hash brew &> /dev/null; then
    pac="brew"
    pac_up="brew update"
    pac_upg="brew update"
    pac_ins="brew install"
    pac_search="brew search"
    pac_rm="brew uninstall"
    pac_rm_orph="brew autoremove"
    pac_clean="brew cleanup"
    pac_clean_cache="brew cleanup --scrub"
    pac_ls_ins="brew list"
    #pac_rm_casc="sudo pacman -Rc"
fi

# https://unix.stackexchange.com/questions/202891/how-to-know-whether-wayland-or-x11-is-being-used
# Just use $XDG_SESSION_TYPE
#[[ $machine == 'Linux' ]] &&
#    export X11_WAY="$(loginctl show-session $(loginctl | grep $(whoami) | awk 'NR=1{print $1}') -p Type | awk -F= 'NR==1{print $2}')"

no_aur=''

distro_base=/
distro=/
packagemanager=/
arch=/

if test -f /etc/alpine-release; then
    pac="apk"
    distro_base="BSD"
    distro="Alpine"

elif (test -f /etc/issue && grep -q "Ubuntu" /etc/issue) || test -f /etc/rpi-issue || test -f /etc/debian_version; then

    pac="apt"
    pac_ins="sudo apt --fix-broken install"
    pac_ins_y="sudo apt -y --fix-broken install"
    pac_up="sudo apt --fix-broken upgrade"
    pac_up_y="sudo apt --fix-broken upgrade -y"
    pac_fullup="sudo apt --fix-broken full-upgrade"
    pac_fullup_y="sudo apt --fix-broken full-upgrade -y"
    pac_refresh="sudo apt update"
    pac_refresh_y="sudo apt update -y"
    pac_refresh_up="sudo apt update && sudo apt --fix-broken upgrade"
    pac_refresh_up_y="sudo apt update -y && sudo apt --fix-broken upgrade -y"
    pac_refresh_fullup="sudo apt update && sudo apt --fix-broken full-upgrade"
    pac_refresh_fullup_y="sudo apt update -y && sudo apt --fix-broken full-upgrade -y"
    pac_search="apt search"
    pac_search_q="apt-cache -qq search"
    pac_search_ins="dpkg-query -W"
    pac_search_ins_q="dpkg-query -f '\${Package}\n' -W "  
    pac_info="apt show"  
    pac_info_all="apt show -a"  
    pac_rm="sudo apt remove"
    pac_rm_y="sudo apt -y remove"
    pac_rm_purge="sudo apt purge"
    pac_rm_purge_y="sudo apt purge -y"
    pac_rm_orph="sudo apt autopurge"
    pac_rm_orph_y="sudo apt autopurge -y"
    pac_rm_cache="sudo apt clean"
    pac_rm_cache_y="sudo apt clean -y"
    pac_rm_cache_full="sudo apt distclean"
    pac_rm_cache_full_y="sudo apt distclean -y"
    pac_ls="apt list"
    pac_ls_ins="apt list --installed"
    pac_ls_upg="apt list --upgradable"


    distro_base="Debian"

    if test -f /etc/issue && grep -q "Ubuntu" /etc/issue; then
        distro="Ubuntu"
        codename="$(lsb_release -a | grep --color=never 'Codename' | awk '{print $2}')"
        release="$(lsb_release -a | grep --color=never 'Release' | awk '{print $2;}')"
    elif test -f /etc/rpi-issue; then
        distro="Raspbian"
    elif test -f /etc/debian_version; then
        distro="Debian" 
    fi

elif test -f /etc/SuSE-release || test -f /etc/SUSE-brand; then
    if ! test -z "$(lsb_release -a | grep Leap)"; then
        pac="zypper_leap"
    else
        pac="zypper_tumble"
    fi
    distro_base="Slackware"
    distro="openSUSE"

elif test -f /etc/gentoo-release && [[ $distro == / ]]; then
    pac="emerge"
    distro_base="Slackware"
    distro="Gentoo"

elif test -f /etc/fedora-release && [[ $distro == / ]]; then
    pac="dnf"
    distro_base="RedHat"
    distro="Fedora"

elif test -f /etc/redhat-release && [[ $distro == / ]]; then
    pac="yum"
    distro_base="RedHat"
    distro="Redhat"

elif (test -f /etc/arch-release || test -f /etc/manjaro-release) && [[ $distro == / ]]; then

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

    [[ "$ansr" == 'y' ]] || [[ "$ansr1" == 'y' ]] && 
        sudo pacman -Syy

    unset ansr ansr1

    pac="pacman"
    pac_y="--noconfirm"
    pac_ins="sudo pacman -S"
    pac_ins_y="sudo pacman --noconfirm -S"
    pac_refresh="sudo pacman -Sy"
    pac_force_refresh="sudo pacman -Syy"
    pac_up="sudo pacman -Su"
    pac_up_y="sudo pacman --noconfirm -Su"
    pac_refresh_up="sudo pacman -Syu"
    pac_refresh_up_y="sudo pacman --noconfirm -Syu"
    pac_force_refresh_up="sudo pacman -Syyuu"
    pac_force_refresh_up_y="sudo pacman --noconfirm -Syyuu"
    pac_search="pacman -Ss"
    pac_search_q="pacman -Ssq"
    pac_search_ins="pacman -Qs"
    pac_search_ins_q="pacman -Qsq"
    pac_info="pacman -Si"
    pac_rm="sudo pacman -R"
    pac_rm_y="sudo pacman --noconfirm -R"
    pac_rm_casc="sudo pacman -Rc"
    pac_rm_casc_y="sudo pacman --noconfirm -Rc"
    pac_rm_orph="sudo pacman -Rs $(pacman -Qd --unrequired --quiet)"
    pac_rm_orph_y="sudo pacman --noconfirm -Rs $(pacman -Qd --unrequired --quiet)"
    pac_rm_purge="sudo pacman -Rns"
    pac_rm_purge_y="sudo pacman --no-confirm -Rns"
    pac_rm_cache="sudo pacman -Sc"
    pac_rm_cache_y="sudo pacman --noconfirm -Sc"
    pac_rm_cache_full="sudo pacman -Scc"
    pac_rm_cache_full_y="sudo pacman --noconfirm -Scc"
    pac_ls_ins="pacman -Q"
    pac_ls_orhpan="pacman -Qdtq" 
    pac_ls_foreign="pacman -Qm"
    
   
    #
    # PACMAN WRAPPERS
    #

    # Check every package manager known by archwiki
    #
    if hash pamac &>/dev/null; then
        # Doesn't need sudo 
        AUR_pac="pamac"
        AUR_pac_y="--no-confirm"
        AUR_up="pamac update"
        AUR_up_y="pamac update --no-confirm"
        AUR_ins="pamac install"
        AUR_ins_y="pamac install --no-confirm"
        AUR_search="pamac search"
        AUR_search_q="pamac search --quiet"
        AUR_search_ins="pamac search --installed"
        AUR_search_ins_q="pamac search --installed --quiet"
        AUR_info="pamac info"
        AUR_rm="pamac remove"
        AUR_rm_y="pamac remove --no-confirm"
        AUR_rm_casc="pamac remove --cascade"
        AUR_rm_casc="pamac remove --cascade --no-confirm"
        AUR_rm_orph="pamac remove --orphans"
        AUR_rm_orph_y="pamac remove --orphans --no-confirm"
        # Not actual purge, only removes orphans and clears cache
        AUR_rm_purge="pamac remove --orphans --no-save"
        AUR_rm_purge_y="pamac remove --orphans --no-save --no-confirm"
        AUR_rm_cache="pamac clean"
        AUR_rm_cache_y="pamac clean --no-confirm"
        AUR_rm_cache_full="pamac clean --build-files"
        AUR_rm_cache_full_y="pamac clean --build-files --no-confirm"
        AUR_ls_ins="pamac list --installed"
        AUR_ls_orphan="pamac list --orphans"
        AUR_ls_foreign="pamac list --foreign"

    elif hash yay &>/dev/null; then
        # Doesn't need sudo 
        AUR_pac="yay"
        AUR_y="--noconfirm"
        AUR_ins="yay -S"
        AUR_ins_y="yay --noconfirm -S"
        AUR_refresh="yay -Sy"
        AUR_force_refresh="yay -Syy"
        AUR_up="yay -Su"
        AUR_up_y="yay --noconfirm -Su"
        AUR_refresh_up="yay -Syu"
        AUR_refresh_up_y="yay --noconfirm -Syu"
        AUR_force_refresh_up="yay -Syyuu"
        AUR_force_refresh_up_y="yay --noconfirm -Syyuu"
        AUR_search="yay -Ss"
        AUR_search_q="yay -Ssq"
        AUR_search_ins="yay -Qs"
        AUR_search_ins_q="yay -Qsq"
        AUR_info="yay -Si"
        AUR_rm="yay -R"
        AUR_rm_y="yay --noconfirm -R"
        AUR_rm_casc="yay -Rc"
        AUR_rm_casc_y="yay --noconfirm -Rc"
        AUR_rm_orph="yay -Rs $(yay -Qd --unrequired --quiet)"
        AUR_rm_orph_y="yay --noconfirm -Rs $(yay -Qd --unrequired --quiet)"
        AUR_rm_purge="yay -Rns"
        AUR_rm_purge_y="yay -Rns --noconfirm"
        AUR_rm_cache="yay -Sc"
        AUR_rm_cache_y="yay --noconfirm -Sc"
        AUR_rm_cache_full="yay -Scc"
        AUR_rm_cache_full_y="yay --noconfirm -Scc"
        AUR_ls_ins="yay -Q"
        AUR_ls_orhpan="yay -Qdtq" 
        AUR_ls_foreign="yay -Qm"
       

    elif hash pikaur &>/dev/null; then
        # Doesn't need sudo 
        AUR_pac="pikaur"
        AUR_y="--noconfirm"
        AUR_ins="pikaur -S"
        AUR_ins_y="pikaur --noconfirm -S"
        AUR_refresh="pikaur -Sy"
        AUR_force_refresh="pikaur -Syy"
        AUR_up="pikaur -Su"
        AUR_up_y="pikaur --noconfirm -Su"
        AUR_refresh_up="pikaur -Syu"
        AUR_refresh_up_y="pikaur --noconfirm -Syu"
        AUR_force_refresh_up="pikaur -Syyuu"
        AUR_force_refresh_up_y="pikaur --noconfirm -Syyuu"
        AUR_search="pikaur -Ss"
        AUR_search_q="pikaur -Ssq"
        AUR_search_ins="pikaur -Qs"
        AUR_search_ins_q="pikaur -Qsq"
        AUR_info="pikaur -Si"
        AUR_rm="pikaur -R"
        AUR_rm_y="pikaur --noconfirm -R"
        AUR_rm_casc="pikaur -Rc"
        AUR_rm_casc_y="pikaur --noconfirm -Rc"
        AUR_rm_orph="pikaur -Rs $(pikaur -Qd --unrequired --quiet)"
        AUR_rm_orph_y="pikaur --noconfirm -Rs $(pikaur -Qd --unrequired --quiet)"
        AUR_rm_purge="pikaur -Rns"
        AUR_rm_purge_y="pikaur -Rns --noconfirm"
        AUR_rm_cache="pikaur -Sc"
        AUR_rm_cache_y="pikaur --noconfirm -Sc"
        AUR_rm_cache_full="pikaur -Scc"
        AUR_rm_cache_full_y="pikaur --noconfirm -Scc"
        AUR_ls_ins="pikaur -Q"
        AUR_ls_orhpan="pikaur -Qdtq" 
        AUR_ls_foreign="pikaur -Qm"
        
    elif hash pacaur &>/dev/null; then
        # Doesn't need sudo 
        AUR_pac="pacaur"
        AUR_y="--noconfirm"
        AUR_ins="pacaur -S"
        AUR_ins_y="pacaur --noconfirm -S"
        AUR_refresh="pacaur -Sy"
        AUR_force_refresh="pacaur -Syy"
        AUR_up="pacaur -Su"
        AUR_up_y="pacaur --noconfirm -Su"
        AUR_refresh_up="pacaur -Syu"
        AUR_refresh_up_y="pacaur --noconfirm -Syu"
        AUR_force_refresh_up="pacaur -Syyuu"
        AUR_force_refresh_up_y="pacaur --noconfirm -Syyuu"
        AUR_search="pacaur -Ss"
        AUR_search_q="pacaur -Ssq"
        AUR_search_ins="pacaur -Qs"
        AUR_search_ins_q="pacaur -Qsq"
        AUR_info="pacaur -Si"
        AUR_rm="pacaur -R"
        AUR_rm_y="pacaur --noconfirm -R"
        AUR_rm_casc="pacaur -Rc"
        AUR_rm_casc_y="pacaur --noconfirm -Rc"
        AUR_rm_orph="pacaur -Rs $(pacaur -Qd --unrequired --quiet)"
        AUR_rm_orph_y="pacaur --noconfirm -Rs $(pacaur -Qd --unrequired --quiet)"
        AUR_rm_purge="pacaur -Rns"
        AUR_rm_purge_y="pacaur -Rns --noconfirm"
        AUR_rm_cache="pacaur -Sc"
        AUR_rm_cache_y="pacaur --noconfirm -Sc"
        AUR_rm_cache_full="pacaur -Scc"
        AUR_rm_cache_full_y="pacaur --noconfirm -Scc"
        AUR_ls_ins="pacaur -Q"
        AUR_ls_orhpan="pacaur -Qdtq" 
        AUR_ls_foreign="pacaur -Qm"    
   
    elif hash aura &>/dev/null; then
        # Doesn't need sudo 
        AUR_pac="aura"
        AUR_y="--noconfirm"
        AUR_ins="aura -S"
        AUR_ins_y="aura --noconfirm -S"
        AUR_refresh="aura -Sy"
        AUR_force_refresh="aura -Syy"
        AUR_up="aura -Su"
        AUR_up_y="aura --noconfirm -Su"
        AUR_refresh_up="aura -Syu"
        AUR_refresh_up_y="aura --noconfirm -Syu"
        AUR_force_refresh_up="aura -Syyuu"
        AUR_force_refresh_up_y="aura --noconfirm -Syyuu"
        AUR_search="aura -Ss"
        AUR_search_q="aura -Ssq"
        AUR_search_ins="aura -Qs"
        AUR_search_ins_q="aura -Qsq"
        AUR_info="aura -Si"
        AUR_rm="aura -R"
        AUR_rm_y="aura --noconfirm -R"
        AUR_rm_casc="aura -Rc"
        AUR_rm_casc_y="aura --noconfirm -Rc"
        AUR_rm_orph="aura -Rs $(aura -Qd --unrequired --quiet)"
        AUR_rm_orph_y="aura --noconfirm -Rs $(aura -Qd --unrequired --quiet)"
        AUR_rm_purge="aura -Rns"
        AUR_rm_purge_y="aura -Rns --noconfirm"
        AUR_rm_cache="aura -Sc"
        AUR_rm_cache_y="aura --noconfirm -Sc"
        AUR_rm_cache_full="aura -Scc"
        AUR_rm_cache_full_y="aura --noconfirm -Scc"
        AUR_ls_ins="aura -Q"
        AUR_ls_orhpan="aura -Qdtq" 
        AUR_ls_foreign="aura -Qm"

    elif hash pakku &>/dev/null; then
        # Doesn't need sudo 
        AUR_pac="pakku"
        AUR_y="--noconfirm"
        AUR_ins="pakku -S"
        AUR_ins_y="pakku --noconfirm -S"
        AUR_refresh="pakku -Sy"
        AUR_force_refresh="pakku -Syy"
        AUR_up="pakku -Su"
        AUR_up_y="pakku --noconfirm -Su"
        AUR_refresh_up="pakku -Syu"
        AUR_refresh_up_y="pakku --noconfirm -Syu"
        AUR_force_refresh_up="pakku -Syyuu"
        AUR_force_refresh_up_y="pakku --noconfirm -Syyuu"
        AUR_search="pakku -Ss"
        AUR_search_q="pakku -Ssq"
        AUR_search_ins="pakku -Qs"
        AUR_search_ins_q="pakku -Qsq"
        AUR_info="pakku -Si"
        AUR_rm="pakku -R"
        AUR_rm_y="pakku --noconfirm -R"
        AUR_rm_casc="pakku -Rc"
        AUR_rm_casc_y="pakku --noconfirm -Rc"
        AUR_rm_orph="pakku -Rs $(pakku -Qd --unrequired --quiet)"
        AUR_rm_orph_y="pakku --noconfirm -Rs $(pakku -Qd --unrequired --quiet)"
        AUR_rm_purge="pakku -Rns"
        AUR_rm_purge_y="pakku -Rns --noconfirm"
        AUR_rm_cache="pakku -Sc"
        AUR_rm_cache_y="pakku --noconfirm -Sc"
        AUR_rm_cache_full="pakku -Scc"
        AUR_rm_cache_full_y="pakku --noconfirm -Scc"
        AUR_ls_ins="pakku -Q"
        AUR_ls_orhpan="pakku -Qdtq" 
        AUR_ls_foreign="pakku -Qm"

    elif hash paru &>/dev/null; then
        # Doesn't need sudo 
        AUR_pac="paru"
        AUR_y="--noconfirm"
        AUR_ins="paru -S"
        AUR_ins_y="paru --noconfirm -S"
        AUR_refresh="paru -Sy"
        AUR_force_refresh="paru -Syy"
        AUR_up="paru -Su"
        AUR_up_y="paru --noconfirm -Su"
        AUR_refresh_up="paru -Syu"
        AUR_refresh_up_y="paru --noconfirm -Syu"
        AUR_force_refresh_up="paru -Syyuu"
        AUR_force_refresh_up_y="paru --noconfirm -Syyuu"
        AUR_search="paru -Ss"
        AUR_search_q="paru -Ssq"
        AUR_search_ins="paru -Qs"
        AUR_search_ins_q="paru -Qsq"
        AUR_info="paru -Si"
        AUR_rm="paru -R"
        AUR_rm_y="paru --noconfirm -R"
        AUR_rm_casc="paru -Rc"
        AUR_rm_casc_y="paru --noconfirm -Rc"
        AUR_rm_orph="paru -Rs $(paru -Qd --unrequired --quiet)"
        AUR_rm_orph_y="paru --noconfirm -Rs $(paru -Qd --unrequired --quiet)"
        AUR_rm_purge="paru -Rns"
        AUR_rm_purge_y="pakku -Rns --noconfirm"
        AUR_rm_cache="paru -Sc"
        AUR_rm_cache_y="paru --noconfirm -Sc"
        AUR_rm_cache_full="paru -Scc"
        AUR_rm_cache_full_y="paru --noconfirm -Scc"
        AUR_ls_ins="paru -Q"
        AUR_ls_orhpan="paru -Qdtq" 
        AUR_ls_foreign="paru -Qm"

    elif hash trizen &>/dev/null; then
        # Doesn't need sudo 
        AUR_pac="trizen"
        AUR_y="--noconfirm"
        AUR_ins="trizen -S"
        AUR_ins_y="trizen --noconfirm -S"
        AUR_refresh="trizen -Sy"
        AUR_force_refresh="trizen -Syy"
        AUR_up="trizen -Su"
        AUR_up_y="trizen --noconfirm -Su"
        AUR_refresh_up="trizen -Syu"
        AUR_refresh_up_y="trizen --noconfirm -Syu"
        AUR_force_refresh_up="trizen -Syyuu"
        AUR_force_refresh_up_y="trizen --noconfirm -Syyuu"
        AUR_search="trizen -Ss"
        AUR_search_q="trizen -Ssq"
        AUR_search_ins="trizen -Qs"
        AUR_search_ins_q="trizen -Qsq"
        AUR_info="trizen -Si"
        AUR_rm="trizen -R"
        AUR_rm_y="trizen --noconfirm -R"
        AUR_rm_casc="trizen -Rc"
        AUR_rm_casc_y="trizen --noconfirm -Rc"
        AUR_rm_orph="trizen -Rs $(trizen -Qd --unrequired --quiet)"
        AUR_rm_orph_y="trizen --noconfirm -Rs $(trizen -Qd --unrequired --quiet)"
        AUR_rm_purge="trizen -Rns"
        AUR_rm_purge_y="trizen -Rns --noconfirm"
        AUR_rm_cache="trizen -Sc"
        AUR_rm_cache_y="trizen --noconfirm -Sc"
        AUR_rm_cache_full="trizen -Scc"
        AUR_rm_cache_full_y="trizen --noconfirm -Scc"
        AUR_ls_ins="trizen -Q"
        AUR_ls_orhpan="trizen -Qdtq" 
        AUR_ls_foreign="trizen -Qm"

    elif hash aurman &>/dev/null; then
        # Doesn't need sudo 
        AUR_pac="aurman"
        AUR_y="--noconfirm"
        AUR_ins="aurman -S"
        AUR_ins_y="aurman --noconfirm -S"
        AUR_refresh="aurman -Sy"
        AUR_force_refresh="aurman -Syy"
        AUR_up="aurman -Su"
        AUR_up_y="aurman --noconfirm -Su"
        AUR_refresh_up="aurman -Syu"
        AUR_refresh_up_y="aurman --noconfirm -Syu"
        AUR_force_refresh_up="aurman -Syyuu"
        AUR_force_refresh_up_y="aurman --noconfirm -Syyuu"
        AUR_search="aurman -Ss"
        AUR_search_q="aurman -Ssq"
        AUR_search_ins="aurman -Qs"
        AUR_search_ins_q="aurman -Qsq"
        AUR_info="aurman -Si"
        AUR_rm="aurman -R"
        AUR_rm_y="aurman --noconfirm -R"
        AUR_rm_casc="aurman -Rc"
        AUR_rm_casc_y="aurman --noconfirm -Rc"
        AUR_rm_orph="aurman -Rs $(aurman -Qd --unrequired --quiet)"
        AUR_rm_orph_y="aurman --noconfirm -Rs $(aurman -Qd --unrequired --quiet)"
        AUR_rm_purge="aurman -Rns"
        AUR_rm_purge_y="aurman -Rns --noconfirm"
        AUR_rm_cache="aurman -Sc"
        AUR_rm_cache_y="aurman --noconfirm -Sc"
        AUR_rm_cache_full="aurman -Scc"
        AUR_rm_cache_full_y="aurman --noconfirm -Scc"
        AUR_ls_ins="aurman -Q"
        AUR_ls_orhpan="aurman -Qdtq" 
        AUR_ls_foreign="aurman -Qm"
        

    #
    # NON-PACMAN WRAPPERS 
    # 'SEARCH AND BUILD' - ers
    # NO SUPPORT YET - WIP

    # Aurutils
    #elif hash aur &>/dev/null; then
    #    AUR_pac="aur"
    #    AUR_up=""
    #    AUR_ins=""
    #    AUR_search="aur search"

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
    #elif type auracle &>/dev/null; then

    #    AUR_pac="auracle"
    #    AUR_up="auracle update"
    #    AUR_ins=""
    #    AUR_search="auracle search"

    else
        no_aur='TRUE'
    fi

    distro_base="Arch"
    
    if test -f /etc/manjaro-release; then
        distro="Manjaro"
    else 
        distro="Arch"
    fi

fi

if hash nala &>/dev/null && [[ "$pac" == 'apt' ]]; then
    pac="nala"
    pac_ins="sudo nala install"
    pac_ins="sudo nala install -y"
    pac_refresh="sudo nala update"
    pac_refresh_y="sudo nala update"
    pac_up="sudo nala upgrade --no-full"
    pac_up_y="sudo nala upgrade --no-full -y"
    pac_fullup="sudo nala upgrade"
    pac_fullup_y="sudo nala upgrade -y"
    pac_refresh_up="sudo nala update && sudo nala upgrade --no-full"
    pac_refresh_up_y="sudo nala update && sudo nala upgrade --no-full -y"
    pac_refresh_fullup="sudo nala update && sudo nala upgrade"
    pac_refresh_fullup_y="sudo nala update && sudo nala upgrade -y"
    pac_search="nala search"
    pac_info="nala show"  
    pac_info="nala show -a"  
    pac_rm="sudo nala remove"
    pac_rm_y="sudo nala remove -y"
    pac_rm_orph="sudo nala autopurge"
    pac_rm_orph_y="sudo nala autopurge -y"
    pac_rm_cache="sudo nala clean"
    pac_rm_cache_y="sudo nala clean -y"
    pac_ls="nala list"
    pac_ls_ins="nala list --installed"
    pac_ls_upg="nala list --upgradable"
fi

# TODO: Change this to uname -sm?
if [[ $machine == 'Linux' ]]; then
    arch_cmd="lscpu"
elif [[ $machine == 'Mac' ]]; then
    arch_cmd="sysctl -n machdep.cpu.brand_string"
fi

if eval "${arch_cmd} | grep -q 'Intel'"; then
    arch="386"
elif eval "${arch_cmd} | grep -q 'AMD'"; then
    if lscpu | grep -q "x86_64"; then
        arch="amd64"
    else
        arch="amd32"
    fi
elif eval "${arch_cmd} | grep -q 'armv'"; then
    arch="armv7l"
elif eval "${arch_cmd} | grep -q 'aarch'"; then
    arch="arm64"
fi

# VARS

if test -z "$XDG_CONFIG_HOME"; then
    if [[ "$machine" == 'Linux' ]]; then
        export XDG_CONFIG_HOME=$HOME/.config
    fi
fi

if test -z "$XDG_DATA_HOME"; then
    if [[ "$machine" == 'Linux' ]]; then
        export XDG_DATA_HOME=$HOME/.local/share
    fi
fi


if ! test -f ~/.profile; then
    touch ~/.profile
fi

if test -z $ENV; then
    if test -f ~/.environment; then
        export ENV=~/.environment  
    else
        export ENV=~/.profile
    fi
fi

if test -z $BASH_ENV; then 
    if test -f ~/.environment; then
        export BASH_ENV=~/.environment
    elif test -f ~/.bash_profile; then 
        export BASH_ENV=~/.bash_profile
    else
        export BASH_ENV=~/.profile
    fi
fi

if test -f ~/.zshenv; then
    export ZSH_ENV=~/.zshenv
elif test -f ~/.environment; then
    export ZSH_ENV=~/.environment
elif test -f ~/.zprofile; then
    export ZSH_ENV=~/.zprofile
fi

export BASH_ALIAS=~/.bashrc

if test -f ~/.bash_aliases; then
    export BASH_ALIAS=~/.bash_aliases
fi

if test -d ~/.bash_aliases.d/; then
    export BASH_ALIAS_FILEDIR=~/.bash_aliases.d
fi

export BASH_COMPLETION=~/.bashrc

if test -f ~/.bash_completion; then
    export BASH_COMPLETION=~/.bash_completion
fi

if test -d ~/.bash_completion.d/; then
    export BASH_COMPLETION_FILEDIR=~/.bash_completion.d
fi

export BASH_KEYBIND=~/.bashrc

if test -f ~/.keybinds; then
    export BASH_KEYBIND=~/.keybinds
fi

if test -d ~/.keybinds.d/; then
    export BASH_KEYBIND_FILEDIR=~/.keybinds.d
fi

#echo "These next $(tput setaf 1)sudo's$(tput sgr0) checks for the profile, environment, bash_alias, bash_completion and keybind files and dirs in '/root/' to generate global variables.";

export ENV_R=/root/.profile
export BASH_ENV_R=/root/.profile
export BASH_ALIAS_R=/root/.bashrc
export BASH_COMPLETION_R=/root/.bashrc
export BASH_KEYBIND_R=/root/.bashrc



if test -f /root/.environment; then
    export ENV_R=/root/.environment  
elif test -f /root/.profile; then
    export ENV_R=/root/.profile
fi

if test -f /root/.environment; then
    export BASH_ENV_R=/root/.environment
elif test -f /root/.bash_profile; then
    export BASH_ENV_R=/root/.bash_profile
else
    export BASH_ENV_R=/root/.profile
fi

if test -f /root/.zshenv; then
    export ZSH_ENV_R=/root/.zshenv
elif test -f /root/.environment; then
    export ZSH_ENV_R=/root/.environment
elif test -f /root/.zprofile; then
    export ZSH_ENV_R=/root/.zprofile
fi

if test -f /root/.bash_aliases; then
    export BASH_ALIAS_R=/root/.bash_aliases
fi

if test -d /root/.bash_aliases.d/; then
    export BASH_ALIAS_FILEDIR_R=/root/.bash_aliases.d
fi

if test -f /root/.bash_completion; then
    export BASH_COMPLETION_R=/root/.bash_completion
fi

if test -d /root/.bash_completion.d/; then
    export BASH_COMPLETION_FILEDIR_R=/root/.bash_completion.d
fi

if test -f /root/.keybinds; then
    export BASH_KEYBIND_R=/root/.keybinds
fi

if test -d /root/.keybinds.d/; then
    export BASH_KEYBIND_FILEDIR_R=/root/.keybindsd.d
fi
