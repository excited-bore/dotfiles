if ! test -f checks/check_all.sh; then
     source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
else
    . ./checks/check_all.sh
fi


if ! type duf &> /dev/null; then
    if test -n "$pac_ins"; then
        printf "Going to try to install duf through the regular packagemanager\n"
        eval "${pac_ins}" duf
    fi
    if ! [[ $? == 0 ]] || test -z "$pac_ins"; then
        
        printf "Installing through regular packagemanager failed. Will just build it from source using git and go..\n"
        
        if ! hash git &> /dev/null; then
            eval "${pac_ins}" git
        fi
         
        if ! test -f install_go.sh; then
            source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh) 
        else
            . ./install_go.sh
        fi
        
        (cd $TMPDIR
        git clone https://github.com/muesli/duf.git
        cd duf
        go build)
    fi
fi
test -z "$PAGER" && PAGER="less -Q --no-vbell --quit-if-one-screen -N --use-color"
hash duf &> /dev/null && duf --help | $PAGER
