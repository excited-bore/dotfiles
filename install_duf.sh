if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi


if ! type hash &> /dev/null; then
    if test -n "$pac_ins"; then
        printf "Going to try to install duf through the regular packagemanager\n"
        eval "${pac_ins_y}" duf
    fi
    if ! [[ $? == 0 ]] || test -z "$pac_ins"; then
        
        printf "Installing through regular packagemanager failed. Will just build it from source using git and go..\n"
        
        if ! hash git &> /dev/null; then
            eval "${pac_ins_y}" git
        fi
         
        if ! test -f install_go.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh) 
        else
            . ./install_go.sh
        fi
        
        (cd $TMPDIR
        git clone https://github.com/muesli/duf.git
        cd duf
        go build)
    fi
fi
hash duf &> /dev/null && duf --help | $PAGER
