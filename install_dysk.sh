if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi


if ! hash dysk &> /dev/null; then
    if test -n "$pac_ins"; then
        printf "Going to try to install dysk through the regular packagemanager\n"
        eval "$pac_ins_y" dysk
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
hash dysk &> /dev/null && dysk --help | $PAGER
