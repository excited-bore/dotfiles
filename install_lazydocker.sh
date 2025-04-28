#!/usr/bin/env bash

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

get-script-dir SCRIPT_DIR

if ! type lazydocker &>/dev/null; then
    if [[ $distro_base == "Arch" ]] && test -n "$AUR_ins"; then
        eval "${AUR_ins}" lazydocker
    else
        if ! type go &>/dev/null || $(type go &>/dev/null && [[ $(go version | awk '{print $3}' | cut -c 3-) < 1.19 ]]); then
            if ! test -f install_go.sh; then
                tmp=$(mktemp) && wget -O $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh
                ./$tmp
            else
                . ./install_go.sh
            fi
            go install github.com/jesseduffield/lazydocker@latest
        fi
        #if ! type curl &> /dev/null; then
        #    if test $distro_base == 'Debian'; then
        #        eval "$pac_ins curl"
        #    elif test $distro_base == 'Arch'; then
        #        eval "$pac_ins curl  "
        #    fi
        #fi
        #curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    fi

    if type lazydocker &>/dev/null; then
        lazydocker --version
    fi

    unset nstll
fi
