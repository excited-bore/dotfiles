hash pip &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if ! hash pip &> /dev/null; then
    echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pip"
    if [[ $distro_base == "Arch" ]]; then
        eval "$pac_ins_y python python-pip"
    elif [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins_y python3 python3-pip"
    fi
fi
