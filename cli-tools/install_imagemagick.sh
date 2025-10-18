# https://github.com/ImageMagick/ImageMagick
# https://github.com/SoftCreatR/imei

hash imagemagick &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash magick &> /dev/null; then
    if [[ "$distro_base" == 'Debian' ]]; then
        if hash convert &> /dev/null; then
            eval "$pac_rm_y imagemagick" 
        fi
        # Installing latest version of imagemagick 'imagemagick easy installer'
        # https://github.com/SoftCreatR/imei  
        wget-curl 'https://dist.1-2.dev/imei.sh' > $TMPDIR/imei.sh
        chmod u+x $TMPDIR/imei.sh
        sudo $TMPDIR/imei.sh 
        rm "$TMPDIR/imei.sh" 
    else
        eval "$pac_ins_y imagemagick"
    fi
fi
