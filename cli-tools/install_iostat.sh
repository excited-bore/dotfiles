hash iostat &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! [[ -f ../checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash iostat &> /dev/null; then
    if [[ "$distro_base" == 'Debian' || "$distro_base" == 'Arch' ]]; then 
        eval "$pac_ins_y sysstat"
    fi
fi
hash iostat &> /dev/null && eval "iostat --help | $PAGER"
