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

# https://www.explainxkcd.com/wiki/index.php/1654:_Universal_Install_Script
function update-system() {
    if type timedatectl &> /dev/null && ! test "$(timedatectl show | grep ^NTP | head -n 1 | awk 'BEGIN { FS = "=" } ; {print $2}')" == "yes"; then 
        reade -Q "GREEN" -i "y" -p "Timedate NTP not set (Automatic timesync). This can cause issues with syncing to repositories. Activate it? [Y/n]: " "n" set_ntp
        if [ "$set_ntp" == "y" ]; then
            timedatectl set-ntp true
            timedatectl status
        fi
    fi

    if test $machine == 'Mac' && ! type brew &> /dev/null; then
        printf "${GREEN}Homebrew is a commandline package manager (like the Appstore) thatworks as an opensource alternative to the Appstore\nGui applications are available for it as well\n${normal}"
        reade -Q 'CYAN' -i 'y' -p 'Install brew? [Y/n]: ' 'n' brew
        if test $brew == 'y'; then
            if ! test -f install_brew.sh; then
                 eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_brew.sh)" 
            else
                ./install_brew.sh
            fi
        fi
    elif test $machine == 'Windows' && test $win_bash_shell == 'Git' && ! test -d '/c/cygwin64' && ! test -d '/c/git-sdk-32'; then
        # export PATH=$PATH:/c/cygwin64/bin
        printf "${GREEN}Git bash is an environment without a package manager.\n\t - Cygwin is a collection of UNIX related tools (with a pm if you install 'apt-cyg')\n\t- Git SDK for windows comes with pacman (arch package manager)\n${normal}"
        reade -Q 'CYAN' -i 'sdk' -p 'Install git SDK or Cygwin? [Sdk/cyg/n]: ' 'cyg n' cyg
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
            printf "${CYAN}Don't forget to open up git SDK and restart this script${normal}\n"
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
            brew upgrade 
        fi
    elif test "$packmang" == "apt"; then
        pac=apt
        if type nala &> /dev/null; then
           pac=nala 
        fi
        sudo "$pac" update
        sudo "$pac" upgrade
        hdrs="linux-headers-$(uname -r)"
        if test -z "sudo apt list --installed | grep $hdrs"; then
            reade -Q "GREEN" -i "y" -p "Right linux headers not installed. Install $hdrs? [Y/n]: " "n" hdrs_ins
            if [ "$hdrs_ins" == "y" ]; then
                sudo apt install "$hdrs"
            fi
        fi
    elif test "$packmang" == "apk"; then
        apk update
    elif test "$packmang" == "pacman"; then
        sudo pacman -Syu
        if ! test -z "$AUR_helper" && ! test -z "$AUR_update"; then
            eval "$AUR_update"
        fi
        hdrs="$(echo $(uname -r) | cut -d. -f-2)"
        hdrs="linux$(echo $(uname -r) | cut -d. -f-1)${hdrs: -1}-headers"
        if test -z "sudo pacman -Q $hdrs"; then
            reade -Q "GREEN" -i "y" -p "Right linux headers not installed. Install $hdrs? [Y/n]: " "n" hdrs_ins
            if [ "$hdrs_ins" == "y" ]; then
                sudo pacman -S "$hdrs"
            fi
        fi
    elif test "$distro" == "Gentoo"; then
        #TODO Add update cycle for Gentoo systems
        continue
    # https://en.opensuse.org/System_Updates
    elif test "$packmang" == "zypper_leap"; then
        sudo zypper up
    elif test "$packmang" == "zypper_tumble"; then
        sudo zypper dup
    elif test "$packmang" == "yum"; then
        yum update
    fi
    
    unset hdrs hdrs_ins 

    if type flatpak &> /dev/null; then
        flatpak update
    fi

    if type snap &> /dev/null; then
        snap refresh
    fi

    if type gpg &> /dev/null || type gpg2 &> /dev/null; then
        if type gpg2 &> /dev/null; then
            up_gpg=gpg2
        else
            up_gpg=gpg
        fi
        reade -Q "MAGENTA" -i "n" -p "Refresh gpg keys? (Keyservers can be unstable so this might take a while) [N/y]: " "y" gpg_up
        if test "$gpg_up" == 'y'; then
           "$up_gpg" --refresh-keys  
        fi
    fi
    unset up_gpg gpg_up

    if type pipx &> /dev/null || type npm &> /dev/null || type gem &> /dev/null || type cargo &> /dev/null; then 
        reade -Q "MAGENTA" -i "n" -p "Update Packages from development package-managers? (pipx, npm, gem, cargo... - WARNING: this could take a lot longer relative to regular pm's) [N/y]: " "y" dev_up
        if [ "$dev_up" == "y" ]; then
            
            if type pipx &> /dev/null; then
                reade -Q "magenta" -i "y" -p "Update pipx? (Python standalone packages) [Y/n]: " "n" pipx_up
                if [ "$pipx_up" == "y" ]; then
                    pipx upgrade-all
                fi
            fi
            unset pipx_up

            if type npm &> /dev/null; then
                reade -Q "magenta" -i "y" -p "Update local npm packages? (Javascript) [Y/n]: " "n" npm_up
                if [ "$npm_up" == "y" ]; then
                    npm update
                fi
                unset npm_up

                reade -Q "magenta" -i "y" -p "Update ${red}${bold}global${normal}${magenta1} npm packages? (Javascript) [Y/n]: " "n" npm_up
                if [ "$npm_up" == "y" ]; then
                    echo "This next $(tput setaf 1)sudo$(tput sgr0) will update using 'sudo npm -g update'";
                    sudo npm -g update
                fi
                unset npm_up
                
            fi
            
            if type cargo &> /dev/null; then
                reade -Q "magenta" -i "y" -p "Update cargo (Rust)? [Y/n]: " "n" cargo_up
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
}

 SYSTEM_UPDATED="TRUE"
