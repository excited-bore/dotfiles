# !/bin/bash

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
if ! type bat &> /dev/null; then 
    if [[ $distro_base == "Arch" ]]; then
        eval "$pac_ins bat"
    elif [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins bat"
        if type batcat &> /dev/null; then
            mkdir -p ~/.local/bin
            ln -s /usr/bin/batcat ~/.local/bin/bat
        fi
    else
        eval "$pac_ins bat"
    fi
fi 

if ! type batdiff &> /dev/null; then 
    readyn -p "Install bat-extras (includes batdiff/batgrep/batman/bat-modules/batpipe/batwatch)" bat
    if [[ "$bat" == "y" ]]; then
        if [[ "$distro_base" == "Arch" ]];then
            eval "$pac_ins bat-extras"
        elif [[ $distro_base == "Debian" ]]; then
            #yes | eval "$pac_ins golang"
            #go install mvdan.cc/sh/v3/cmd/shfmt@latest
            git clone https://github.com/eth-p/bat-extras $TMPDIR/bat-extras
            chown -R $USER $TMPDIR/bat-extras
            (cd $TMPDIR/bat-extras && sudo ./build.sh --install --prefix=/usr)
        fi 
    fi
fi

unset bat 
