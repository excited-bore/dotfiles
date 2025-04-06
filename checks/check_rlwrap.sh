#!/bin/bash

#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if ! test -f checks/check_system.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)"
else
    . ./checks/check_system.sh
fi

if ! type rlwrap &>/dev/null; then
    readyn -p "Install rlwrap? (Offers autocompletion for input prompts - keyboard up/down)" answr
    if [[ "$answr" == "y" ]]; then
        if [[ $machine == 'Windows' ]] && type pacman &>/dev/null; then
            pacman -S rlwrap
        elif [[ $(uname -s) =~ 'CYGWIN' ]] && type apt-cyg &>/dev/null; then
            apt-cyg install rlwrap
        elif [[ "$distro_base" == "Debian" ]] || [[ "$distro_base" == "Arch" ]]; then
            eval "${pac_ins} rlwrap"
        else
            if type git &>/dev/null && type make &>/dev/null; then
                (
                    cd $TMPDIR
                    git clone https://github.com/hanslub42/rlwrap
                    cd rlwrap
                    ./configure
                    make
                    if type sudo &>/dev/null; then
                        sudo make install
                    else
                        make install
                    fi
                )
            fi
        fi
    fi
    unset answr
fi
