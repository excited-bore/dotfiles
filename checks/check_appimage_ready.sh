
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi 

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if test $distro_base == "Debian"; then
    # Libfuse2 has a lot of CVE errors
    if test $distro == "Ubuntu"; then
        if test -z "$(dpkg -l | grep libfuse2)"; then
            reade -Q "YELLOW" -i "n" -p "A package called 'libfuse2' is necessary for Appimages, but it has been removed because it is outdated and vulnerable to a bunch of CVE's\n Still install libfuse2? [Y/n]: " "y n" inslibfuse
            if [ "$inslibfuse" == "y" ]; then
                sudo apt install libfuse2
            fi
        fi
        #if ! test -z "$(dpkg -l | grep libfuse2)"; then
        #    sudo add-apt-repository ppa:appimagelauncher-team/stable
        #    sudo apt update
        #    sudo apt install appimagelauncher
        #fi
    fi
fi

