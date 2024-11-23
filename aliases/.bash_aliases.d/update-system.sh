if ! type reade &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
    else
        . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
    fi
fi

if test -z "$distro"; then 
    if ! test -f checks/check_system.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
    else
        . ./checks/check_system.sh
    fi
fi

if type pamac &> /dev/null && grep -q '#EnableAUR' /etc/pamac.conf; then
    if ! test -f checks/clheck_pamac.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)" 
    else
        . ./checks/check_pamac.sh
    fi
fi

# https://www.explainxkcd.com/wiki/index.php/1654:_Universal_Install_Script
function update-system() {
    unset YES 
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
          - gem\n\n
    -h / --help : Show this help message and exit\n"
            exit
            ;;
            -y|--yes)
              YES="yes | "
              shift # past value
              ;;
            -*|--*)
              echo "Unknown option $1"
              exit 1
              ;;
            *)
              break
              ;;
          esac
        done
         
    if type timedatectl &> /dev/null && ! test "$(timedatectl show | grep ^NTP | head -n 1 | awk 'BEGIN { FS = "=" } ; {print $2}')" == "yes"; then 
        reade -Q "GREEN" -i "y" -p "Timedate NTP not set (Automatic timesync). This can cause issues with syncing to repositories. Activate it? [Y/n]: " "n" set_ntp
        if [ "$set_ntp" == "y" ]; then
            timedatectl set-ntp true
            timedatectl status
        fi
    fi

    if test $machine == 'Mac' && ! type brew &> /dev/null; then
        printf "${GREEN}Homebrew is a commandline package manager (like the Appstore) that works as an opensource alternative to the Appstore\nGui applications are available for it as well\n${normal}"
        reade -Q 'CYAN' -i 'y' -p 'Install brew? [Y/n]: ' 'n' brew
        if test $brew == 'y'; then
            if ! test -f install_brew.sh; then
                 eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_brew.sh)" 
            else
                ./install_brew.sh
            fi
        fi
    elif test $machine == 'Windows' && test $win_bash_shell == 'Git' && ! test -d "/c/cygwin$ARCH_WIN" && ! test -d '/c/git-sdk-32' && ! type wsl &> /dev/null; then
        printf "${GREEN}Git bash is an environment without a package manager.\n\t - Cygwin is a collection of UNIX related tools (with a pm if you install 'apt-cyg')\n\t- Git SDK for windows comes with pacman (arch package manager)\n${normal}"
        reade -Q 'CYAN' -i 'wsl' -p 'Install WSL, git SDK, Cygwin? [Wsl/sdk/cyg/n]: ' 'sdk cyg n' cyg
        if test $cyg == 'cyg'; then
            if ! test -f install_cygwin.sh; then
                 eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cygwin.sh)" 
            else
                ./install_cygwin.sh
            fi
            printf "${CYAN}Don't forget to open up Cygwin terminal and restart this script (cd /cygdrive/c to go to C:/ drive and navigate to dotfiles repo)${normal}\n"
        elif test $cyg == 'sdk'; then
            if ! test -f install_git_sdk.sh; then
                 eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_git_sdk.sh)" 
            else
                ./install_git_sdk.sh
            fi
            printf "${CYAN}Don't forget to open up Git SDK and restart this script${normal}\n"
        else
            printf "${RED}Can't install script on git bash alone. Exiting..${normal}\n"
            exit 1
        fi
    fi


    echo "This next $(tput setaf 1)sudo$(tput sgr0) will try to update the packages for your system using the package managers it knows";

    if test $machine == 'Mac'; then
        pac=softwareupdate
        sudo softwareupdate -i -a
        if type brew &> /dev/null; then
            pac=brew       
            if type yes &> /dev/null && ! test -z "$YES" ;then
                yes | brew update  
                yes | brew upgrade 
            else
                brew update 
                brew upgrade
            fi
        fi
    elif test "$pac" == "apt" && test "$pac" == "nala"; then
        if ! test -z "$YES"; then
            eval "$pac_up -y"
        else
            eval "$pac_up"
        fi
        hdrs="linux-headers-$(uname -r)"
        if test -z "$(apt list --installed 2> /dev/null | grep $hdrs)"; then
            reade -Q "GREEN" -i "y" -p "Right linux headers not installed. Install $hdrs? [Y/n]: " "n" hdrs_ins
            if [ "$hdrs_ins" == "y" ]; then
                eval "$pac_ins $hdrs"
            fi
        fi
        if ! test -z "$YES"; then 
            sudo "$pac" upgrade -y
        else 
            sudo "$pac" upgrade 
        fi
        if apt --dry-run autoremove 2> /dev/null | grep -Po '^Remv \K[^ ]+'; then
            reade -Q 'GREEN' -i 'y' -p 'Autoremove unneccesary packages? [Y/n]: '  'n' remove
            if test $remove == 'y'; then
                if ! test -z "$YES"; then 
                    sudo "$pac" autoremove -y
                else
                    sudo "$pac" autoremove 
                fi
            fi
        fi
    elif test "$pac" == "apk"; then
        apk update
    elif test "$pac" == "pacman"; then
        if ! test -z "$AUR_up"; then
            if ! test -z "$YES"; then 
                eval "yes | $AUR_up"
            else 
                eval "$AUR_up"
            fi
        else
            if ! test -z "$YES"; then 
                eval "yes | $pac_up"
            else 
                eval "$pac_up"
            fi
        fi
        hdrs="$(echo $(uname -r) | cut -d. -f-2)"
        hdrs="linux${hdrs//'.'}-headers"
        if test -z "$(pacman -Q $hdrs)"; then
            reade -Q "GREEN" -i "y" -p "Right linux headers not installed. Install $hdrs? [Y/n]: " "n" hdrs_ins
            if [ "$hdrs_ins" == "y" ]; then
                eval "$pac_ins $hdrs"
            fi
        fi
    elif test "$distro" == "Gentoo"; then
        #TODO Add update cycle for Gentoo systems
        continue
    # https://en.opensuse.org/System_Updates
    elif test "$pac" == "zypper_leap"; then
        if ! test -z "$YES"; then 
            yes | sudo zypper up
        else
            sudo zypper up
        fi
    elif test "$pac" == "zypper_tumble"; then
        if ! test -z "$YES"; then 
            yes | sudo zypper dup
        else
            yes | sudo zypper dup
        fi

    elif test "$pac" == "yum"; then
        if ! test -z "$YES"; then 
            yes | yum update
        else
            yum update
        fi 
    fi
    
    unset hdrs hdrs_ins 

    if type flatpak &> /dev/null; then
        if ! test -z "$YES"; then 
            flatpak update -y
        else
            flatpak update
        fi
    fi

    if type snap &> /dev/null; then
        if ! test -z "$YES"; then 
            yes | snap refresh
        else
            snap refresh
        fi
    fi

    if type nix-env &> /dev/null; then
        reade -i "n" -p "Update ${CYAN}nix packages?${normal} ${MAGENTA}(Fetching updated list could take a long time) [N/y]:${normal} " "y" nix_up
        if test "$nix_up" == 'y'; then
            printf "Updating all ${MAGENTA}nix packages${normal} using 'nix-env -u *'\n" && nix-env -u * 2> /dev/null
        fi 
        unset nix_up 
    fi
     

    if type gpg &> /dev/null || type gpg2 &> /dev/null; then
        if type gpg2 &> /dev/null; then
            up_gpg=gpg2
        else
            up_gpg=gpg
        fi

        reade -i "n" -p "Refresh ${CYAN}gpg keys?${normal} ${MAGENTA}(Keyservers can be unstable so this might take a while) [N/y]:${normal} " "y" gpg_up
        if test "$gpg_up" == 'y'; then
           "$up_gpg" --refresh-keys  
        fi
    fi
    unset up_gpg gpg_up

    if type pipx &> /dev/null || type npm &> /dev/null || type gem &> /dev/null || type cargo &> /dev/null; then 
        reade -i "n" -p "Update ${CYAN}packages for development package-managers - pipx, npm, gem, cargo...${normal} ${MAGENTA}(WARNING: this could take a lot longer relative to regular pm's) [N/y]:${normal} " "y" dev_up
        if [ "$dev_up" == "y" ]; then
            
            if type pipx &> /dev/null; then
                reade -Q "magenta" -i "y" -p "Update pipx? (Python standalone packages) [Y/n]: " "n" pipx_up
                if [ "$pipx_up" == "y" ]; then
                    pipx upgrade-all
                fi
            fi
            unset pipx_up

            if type npm &> /dev/null; then
                #reade -Q "magenta" -i "y" -p "Update local npm packages? (Javascript) [Y/n]: " "n" npm_up
                #if [ "$npm_up" == "y" ]; then
                #    npm update
                #fi
                #unset npm_up

                reade -Q "magenta" -i "y" -p "Update ${red}${bold}global${normal}${magenta1} npm packages? (Javascript) [Y/n]: " "n" npm_up
                if [ "$npm_up" == "y" ]; then
                    echo "This next $(tput setaf 1)sudo$(tput sgr0) will update using 'sudo npm -g update'";

                        sudo npm -g update
                        sudo npm -g upgrade
                fi
                unset npm_up
                
            fi
            
            if type cargo &> /dev/null; then
                reade -q "magenta" -i "y" -p "update cargo (rust)? [y/n]: " "n" cargo_up
                if [ "$cargo_up" == "y" ]; then
                    if test -z "$(cargo --list | grep install-update)"; then
                        reade -Q "MAGENTA" -i "y" -p "To update cargo packages, 'cargo-update' needs to be installed first. Install? [Y/n]: " "n" carg_ins
                        if [ "$carg_ins" == "y" ]; then
                            cargo install cargo-update
                        fi
                        unset cargo_ins
                    fi
                fi
                if ! test -z "$(cargo --list | grep install-update)"; then
                    cargo install-update -a
                fi
                unset cargo_up
            fi

            if type gem &> /dev/null; then
                reade -Q "magenta" -i "y" -p "Update local gems? (Ruby-on-rails) [Y/n]: " "n" gem_up
                if [ "$gem_up" == "y" ]; then
                    gem update 
                fi
                unset gem_up
            fi
        fi
        unset dev_up
        
    fi
    export SYSTEM_UPDATED="TRUE"
}

alias update-system-yes="update-system -y"
