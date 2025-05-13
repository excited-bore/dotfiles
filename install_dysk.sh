if ! test -f checks/check_all.sh; then
     source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
else
    . ./checks/check_all.sh
fi


if ! type dysk &> /dev/null; then
    if test -n "$pac_ins"; then
        printf "Going to try to install dysk through the regular packagemanager\n"
        eval "${pac_ins}" dysk
    fi
    if ! [[ $? == 0 ]] || test -z "$pac_ins"; then
        printf "Installing through regular packagemanager failed. Will just get it straight from cargo..\n"
        if ! test -f install_cargo.sh; then
            source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh) 
        else
            . ./install_cargo.sh
        fi
        cargo install --locked dysk
    fi
fi
test -z "$PAGER" && PAGER="less -Q --no-vbell --quit-if-one-screen -N --use-color"
hash dysk &> /dev/null && dysk --help | $PAGER
