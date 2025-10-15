if ! test -f checks/check_all.sh; then
    if type curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
    else 
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

DIR=$(get-script-dir) 

if ! hash ncdu &> /dev/null; then
    if test -n "$pac_ins"; then
        eval "${pac_ins} ncdu" 
    fi
fi
ncdu --help | $PAGER 
