# https://github.com/muesli/duf

hash duf &> /dev/null && SYSTEM_UPDATED='TRUE'

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


if ! hash duf &> /dev/null; then
    
    printf "Going to try to install duf through the regular packagemanager\n"
    eval "${pac_ins_y}" duf
    
    if ! [[ $? == 0 ]]; then
        
        printf "Installing through regular packagemanager failed. Will just build it from source using git and go..\n"
        
        if ! hash git &> /dev/null; then
            eval "${pac_ins_y}" git
        fi
         
        if ! test -f $TOP/cli-tools/pkgmngrs/install_go.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_go.sh) 
        else
            . $TOP/cli-tools/pkgmngrs/install_go.sh
        fi
        
        (cd $TMPDIR
        git clone https://github.com/muesli/duf.git
        cd duf
        go build)
    fi
fi
hash duf &> /dev/null && duf --help | $PAGER
