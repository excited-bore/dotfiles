# https://exiftool.org/

hash exiftool &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! hash exiftool &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins_y}" perl-image-exiftool
    elif [[ $distro_base == "Debian" ]]; then
        eval "${pac_ins_y}" libimage-exiftool-perl
    fi
fi

readyn -p "Add cronjob to wipe all metadata recursively every 5 min in $HOME/Pictures?" wipe
if [[ $wipe == 'y' ]]; then
    (
        echo '0,5,10,15,25,30,35,40,45,5,55 * * * * exiftool -r -overwrite_original_in_place -all= $HOME/Pictures'
    ) | sort -u | crontab -
    crontab -l
fi
unset wipe
