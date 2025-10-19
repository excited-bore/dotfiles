# https://www.cgsecurity.org/wiki/TestDisk_Download

hash testdisk &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash testdisk &>/dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install testdisk"
    if [[ $distro_base == "Arch" || $distro_base == "Debian" ]]; then
        eval "${pac_ins_y}" testdisk
    fi
fi
