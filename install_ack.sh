if ! test -f checks/check_all.sh; then
     source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
else
    . ./checks/check_all.sh
fi

if ! test -f checks/check_AUR.sh; then
    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh) 
else
    . ./checks/check_AUR.sh
fi


if ! type ack &> /dev/null; then
    if test -n "$AUR_ins"; then
        eval "${AUR_ins}" ack 
    elif test -n "$pac_ins"; then
        printf "Going try to install ack through the regular packagemanager\n"
        eval "${pac_ins}" ack
    fi
    if ! [[ $? == 0 ]] || test -z "$pac_ins"; then
        printf "Installing through regular packagemanager failed. Will just get it straight from beyongrep.com..\n"
        b="$(curl https://beyondgrep.com/ack-2.16-single-file)" 
        sudo tee "$b" /usr/bin/ack 
        sudo chmod 0755 /usr/bin/ack
        unset b 
    fi
fi
hash ack &> /dev/null && eval "ack --help | $PAGER"
