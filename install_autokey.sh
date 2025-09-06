# https://github.com/autokey/autokey

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi


if ! hash autokey-run &> /dev/null; then
    if [[ "$distro_base" == 'Debian' ]]; then
        if ! test -f aliases/.bash_aliases.d/git.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh) 
        else
            . ./aliases/.bash_aliases.d/git.sh
        fi
        reade -Q 'GREEN' -i 'gtk qt' -p "Do you want autokey's GUI to be ${cyan}gtk-based${GREEN} or ${cyan}qt-based${GREEN} [Gtk/qt]: " gtk_qt 
        temp=$(mktemp -d)
        get-latest-releases-github https://github.com/autokey/autokey $temp 'common'
        get-latest-releases-github https://github.com/autokey/autokey $temp $gtk_qt
        (cd $temp
        VERSION="$(command ls | sed -E 's/autokey-common_|_all.deb//g')"
        sudo dpkg --install autokey-common_${VERSION}_all.deb
        sudo apt --fix-broken install)
    
    elif [[ "$distro_base" == 'Arch' ]]; then
        if ! test -f checks/check_AUR.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh) 
        else
            . ./checks/check_AUR.sh
        fi
        if [[ -n "$AUR_ins" ]]; then
            reade -Q 'GREEN' -i 'gtk qt' -p "Do you want autokey's GUI to be ${cyan}gtk-based${GREEN} or ${cyan}qt-based${GREEN} [Gtk/qt]: " gtk_qt 
            eval "${AUR_ins_y} autokey_$gtk_qt"
        fi
   
    else
        if ! hash pipx &> /dev/null; then
            if ! test -f install_pipx.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh) 
            else
                . ./install_pipx.sh
            fi
        fi
        pipx install autokey 
    fi
fi
