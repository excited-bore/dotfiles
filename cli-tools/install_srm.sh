hash srm &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! test -f ../checks/check_AUR.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
else
    . ../checks/check_AUR.sh
fi

if ! hash srm &> /dev/null; then
    if [[ $distro_base == "Arch" ]]; then
         eval "$AUR_ins_y srm"
    else
        echo "Install srm from sourceforge"
        echo "Link: https://sourceforge.net/projects/srm/"
    fi
fi
