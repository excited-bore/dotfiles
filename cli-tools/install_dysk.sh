# https://github.com/Canop/dysk 

hash dysk &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


if ! hash dysk &> /dev/null; then
    if test -n "$pac_ins"; then
        printf "Going to try to install dysk through the regular packagemanager\n"
        eval "$pac_ins_y" dysk
    fi
    if ! [[ $? == 0 ]] || test -z "$pac_ins"; then
        printf "Installing through regular packagemanager failed. Will just get it straight from cargo..\n"
        if ! test -f $TOP/cli-tools/pkgmngrs/install_cargo.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_cargo.sh) 
        else
            . $TOP/cli-tools/pkgmngrs/install_cargo.sh
        fi
        cargo install --locked dysk
    fi
fi
hash dysk &> /dev/null && dysk --help | $PAGER
