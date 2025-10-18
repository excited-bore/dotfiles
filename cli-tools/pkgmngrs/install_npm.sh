hash npm &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../../checks/check_all.sh
fi

if ! hash npm &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install npm and nodejs"
    if [[ $distro_base == "Arch" ]]; then
        eval "${pac_ins} npm nodejs"
    elif [[ $distro_base == "Debian" ]]; then
        eval "${pac_ins} npm nodejs"
    fi
fi
