if ! test -f rlwrap_scripts.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test "$(timedatectl show | grep ^NTP | head -n 1 | awk 'BEGIN { FS = "=" } ; {print $2}')" == "yes"; then 
    reade -Q "GREEN" -i "y" -p "NTP not set (Network TimeSync). This can cause issues with syncing to repositories. Activate it? [Y/n]: " "y n" set_ntp
    if [ "$set_ntp" == "y" ]; then
        timedatectl set-ntp true
    fi
fi


echo "This next $(tput setaf 1)sudo$(tput sgr0) will try to update the packages for your system using the package managers it knows";

if test $distro == "Raspbian"; then
    sudo rpi-update
elif test $packmang == "apt"; then
    sudo apt update
elif test $packmang == "apk"; then
    apk update
elif test $packmang == "pacman"; then
    sudo pacman -Syu
    if ! test -z "$AUR_helper" && ! test -z "$AUR_update"; then
        eval "$AUR_update"
    fi
elif test $distro == "Gentoo"; then
    #TODO Add update cycle for Gentoo systems
    continue
# https://en.opensuse.org/System_Updates
elif test $packmang == "zypper_leap"; then
    sudo zypper up
elif test $packmang == "zypper_tumble"; then
    sudo zypper dup
elif test $packmang == "yum"; then
    yum update
fi

if type flatpak &> /dev/null; then
    flatpak update
fi

if type snap &> /dev/null; then
    snap refresh
fi


if type pipx &> /dev/null || type npm &> /dev/null || type gem &> /dev/null || type cargo &> /dev/null; then 
    reade -Q "MAGENTA" -i "n" -p "Update Packages from development package-managers? (pipx, npm, gem, cargo... - WARNING: this could take a lot longer relative to regular pm's) [N/y]: " "y n" dev_up
    if [ "$dev_up" == "y" ]; then
        
        if type pipx &> /dev/null; then
            reade -Q "magenta" -i "y" -p "Update pipx? (Python standalone packages) [Y/n]: " "y n" pipx_up
            if [ "$pipx_up" == "y" ]; then
                pipx upgrade-all
            fi
        fi
        unset pipx_up

        if type npm &> /dev/null; then
            reade -Q "magenta" -i "y" -p "Update local npm packages? (Javascript) [Y/n]: " "y n" npm_up
            if [ "$npm_up" == "y" ]; then
                npm update
            fi
            unset npm_up
        fi
        
        if type cargo &> /dev/null; then
            reade -Q "magenta" -i "y" -p "Update cargo (Rust)? [Y/n]: " "y n" cargo_up
            if [ "$cargo_up" == "y" ]; then
                if test -z "$(cargo --list | grep install-update)"; then
                    reade -Q "MAGENTA" -i "y" -p "To update cargo packages, 'cargo-update' needs to be installed first. Install? [Y/n]: " "y n" carg_ins
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
            reade -Q "magenta" -i "y" -p "Update local gems? (Ruby-on-rails) [Y/n]: " "y n" gem_up
            if [ "$gem_up" == "y" ]; then
                gem update 
            fi
            unset gem_up
        fi
    fi
    unset dev_up
fi