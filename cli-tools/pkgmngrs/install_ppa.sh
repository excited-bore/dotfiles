hash add-apt-repository &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../../checks/check_all.sh
fi

if [[ "$distro_base" == 'Debian' ]]; then 
    if test -z "$(eval "$pac_search_ins_q software-properties-common")"; then
        eval "$pac_ins_y software-properties-common"
    fi
fi
