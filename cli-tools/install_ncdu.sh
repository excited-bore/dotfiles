hash ncdu &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
    else 
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash ncdu &> /dev/null; then
    if test -n "$pac_ins_y"; then
        eval "${pac_ins_y} ncdu" 
    fi
fi
ncdu --help | $PAGER 
