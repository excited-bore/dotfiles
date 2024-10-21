if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 
if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system 
    fi
fi 

if ! type exiftool &> /dev/null; then
    if [ "$distro" == "Manjaro" ]; then
        pamac install perl-image-exiftool
    elif test "$distro_base" == "Arch"; then
        eval "$pac_ins perl-image-exiftool"
    elif [ $distro_base == "Debian" ]; then
        eval "$pac_ins libimage-exiftool-perl"
    fi
fi

reade -Q 'GREEN' -i 'y' -p "Add cronjob to wipe all metadata recursively every 5 min in $HOME/Pictures? [Y/n]: " 'n' wipe

if test $wipe == 'y'; then
   (crontab -l; echo '0,5,10,15,25,30,35,40,45,5,55 * * * * exiftool -r -all= $HOME/Pictures') | sort -u | crontab - 
fi
unset wipe
