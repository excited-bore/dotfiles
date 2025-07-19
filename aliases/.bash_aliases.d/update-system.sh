if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

if ! type reade &> /dev/null && test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

if ! type remove-kernels &> /dev/null && test -f ~/.bash_aliases.d/update-kernel.sh; then
    . ~/.bash_aliases.d/update-kernel.sh
fi 

if ! type remove-kernels &> /dev/null && test -f aliases/.bash_aliases.d/update-kernel.sh; then
    . ./aliases/.bash_aliases.d/update-kernel.sh
fi 

#if hash pamac &> /dev/null && grep -q '#EnableAUR' /etc/pamac.conf; then
#    if ! test -f checks/check_pamac.sh; then
#         source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh) 
#    else
#        . ./checks/check_pamac.sh
#    fi
#fi

function version-higher() {
    if [[ $1 == $2 ]]; then
        return 1
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    test -n "$BASH_VERSION" && local j=0 
    test -n "$ZSH_VERSION" && local j=1 
    for ((i = ${#ver1[@]}; i < ${#ver2[@]}; i++)); do
        ver1[i]=$j
    done
    for ((i = $j; i < ${#ver1[@]}; i++)); do
        if ((10#${ver1[i]:=$j} > 10#${ver2[i]:=$j})); then
            return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 1
        fi
    done
    return 0
}

# https://www.explainxkcd.com/wiki/index.php/1654:_Universal_Install_Script

function update-system() {
    local SCRIPT_DIR=$(get-script-dir) 
    local YES flag NOGUI KERNEL='lts' SKIPKERNEL='n' 
    while [[ $# -gt 0 ]]; do
        case $1 in
        -h|-\?|--help)  
        printf "System updater using *most* known packagemanagers.\n
    Includes: 
    ${CYAN}Windows${cyan}
        - winget 
    ${WHITE1}MacOs${white}
        - softwareupdate
        - (home)brew
    ${GREEN}Linux${green}
        - apt 
        - nala
        - pacman 
            ${GREEN1}AUR-helpers${green1}
            - yay
            - pamac
            - pikaur 
            - pacaur 
            - aura 
            - aurman 
            - auracle
            - pakku
            - paru
            - trizen 
        - dnf
        - yum
        - nix profile + nix-env
        - zypper 
        - apk
    ${MAGENTA}Variety${magenta}
        - flatpak
        - snap
    It will also suggest:
        - To install brew if on MacOs and not installed
        - To autoremove unnecessary packages if using an apt-based system
        - To activate automatic timesync for timedatectl if it is not set
        - The right linux kernel headers if they aren't installed yet
        (for now only supported for apt and pacman)
        - Refresh gpg keys if gpg is installed
        - Update using (some) language packagemanagers:
          Supports
          - npm
          - pipx
          - cargo
          - gem

    -h / --help  

            Show this help message and exit
                
    -y / --yes [ skipkernelcheck ${bold}1(default)${normal}/0 ] 
               
            Auto update without prompting. 
            Optional : Skip newer kernel check if 1

    -k / --kernel [ ${bold}lts(default)${normal}/stable/mainline ]   
                           
            Looks for the latest lts (long term support) tagged kernel version. 
            Optional: Set tag specifically for the newest stable or mainline tagged version 

    -s / --skip-gui : 
             
             Skip asking to updating if it requires a GUI prompt (f.ex. snap)\n"
            
                exit 0 
                ;;
            -y|--yes)
                YES="-y"
                SKIPKERNEL='y' 
                if [[ "$2" == '0' ]] || [[ "$2" == '1' ]]; then 
                    [[ "$2" == '0' ]] && SKIPKERNEL='n' 
                    shift 2 
                else
                    shift 
                fi
                ;;
	    -s|--skip-gui)
	        NOGUI='y'
	        shift
	        ;;
            -k|--kernel)
                if ! ([[ "$2" =~ -* ]] || [[ "$2" =~ --* ]]); then
                    KERNEL="$2"
                    shift 2
                else
                    KERNEL='lts'
                    shift
                fi
                ;;
            -*|--*)
                echo "Unknown option '$1'"
                exit 1
                ;;
            *)
                break
                ;;
          esac
        done
    
    local hdrs

    if type timedatectl &> /dev/null && ! [[ "$(timedatectl show | grep '^NTP' | head -n 1 | awk 'BEGIN { FS = "=" } ; {print $2}')" == "yes" ]]; then 
        readyn -p "Timedate NTP not set (Automatic timesync). This can cause issues with syncing to repositories. Activate it?" set_ntp
        if [[ "$set_ntp" == "y" ]]; then
            sudo timedatectl set-ntp true
            timedatectl status
        fi
    fi

    if [[ $machine == 'Mac' ]] && ! hash brew &> /dev/null; then
        printf "${GREEN}Homebrew is a commandline package manager (like the Appstore) that works as an opensource alternative to the Appstore\nGui applications are available for it as well\n${normal}"
        readyn -y 'CYAN' -p 'Install brew?' brew
        if [[ $brew == 'y' ]]; then
            if ! test -f install_brew.sh; then
                 source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_brew.sh)
            else
                . ./install_brew.sh
            fi
        fi
        if ! hash wget &> /dev/null; then
            readyn -p "Wget is a commandline tool that's used to download files from the internet and is used throughout these scripts. Install?" wget_brw
            if [[ $wget_brw == 'y' ]]; then
                brew install wget 
            fi
        fi
    elif [[ $machine == 'Windows' ]] && [[ $win_bash_shell == 'Git' ]] && ! test -d "/c/cygwin$ARCH_WIN" && ! test -d '/c/git-sdk-32' && ! type wsl &> /dev/null; then
        printf "${GREEN}Git bash is an environment without a package manager.\n\t - Cygwin is a collection of UNIX related tools (with a pm if you install 'apt-cyg')\n\t- Git SDK for windows comes with pacman (arch package manager)\n${normal}"
        reade -Q 'CYAN' -i 'wsl sdk cyg n' -p 'Install WSL, git SDK, Cygwin? [Wsl/sdk/cyg/n]: ' cyg
        if [[ "$cyg" == 'cyg' ]]; then
            if ! test -f install_cygwin.sh; then
                 source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cygwin.sh) 
            else
                . ./install_cygwin.sh
            fi
            printf "${CYAN}Don't forget to open up Cygwin terminal and restart this script (cd /cygdrive/c to go to C:/ drive and navigate to dotfiles repo)${normal}\n"
        elif [[ $cyg == 'sdk' ]]; then
            if ! test -f install_git_sdk.sh; then
                 source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_git_sdk.sh) 
            else
                . ./install_git_sdk.sh
            fi
            printf "${CYAN}Don't forget to open up Git SDK and restart this script${normal}\n"
        else
            printf "${RED}Can't install script on git bash alone. Exiting..${normal}\n"
            exit 1
        fi
    fi


    #echo "This next $(tput setaf 1)sudo$(tput sgr0) will try to update the packages for your system using the package managers it knows";

    if [[ $machine == 'Mac' ]]; then
        
        echo "This next $(tput setaf 1)sudo$(tput sgr0) will try to update the packages for your system using the package managers it knows";
       
        pac=softwareupdate
        
        sudo softwareupdate -i -a
       
        if hash brew &> /dev/null; then
            pac=brew       
            if hash yes &> /dev/null && test -n "$YES" ;then
                yes | brew update  
                yes | brew upgrade 
            else
                brew update 
                brew upgrade
            fi
        fi
    
    elif [[ "$pac" == "apt" ]] || [[ "$pac" == "nala" ]]; then
       
        test -n "$YES" && flag='--auto' || flag=''

        if test -n "$YES"; then
            if test -n "$pac_refresh_y"; then
                eval "${pac_refresh_y}"
            else
                eval "yes | ${pac_refresh}"
            fi
        else
            eval "${pac_refresh}"
        fi
        
        if ! [[ "$SKIPKERNEL" == 'y' ]] && hash curl &> /dev/null && hash mainline &> /dev/null && hash xmllint &> /dev/null; then
            local latest_lts prmpt
            if [[ "$KERNEL" == 'lts' ]] || [[ "$KERNEL" == 'stable' ]] || [[ "$KERNEL" == 'mainline' ]]; then
                prmpt="Latest $KERNEL linux kernel"
                [[ "$KERNEL" == 'lts' ]] && prmpt='Latest longterm support linux kernel'
                latest_lts="$(curl -fsSL https://www.kernel.org | xmllint --html --xpath "(//td[text()='$KERNEL:'])[1]/following-sibling::td[1]/strong/text()" - 2> /dev/null)"
            else 
                latest_lts="$KERNEL"
                prmpt="Kernel version $KERNEL"
            fi
            #local latest_lts1="linux-image-$latest_lts"

            if ! [[ "$(uname -r)" == "$latest_lts" ]] && ( [[ $latest_lts == $KERNEL ]] || version-higher $latest_lts $(uname -r) ); then

                test -n "$YES" && flag='--auto' || flag=''

                readyn $flag -p "$prmpt not installed. Install ${CYAN}$latest_lts${GREEN} (and ${CYAN}$latest_lts-headers${GREEN})?" latest_ins
                if [[ $latest_ins == 'y' ]]; then
                    mainline install $latest_lts
                fi
                unset latest_ins
            fi
        fi

        hdrs="linux-headers-$(uname -r)"
        if test -z "$(apt list --installed 2> /dev/null | grep $hdrs)"; then
            
            test -n "$YES" && flag='--auto' || flag=''
            
            readyn $flag -p "Right linux headers not installed. Install $hdrs?" hdrs_ins
            if [[ "$hdrs_ins" == "y" ]]; then
                eval "${pac_ins} $hdrs"
            fi
        fi

        apt list --upgradable 
       
        if test -z "$APT_UPGRADE_YN"; then
            local full_partial 
            printf "${CYAN}${pac}${normal} can either update using:
 - ${CYAN}${pac_up}${normal} upgrades packages that don't need to remove previously installed versions before installing a new version, to be on the safer side
 - ${CYAN}${pac_fullup}${nornal} upgrades all packages, independent of needing to remove packages beforehand or not\n"
            reade -Q 'GREEN' -i 'full partial' -p "How do you prefer upgrading? [Full/partial]" full_partial
            if [[ "$full_partial" == 'full' ]]; then
                export APT_FULLUPGRADE_YN='y'
            elif [[ "$full_partial" == 'partial' ]]; then
                export APT_FULLUPGRADE_YN='n'
            fi
            printf "If you don't want to this prompt to come up again, put ${CYAN}'export APT_UPGRADE_YN=\"y\"' or \"n\" in a ${GREEN}$HOME/.environment${normal} or ${GREEN}$HOME/.profile${normal} or in whatever file that gets sourced before ${GREEN}update-system.sh${normal}.\n"
         
        fi
      
        if test -n "$APT_UPGRADE_YN"; then 

            if [[ "$APT_UPGRADE_YN" == 'y' ]]; then
                pac_upg="$pac_fullup" 
                pac_upg_y="$pac_fullup_y" 
            elif [[ "$APT_UPGRADE_YN" == 'n' ]]; then
                pac_upg="$pac_up" 
                pac_upg_y="$pac_up_y" 
            fi  

            local upgrd 

            echo "This next $(tput setaf 1)sudo$(tput sgr0) will try to update the packages for your system using the package managers it knows";
             
            readyn $flag -p "Upgrade system using $pac_upg?" upgrd

            if [[ $upgrd == 'y' ]];then
                if test -n "$YES"; then 
                    if test -n "$pac_upg_y"; then
                        eval "${pac_upg_y}"
                    else
                        eval "yes | ${pac_upg}"
                    fi
                    
                else            
                    eval "${pac_upg}" 
                fi
                
                if test -n "$YES"; then
                    if test -n "$pac_refresh_y"; then
                        eval "${pac_refresh_y}"
                    else
                        eval "yes | ${pac_refresh}"
                    fi
                else
                    eval "${pac_refresh}"
                fi
                
            fi
        fi
 
        if apt --dry-run autoremove 2> /dev/null | grep -qPo '^Remv \K[^ ]+'; then
           
            local remove

            readyn $flag -p 'Autoremove orphaned/unnecessary packages (unused dependencies)?' remove
       
            if [[ "$remove" == 'y' ]]; then
                if test -n "$YES"; then
                    if test -n "$pac_rm_orph_y"; then
                        eval "${pac_rm_orph_y}"
                    else
                        eval "yes | ${pac_rm_orph}" 
                    fi
                else
                    eval "${pac_rm_orph}" 
                fi
            fi
        fi
    
    elif [[ "$pac" == "apk" ]]; then
       
        apk update

    elif [[ "$pac" == "pacman" ]]; then
   
        if test -f /var/lib/pacman/db.lck; then
            local rm_dblck 
            printf "${yellow}There's a lockfile ${ORANGE}/var/lib/pacman/db.lck${normal}\n" 
            printf "${yellow}If there's no other instance of pacman running, ${YELLOW}the file needs to be removed before continuing${normal}\n" 
            printf "${yellow}Otherwise update-system will quit${normal}\n" 
            readyn -p "Remove ${YELLOW}/var/lib/pacman/db.lck${GREEN}?" rm_dblck
            if [[ "$rm_dblck" == 'y' ]]; then
                sudo command rm /var/lib/pacman/db.lck 
            else
                exit 1
            fi
        fi
        
        if test -n "$YES"; then 
            sudo pacman -Su --noconfirm
        else 
            sudo pacman -Su
        fi
       
        if test -z "$AUR_up" || test -z "$AUR_search" || test -z "$AUR_info"; then
            local nstll_AUR pick_aur
            printf "${YELLOW}No appropriate cli based AUR helper found!\n${normal}" 
            printf "${CYAN}It's best to have a cli-based pacman wrapper/AUR helper installed for updating/managing AUR-based packages\n${normal}" 
            readyn -p "Install a pacman wrapper/AUR helper?" nstll_AUR
            if [[ "$nstll_AUR" == 'y' ]]; then
                reade -Q 'GREEN' -i 'yay pacaur pikaur aura paru pakku trizen pamac' -p "Which one? [Yay/pacaur/pikaur/aura/paru/pakku/trizen/pamac]: " pick_aur
                if [[ "$pick_aur" == 'yay' ]]; then
                    if ! test -f $SCRIPT_DIR/../../AUR_installers/install_yay.sh; then
                        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_yay.sh) 
                    else
                        source $SCRIPT_DIR/../../AUR_installers/install_yay.sh 
                    fi
                elif [[ "$pick_aur" == 'pacaur' ]]; then
                    if ! test -f $SCRIPT_DIR/../../AUR_installers/install_pacaur.sh; then
                        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_pacaur.sh) 
                    else
                        source $SCRIPT_DIR/../../AUR_installers/install_pacaur.sh 
                    fi
                elif [[ "$pick_aur" == 'pikaur' ]]; then
                    if ! test -f $SCRIPT_DIR/../../AUR_installers/install_pikaur.sh; then
                        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_pikaur.sh) 
                    else
                        source $SCRIPT_DIR/../../AUR_installers/install_pikaur.sh 
                    fi
                elif [[ "$pick_aur" == 'aura' ]]; then
                    if ! test -f $SCRIPT_DIR/../../AUR_installers/install_aura.sh; then
                        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_aura.sh) 
                    else
                        source $SCRIPT_DIR/../../AUR_installers/install_aura.sh 
                    fi
                elif [[ "$pick_aur" == 'paru' ]]; then
                    if ! test -f $SCRIPT_DIR/../../AUR_installers/install_paru.sh; then
                        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_paru.sh) 
                    else
                        source $SCRIPT_DIR/../../AUR_installers/install_paru.sh 
                    fi
                elif [[ "$pick_aur" == 'pakku' ]]; then
                    if ! test -f $SCRIPT_DIR/../../AUR_installers/install_pakku.sh; then
                        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_pakku.sh) 
                    else
                        source $SCRIPT_DIR/../../AUR_installers/install_pakku.sh 
                    fi
                elif [[ "$pick_aur" == 'trizen' ]]; then
                    if ! test -f $SCRIPT_DIR/../../AUR_installers/install_trizen.sh; then
                        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_trizen.sh) 
                    else
                        source $SCRIPT_DIR/../../AUR_installers/install_trizen.sh 
                    fi
                elif [[ "$pick_aur" == 'pamac' ]]; then
                    if ! test -f $SCRIPT_DIR/../../AUR_installers/install_pamac.sh; then
                        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_pamac.sh) 
                    else
                        source $SCRIPT_DIR/../../AUR_installers/install_pamac.sh 
                    fi
                    
                fi
                if test -n "$pick_aur"; then
                   if ! test -f $SCRIPT_DIR/../../checks/check_system.sh; then
                        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh) 
                    else
                        source $SCRIPT_DIR/../../checks/check_system.sh 
                    fi  
                fi
            fi
        fi
        
        if [[ "$AUR" == 'pamac' ]] && (! test -f /etc/pamac.conf || ! grep -q '^EnableAUR' /etc/pamac.conf); then
            if ! test -f /etc/pamac.conf; then
                printf "${GREEN}Adding /etc/pamac.conf to enable the AUR for pamac\n${normal}"
                sudo touch /etc/pamac.conf
                printf '## Allow Pamac to search and install packages from AUR:\nEnableAUR\n' | sudo tee -a /etc/pamac.conf
            else
                printf "${GREEN}Adding 'EnableAUR' to /etc/pamac.conf to enable the AUR for pamac\n${normal}"
                if grep -q 'EnableAUR' /etc/pamac.conf; then
                    sudo sed -i 's/#EnableAUR/EnableAUR/g' /etc/pamac.conf
                else 
                    printf '## Allow Pamac to search and install packages from AUR:\nEnableAUR\n' | sudo tee -a /etc/pamac.conf
                fi
            fi
        fi

        if test -n "$AUR_up"; then
            
            if test -n "$YES"; then 
                
                if [[ "$AUR_pac" == "pamac" ]]; then
                    pamac checkupdates  
                    pamac update --no-confirm
                elif test -n "$AUR_up_y"; then
                    eval "$AUR_up_y"
                else
                    eval "yes | $AUR_up"
                fi
            
            else 
                [[ "$AUR_pac" == "pamac" ]] &&
                    pamac checkupdates  
                eval "$AUR_up"
            fi
        fi 
      
        if ! [[ "$SKIPKERNEL" == 'y' ]] && hash curl &> /dev/null && hash xmllint &> /dev/null; then 
            if [[ "$KERNEL" == 'lts' ]] || [[ "$KERNEL" == 'stable' ]] || [[ "$KERNEL" == 'mainline' ]]; then
                local latest_lts latest_lts1 latest_stbl latest_stbl1 latest_main latest_main1 lt_header prmpt lts_ver

                #latest_lts="$(curl -fsSL https://www.kernel.org/feeds/kdist.xml | xmllint --xpath '//title[contains(., "longterm")][1]/text()' - | awk 'NR==1{print $1;}' | cut -d: -f-1)"
                # Manjaro tends to be behind, so we only keep for the 'main' version number. Linux6.12 instead of Linux6.12.34 for example.. 
                test -n "$YES" && flag='--auto' || flag=''
                
                if [[ "$distro" == 'Manjaro' ]]; then
                    
                    latest_lts="$(curl -fsSL https://www.kernel.org | xmllint --html --xpath "(//td[text()='longterm:'])[1]/following-sibling::td[1]/strong/text()" - 2> /dev/null)"
                    latest_lts1=$(echo $latest_lts | cut -d. -f-2)  
                    latest_lts1="linux${latest_lts1//"."}" 
                    
                    latest_stbl="$(curl -fsSL https://www.kernel.org | xmllint --html --xpath "(//td[text()='stable:'])[1]/following-sibling::td[1]/strong/text()" - 2> /dev/null)"
                    latest_stbl1=$(echo $latest_stbl | cut -d. -f-2)  
                    latest_stbl1="linux${latest_stbl//"."}" 
                    
                    latest_main="$(curl -fsSL https://www.kernel.org | xmllint --html --xpath "(//td[text()='mainline:'])[1]/following-sibling::td[1]/strong/text()" - 2> /dev/null)"
                    latest_main1=$(echo $latest_main | cut -d. -f-2)
                    latest_main1="linux${latest_main1//"."}" 
                  

                    if [[ "$KERNEL" == 'lts' ]] && test -z "$(pamac list --quiet --installed '^linux-lts-meta$')" && test -z "$(pamac list --quiet --installed "^$latest_lts$")" && test -z "$(pamac list --quiet --installed "^linux-lts-versioned-bin$")"; then
                       
                        printf "${GREEN}%s ${CYAN}%s\n" "Latest longterm support version:" "$latest_lts" 

                        pamac search '^linux-lts-meta$' 
                        pamac search "^$latest_lts1$" 

                        if test -n "$AUR_pac"; then 
                            
                            pamac search '^linux-lts-versioned-bin$' 
                            
                            reade $flag -Q 'GREEN' -p "Manjaro doesn't have great support for the latest longterm kernel.\nThe 'linux-lts-meta' package tends to be out of date .\nChoosing between manjaro's versioned kernels - linux612, linux614, etc. - for the one that is closest to the 'longterm' kernel's full version is an alternative (however this can also be a few minor versions behind)\nSince AUR support is enabled, there's the option for 'linux-lts-versioned-bin' which is by all means actually 'up-to-date'\nWhich is preferred? [Versionlts/aurlts/metalts]: " -i 'versionlts aurlts metalts' lts_ver
                        else
                            reade $flag -Q 'GREEN' -p "Manjaro doesn't have great support for the latest longterm kernel.\nThe 'linux-lts-meta' package tends to be out of date .\nChoosing between manjaro's versioned kernels - linux612, linux614, etc. - for the one that is closest to the 'longterm' kernel's full version is an alternative (however this can also be a few minor versions behind)\nWhich is preferred? [Versionlts/metalts]: " -i 'versionlts metalts' lts_ver
                        fi
                        
                        if [[ $lts_ver == 'aurlts' ]]; then
                            readyn $flag -p "Also install headers?" lt_header
                            if [[ $lt_header == 'y' ]]; then
                                pamac install --no-confirm linux-lts-versioned-bin linux-lts-versioned-headers-bin       
                            else 
                                pamac install --no-confirm linux-lts-versioned-bin 
                            fi
                        elif [[ $lts_ver == 'versionlts' ]]; then
                            readyn $flag -p "Also install headers?" lt_header
                            if [[ $lt_header == 'y' ]]; then
                                pamac install --no-confirm "$latest_lts1 $latest_lts1-headers"       
                            else
                                pamac install --no-confirm $latest_lts1      
                            fi
                        elif [[ $lts_ver == 'metalts' ]]; then
                            readyn $flag -p "Also install headers?" lt_header
                            if [[ $lt_header == 'y' ]]; then
                                pamac install --no-confirm linux-lts-meta linux-lts-headers-meta       
                            else
                                pamac install --no-confirm linux-lts-meta      
                            fi
                        fi

                    elif [[ "$KERNEL" == 'stable' ]] && test -z "$(pamac list --quiet --installed '^linux-meta$')" && test -z "$(pamac list --quiet --installed "^$latest_stbl$")"; then
                        printf "${GREEN}%s ${CYAN}%s\n" "Latest stable version:" "$latest_stbl" 

                        pamac search '^linux-meta$' 
                        pamac search "^$latest_stbl1$" 

                        reade $flag -Q 'GREEN' -p "Which is preferred? [Meta/version]: " -i 'meta version' lts_ver
                        if [[ "$lts_ver" == 'meta' ]]; then
                            readyn $flag -p "Also install headers?" lt_header
                            if [[ $lt_header == 'y' ]]; then
                                pamac install --no-confirm linux-meta linux-headers-meta       
                            else
                                pamac install --no-confirm linux-meta      
                            fi
                             
                        elif [[ "$lts_ver" == 'version' ]]; then
                            readyn $flag -p "Also install headers?" lt_header
                            if [[ $lt_header == 'y' ]]; then
                                pamac install --no-confirm "$latest_stbl1 $latest_stbl1-headers"       
                            else
                                pamac install --no-confirm $latest_stbl1     
                            fi
                        
                        fi
                    
                    elif [[ "$KERNEL" == 'mainline' ]] && test -z "$(pamac list --quiet --installed '^linux-mainline$')" && test -z "$(pamac list --quiet --installed "^$latest_main$")"; then
                        printf "${GREEN}%s ${CYAN}%s\n" "Latest mainline version:" "$latest_main" 
                       
                        pamac search "^$latest_main1$" 

                        if test -n "$AUR_pac"; then
                            pamac search "^linux-mainline$" 
                            reade $flag -Q 'GREEN' -p "Which is preferred? [Version/mainline]: " -i 'version mainline' lts_ver
                        else 
                            readyn $flag -p "Install $latest_main1?" lts_ver 
                        fi
                        
                        if [[ "$lts_ver" == 'version' ]] || [[ "$lts_ver" == 'y' ]]; then
                            readyn $flag -p "Also install headers?" lt_header
                            if [[ $lt_header == 'y' ]]; then
                                pamac install --no-confirm "$latest_main1 $latest_main1-headers" 
                            else 
                                pamac install --no-confirm "$latest_main1" 
                            fi
                        elif [[ "$lts_ver" == 'mainline' ]]; then
                            readyn $flag -p "Also install headers?" lt_header
                            if [[ $lt_header == 'y' ]]; then
                                pamac install --no-confirm "linux-mainline linux-mainline-headers" 
                            else 
                                pamac install --no-confirm "linux-mainline" 
                            fi
                        fi
                    fi
                    
                    # https://www.kernel.org/feeds/kdist.xml 
                elif [[ "$distro" == 'Arch' ]]; then
                    if [[ "$KERNEL" == 'lts' ]]; then
                         
                        pamac search '^linux-lts$' 
                        
                        readyn -p 'Also install headers?' lt_header
                        if [[ "$lt_header" ]]; then
                            sudo pacman -Su linux-lts linux-lts-headers 
                        else 
                            sudo pacman -Su linux-lts 
                        fi
                    elif [[ "$KERNEL" == 'stable' ]]; then
                        
                        pamac search '^linux$' 
                       
                        readyn -p 'Also install headers?' lt_header
                        if [[ "$lt_header" ]]; then
                            sudo pacman -Su linux linux-headers 
                        else 
                            sudo pacman -Su linux 
                        fi
                    elif [[ "$KERNEL" == 'mainline' ]]; then
                        if test -z "$AUR_pac"; then
                            printf "${YELLOW}Can't proceed: mainline linux kernel only available through AUR${normal}\n" 
                        else 
                            
                            eval "$AUR_search '^linux-mainline$'"

                            readyn -p 'Also install headers?' lt_header
                            if [[ "$lt_header" ]]; then
                                eval "$AUR_ins linux-mainline linux-mainline-headers" 
                            else 
                                eval "$AUR_ins linux-mainline" 
                            fi
                        fi
                    fi
                fi
            fi
        fi

        local hdrs_ins
        
        test -n "$YES" && flag='--auto' || flag=''
        
        if [[ "$distro" == 'Manjaro' ]]; then
            hdrs="$(echo $(uname -r) | cut -d. -f-2)"
            hdrs="linux${hdrs//"."}-headers"
        fi
       
        if test -n "$hdrs" && test -z "$(pacman -Q $hdrs 2> /dev/null)"; then
            
            readyn $flag -p "Right linux headers not installed. Install $hdrs?" hdrs_ins
            
            if [[ "$hdrs_ins" == "y" ]]; then

                if test -n "$YES"; then 
                    eval "${pac_ins_y} $flag $hdrs"
                else 
                    eval "${pac_ins} $flag $hdrs"
                fi
            fi
        fi
       
       
        local cachcln 
       
        if test -n "$(pacman -Qdtq)"; then 
            readyn $flag -p "Clean / autoremove orphan packages - dependencies that aren't used by any package?" cachcln
            
            if [[ "$cachcln" == 'y' ]]; then
                
                if [ -n "$AUR_ls_orphan" ] && test -n "$(eval "$AUR_ls_orphan")"; then
                    
                    if test -n "$YES"; then 
                        if test -n "$AUR_rm_orph_y"; then
                            eval "$AUR_rm_orph_y"
                        elif test -n "$AUR_rm_orph"; then
                            eval "yes | $AUR_rm_orph"
                        fi
                    else
                        eval "$AUR_rm_orph"
                    fi
               
                elif test -n "$pac_ls_orhpan" && test -n "$(eval "$pac_ls_orhpan")"; then
                    if test -n "$YES"; then 
                        eval "$pac_rm_orph_y" 
                    else
                        eval "$pac_rm_orph"
                    fi
                fi
            fi
        fi


        if [[ "$(ls /boot/vmlinuz* | wc -w)" -gt 1 ]]; then
            local rm_unused_krn
            readyn $flag -p "Multiple installed kernels detected. Remove unused ones?" rm_unused_krn
            if [[ "$rm_unused_krn" == 'y' ]]; then
                remove-kernels $flag --clean 
            fi
        fi

    elif [[ "$distro" == "Gentoo" ]]; then
        #TODO Add update cycle for Gentoo systems
        continue
    
    elif [[ "$pac" == "zypper_leap" ]]; then
    # https://en.opensuse.org/System_Updates
        echo "This next $(tput setaf 1)sudo$(tput sgr0) will try to update the packages for your system using the package managers it knows";
        if ! test -z "$YES"; then 
            yes | sudo zypper up
        else
            sudo zypper up
        fi

    elif [[ "$pac" == "zypper_tumble" ]]; then
        echo "This next $(tput setaf 1)sudo$(tput sgr0) will try to update the packages for your system using the package managers it knows";
        if test -n "$YES"; then 
            yes | sudo zypper dup
        else
            sudo zypper dup
        fi

    elif [[ "$pac" == "yum" ]]; then
        if test -n "$YES"; then 
            yes | yum update
        else
            yum update
        fi 
    fi
    
    unset hdrs hdrs_ins 

    if type flatpak &> /dev/null; then
	if test -n "$YES"; then 
            flatpak update -y
        else
            flatpak update
        fi
    fi


    if test -z "$NOGUI" && type snap &> /dev/null; then
	readyn --auto -p "Update (refresh) snap packages?" snaprfrsh
	if [[ "$snaprfrsh" == 'y' ]]; then 
            snap refresh
        fi
    fi

    if test -n "$YES"; then
        YES="--auto" 
    fi

    if hash nix-env &> /dev/null; then
        readyn $YES --no -p "${normal}Update ${CYAN}nix packages?${normal} ${MAGENTA}(Fetching updated list could take a long time)${YELLOW}" nix_up
        if [[ "$nix_up" == 'y' ]]; then
            printf "Updating all ${MAGENTA}nix packages${normal} using 'nix-env -u *'\n" && nix-env -u * 2> /dev/null
        fi 
        unset nix_up 
    fi
     

    if hash gpg &> /dev/null || hash gpg2 &> /dev/null; then
        if hash gpg2 &> /dev/null; then
            up_gpg=gpg2
        else
            up_gpg=gpg
        fi

        readyn $YES --no -p "${normal}Refresh ${CYAN}gpg keys?${normal} ${MAGENTA}(Keyservers can be unstable so this might take a while)${YELLOW}" gpg_up
        if [[ "$gpg_up" == 'y' ]]; then
            eval "${up_gpg} --refresh-keys"  
        fi
    fi
    unset up_gpg gpg_up

    if type pipx &> /dev/null || type npm &> /dev/null || type gem &> /dev/null || type cargo &> /dev/null; then 
        readyn $YES --no -p "${normal}Update ${CYAN}packages for development package-managers - pipx, npm, gem, cargo...${normal} ${MAGENTA}(WARNING: this could take a lot longer relative to regular pm's)${YELLOW}" "y" dev_up
        if [[ "$dev_up" == "y" ]]; then
            
            if type pipx &> /dev/null; then
                readyn -Y "MAGENTA" -p "Update pipx? (Python standalone packages)" pipx_up
                if [[ "$pipx_up" == "y" ]]; then
                    pipx upgrade-all
                fi
            fi
            unset pipx_up

            if type npm &> /dev/null; then
                #reade -Q "magenta" -i "y" -p "Update local npm packages? (Javascript) [Y/n]: " "n" npm_up
                #if [[ "$npm_up" == "y" ]]; then
                #    npm update
                #fi
                #unset npm_up

                readyn -Y "magenta" -p "${normal}Update ${red}${bold}global${normal}${magenta1} npm packages? (Javascript)" npm_up
                if [[ "$npm_up" == "y" ]]; then
                    echo "This next $(tput setaf 1)sudo$(tput sgr0) will update using 'sudo npm -g update'";
                    sudo npm -g update
                    sudo npm -g upgrade
                fi
                unset npm_up
            fi
            
            if type cargo &> /dev/null; then
                readyn -Y "magenta" -p "Update cargo (rust)?"  cargo_up
                if [[ "$cargo_up" == "y" ]]; then
                    if test -z "$(cargo --list | grep 'install-update')"; then
                        readyn -Y "MAGENTA" -p "To update cargo packages, 'cargo-update' needs to be installed first. Install?" carg_ins
                        if [[ "$carg_ins" == "y" ]]; then
                            cargo install cargo-update
                        fi
                        unset cargo_ins
                    fi
                fi
                if ! test -z "$(cargo --list | grep 'install-update')"; then
                    cargo install-update -a
                fi
                unset cargo_up
            fi

            if type gem &> /dev/null; then
                readyn -Y "magenta" -p "Update local gems? (Ruby-on-rails)" gem_up
                if [[ "$gem_up" == "y" ]]; then
                    gem update 
                fi
                unset gem_up
            fi
        fi
        unset dev_up
        
    fi
    export SYSTEM_UPDATED="TRUE" 
}

alias update-system-yes="update-system -y -s"
