SYSTEM_UPDATED='TRUE'

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

test -z "$TMPDIR" && TMPDIR=$(mktemp -d)

curl https://raw.githubusercontent.com/jarun/advcpmv/master/install.sh --create-dirs -o $TMPDIR/advcpmv/install.sh 
(cd $TMPDIR/advcpmv && sh install.sh)
