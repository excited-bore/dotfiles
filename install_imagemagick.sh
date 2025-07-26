if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

if ! hash magick &> /dev/null; then
    if [[ "$distro_base" == 'Debian' ]]; then
        # Installing latest version of imagemagick 'imagemagick easy installer'
        # https://github.com/SoftCreatR/imei 
        t=$(mktemp) 
        wget 'https://dist.1-2.dev/imei.sh' -qO "$t"
        bash "$t" 
        rm "$t" 
    else
        eval "$pac_ins_y imagemagick"
    fi
fi
