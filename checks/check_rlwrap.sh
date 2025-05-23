#!/bin/bash

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


if ! type rlwrap &>/dev/null; then
    readyn -p "Install rlwrap? (Offers autocompletion for input prompts - keyboard up/down)" answr
    if [[ "$answr" == "y" ]]; then
        if [[ $machine == 'Windows' ]] && type pacman &>/dev/null; then
            pacman -S rlwrap
        elif [[ $(uname -s) =~ 'CYGWIN' ]] && type apt-cyg &>/dev/null; then
            apt-cyg install rlwrap
        elif [[ $machine == 'Mac' ]] && type brew &>/dev/null; then
            brew install rlwrap
        elif [[ "$distro_base" == "Debian" ]] || [[ "$distro_base" == "Arch" ]]; then
            eval "${pac_ins} rlwrap"
        else
            if type git &>/dev/null && type make &>/dev/null; then
                test -z $TMPDIR && TMPDIR=$(mktemp -d) 
                (
                    cd $TMPDIR
                    git clone https://github.com/hanslub42/rlwrap $TMPDIR
                    cd $TMPDIR/rlwrap
                    ./configure
                    make
                    if type sudo &>/dev/null; then
                        sudo make install
                    else
                        make install
                    fi
                    cd ..
                    command rm -r rlwrap/
                )
            fi
        fi
    fi
    unset answr
fi
