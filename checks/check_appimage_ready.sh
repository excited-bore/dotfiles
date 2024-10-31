
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi 

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if test $distro_base == "Debian"; then
    # Libfuse2 has a lot of CVE errors so not all systems have it installed by default
    if test -z "$(dpkg -l | grep libfuse2)"; then
        printf "A package called 'libfuse2' is necessary for Appimages, but it has been removed because it is outdated and vulnerable to a bunch of CVE's\n" 
        reade -Q "YELLOW" -i "n" -p "Still install libfuse2? [N/y]: " "y" inslibfuse
        if [ "$inslibfuse" == "y" ]; then
            eval "$pac_ins libfuse2t64"
        fi
    fi
fi
