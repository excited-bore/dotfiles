# https://github.com/aristocratos/btop
# https://github.com/aristocratos/bpytop
# https://github.com/aristocratos/bashtop

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash btop &>/dev/null; then
    #readyn -p "Install btop?" sym2
    #if [[ "$sym2" == "y" ]]; then
        #reade -Q "CYAN" -i "btop" -p "Which one? [Btop/bpytop/bashtop]: " "bpytop bashtop" sym2
        #if test "$sym2" == "btop"; then
        if [[ "$distro_base" == "Debian" ]] || [[ "$distro_base" == "Arch" ]]; then
            eval "${pac_ins_y}" btop
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
    #fi
fi
