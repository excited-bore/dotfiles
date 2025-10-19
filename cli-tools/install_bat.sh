hash bat &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if ! hash bat &> /dev/null; then 
    if [[ $distro_base == "Arch" ]]; then
        eval "$pac_ins_y bat"
    elif [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins_y bat"
        if hash batcat &> /dev/null; then
            mkdir -p ~/.local/bin
            ln -s /usr/bin/batcat ~/.local/bin/bat
        fi
    else
        eval "$pac_ins_y bat"
    fi
fi 

if ! hash batdiff &> /dev/null; then 
    readyn -p "Install bat-extras (includes batdiff/batgrep/batman/bat-modules/batpipe/batwatch)" bat
    if [[ "$bat" == "y" ]]; then
        if [[ "$distro_base" == "Arch" ]];then
            eval "$pac_ins_y bat-extras"
        elif [[ $distro_base == "Debian" ]]; then
            #yes | eval "$pac_ins golang"
            #go install mvdan.cc/sh/v3/cmd/shfmt@latest
            git clone https://github.com/eth-p/bat-extras $TMPDIR/bat-extras
            chown -R $USER $TMPDIR/bat-extras
            (cd $TMPDIR/bat-extras && sudo ./build.sh --install --prefix=/usr)
        fi 
    fi
    unset bat 
fi

