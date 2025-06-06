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

DIR=$(get-script-dir)

if ! test -f $DIR/checks/check_AUR.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
else
    . $DIR/checks/check_AUR.sh
fi


if ! hash lazydocker &>/dev/null; then
    if [[ $distro_base == "Arch" ]] && test -n "$AUR_ins"; then
        eval "${AUR_ins}" lazydocker
    else
        minver=1.19
        gover=0
        hash go &> /dev/null && gover=$(go version | awk '{print $3}' | cut -c 3-)
        if ! hash go &>/dev/null || (hash go &>/dev/null && awk "BEGIN {exit !($gover < $minver)}" ); then
            if ! test -f $DIR/install_go.sh; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh)
            else
                . $DIR/install_go.sh
            fi
        fi
        go install github.com/jesseduffield/lazydocker@latest
        #if ! type curl &> /dev/null; then
        #    if test $distro_base == 'Debian'; then
        #        eval "$pac_ins curl"
        #    elif test $distro_base == 'Arch'; then
        #        eval "$pac_ins curl  "
        #    fi
        #fi
        #curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    fi

    if hash lazydocker &>/dev/null; then
        lazydocker --version
    fi

    unset nstll
fi
