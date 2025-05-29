if ! test -f checks/check_all.sh; then
    if type curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
    else 
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n" 
        return 1 || exit 1 
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
