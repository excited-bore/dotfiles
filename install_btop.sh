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

if ! type btop &>/dev/null; then
    readyn -p "Install btop?" sym2
    if [[ "$sym2" == "y" ]]; then
        #reade -Q "CYAN" -i "btop" -p "Which one? [Btop/bpytop/bashtop]: " "bpytop bashtop" sym2
        #if test "$sym2" == "btop"; then
        if [[ "$distro_base" == "Debian" ]] || [[ "$distro_base" == "Arch" ]]; then
            eval "${pac_ins}" btop
        fi
        #elif test "$sym2" == "bpytop"; then
        #   if test $distro_base == "Debian"; then
        #       eval "$pac_ins bpytop"
        #    elif test $distro == "Arch" || test $distro == "Manjaro"; then
        #       eval "$pac_ins bpytop"
        #    fi
        #elif test "$sym2" == "bashtop"; then
        #    if type add-apt-repository &> /dev/null && [[ $(check-ppa ppa:bashtop-monitor/bashtop) =~ 'OK' ]]; then
        #        sudo add-apt-repository ppa:bashtop-monitor/bashtop
        #        sudo apt update
        #        eval "$pac_ins bashtop"
        #    elif test "$distro" == "Arch" || test "$distro" == "Manjaro"; then
        #       eval "$pac_ins bashtop"
        #    else
        #        git clone https://github.com/aristocratos/bashtop.git $TMPDIR
        #        (cd $TMPDIR/bashtop && sudo make install)
        #    fi
        #fi
    fi
fi
