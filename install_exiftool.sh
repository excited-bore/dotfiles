#!/usr/bin/env bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

get-script-dir SCRIPT_DIR

if ! type exiftool &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins}" perl-image-exiftool
    elif [[ $distro_base == "Debian" ]]; then
        eval "${pac_ins}" libimage-exiftool-perl
    fi
fi

readyn -p "Add cronjob to wipe all metadata recursively every 5 min in $HOME/Pictures?" wipe
if [[ $wipe == 'y' ]]; then
    (
        crontab -l
        echo '0,5,10,15,25,30,35,40,45,5,55 * * * * exiftool -r -overwrite_original_in_place -all= $HOME/Pictures'
    ) | sort -u | crontab -
fi
unset wipe
