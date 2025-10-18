hash rlwrap &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! [[ -f ../checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi


if ! hash rlwrap &>/dev/null; then
    readyn -p "Install rlwrap? (Offers autocompletion for input prompts - keyboard up/down)" answr
    if [[ "$answr" == "y" ]]; then
        if [[ $machine == 'Windows' ]] && hash pacman &>/dev/null; then
            pacman -S rlwrap
        elif [[ $(uname -s) =~ 'CYGWIN' ]]; then
            if ! hash apt-cyg &>/dev/null; then
                if ! [[ -f pkgmngrs/install_apt-cyg.sh ]]; then
                    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_rlwrap.sh)
                else
                    . pkgmngrs/install_apt-cyg.sh
                fi
            fi
            apt-cyg install rlwrap
        elif [[ $machine == 'Mac' ]] && type brew &>/dev/null; then
            if ! hash brew &> /dev/null; then
                if ! [[ -f pkgmngrs/install_brew.sh ]]; then
                    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_brew.sh)
                else
                    . pkgmngrs/install_brew.sh
                fi
            fi
            brew install rlwrap
        elif [[ "$distro_base" == "Debian" ]] || [[ "$distro_base" == "Arch" ]]; then
            eval "${pac_ins_y} rlwrap"
        else
            ! hash git &> /dev/null &&
                eval "$pac_ins_y git"
            ! hash make &> /dev/null &&
                eval "$pac_ins_y make"
            if hash git &>/dev/null && hash make &>/dev/null; then
                (
                    cd $TMPDIR
                    git clone https://github.com/hanslub42/rlwrap $TMPDIR
                    cd $TMPDIR/rlwrap
                    ./configure
                    make
                    if hash sudo &>/dev/null; then
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
