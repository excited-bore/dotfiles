# https://github.com/bkw777/mainline

hash mainline &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if ! hash mainline &>/dev/null; then
    if [[ "$distro" == 'Ubuntu' ]]; then
        sudo add-apt-repository ppa:cappelikan/ppa 
        eval "${pac_up}" 
        eval "$pac_ins_y mainline"
    elif [[ "$distro_base" == 'Debian' ]]; then
        eval "$pac_ins_y libgee-0.8-dev git libjson-glib-dev libvte-2.91-dev valac aria2 lsb-release" 
        git clone https://github.com/bkw777/mainline.git $TMPDIR/mainline 
        (cd $TMPDIR/mainline
        make
        sudo make install) 
    fi
fi 

