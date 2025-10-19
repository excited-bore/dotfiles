# https://github.com/autokey/autokey

if hash autokey &> /dev/null || [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then 
    SYSTEM_UPDATED=TRUE
fi

TOP=$(git rev-parse --show-toplevel)

if ! [[ -f $TOP/checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if [[ $XDG_SESSION_TYPE == 'wayland' ]]; then
    echo "${YELLOW}Current session type - ${RED}Wayland${YELLOW} - is not supported by autokey${normal}" 
elif ! hash autokey &> /dev/null; then
    if [[ "$distro_base" == 'Debian' ]]; then
        if ! [[ -f $TOP/aliases/.aliases.d/git.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.aliases.d/git.sh) 
        else
            . $TOP/aliases/.aliases.d/git.sh
        fi
        reade -Q 'GREEN' -i 'gtk qt' -p "Do you want autokey's GUI to be ${cyan}gtk-based${GREEN} or ${cyan}qt-based${GREEN} [Gtk/qt]: " gtk_qt 
        temp=$(mktemp -d)
        get-latest-releases-github https://github.com/autokey/autokey $temp 'common'
        get-latest-releases-github https://github.com/autokey/autokey $temp $gtk_qt
        (cd $temp
        #VERSION="$(command ls | sed -E 's/autokey-common_|_all.deb//g')"
        sudo dpkg --install *
        sudo apt --fix-broken install
        cd ..
        command rm -rf $temp)
    
    elif [[ "$distro_base" == 'Arch' ]]; then
        if ! [[ -f $TOP/checks/check_AUR.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh) 
        else
            . $TOP/checks/check_AUR.sh
        fi
        if [[ -n "$AUR_ins" ]]; then
            reade -Q 'GREEN' -i 'gtk qt' -p "Do you want autokey's GUI to be ${cyan}gtk-based${GREEN} or ${cyan}qt-based${GREEN} [Gtk/qt]: " gtk_qt 
            eval "${AUR_ins_y} autokey_$gtk_qt"
        fi
   
    else
        if ! hash pipx &> /dev/null; then
            if ! [[ -f $TOP/cli-tools/pkgmngrs/install_pipx.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_pipx.sh) 
            else
                . $TOP/cli-tools/pkgmngrs/install_pipx.sh
            fi
        fi
        pipx install autokey 
    fi
fi
