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
reade -Q 'GREEN' -i 'replace install' -p "Replace regular cp in ${CYAN}/usr/bin${GREEN} or just install as ${CYAN}cpg/mvg${GREEN} in ${CYAN}/usr/local/bin${GREEN} [Replace/install]: ${normal}" replc_ins
if [[ $replc_ins == 'replace' ]]; then
    sudo mv $TMPDIR/advcpmv/advcp /usr/bin/cp 
    sudo cp -f $TMPDIR/advcpmv/advmv /usr/bin/mv 
elif [[ $replc_ins == 'install' ]]; then
    sudo mv $TMPDIR/advcpmv/advcp /usr/local/bin/cp 
    sudo mv $TMPDIR/advcpmv/advmv /usr/local/bin/mv 
fi
