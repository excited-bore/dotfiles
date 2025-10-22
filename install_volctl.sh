# https://github.com/buzz/volctl

hash volctl &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash volctl &> /dev/null; then
    if [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
        echo "${RED}Wayland${red} is sadly not supported. Exiting...${normal}"
    else 
        if [[ $distro_base == 'Arch' ]]; then
            if test -f $SCRIPT_DIR/checks/check_AUR.sh; then
                source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
            else
                . $SCRIPT_DIR/checks/check_AUR.sh
            fi
            eval "${AUR_ins_y} volctl" 
        else
            if ! hash git &> /dev/null; then
                eval "$pac_ins_y git" 
            fi
            if ! hash pipx &> /dev/null; then
                if [[ -f $SCRIPT_DIR/cli-tools/pkgmngrs/install_pipx.sh ]]; then
                    source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_pipx.sh)
                else
                    . $SCRIPT_DIR/cli-tools/pkgmngrs/install_pipx.sh
                fi
            fi
            git clone https://github.com/buzz/volctl $TMPDIR/volctl
            (cd $TMPDIR/volctl 
            pipx install .
            ! test -d $XDG_DATA_HOME/glib-2.0/schemas &&
                mkdir -p $XDG_DATA_HOME/glib-2.0/schemas 
            ! test -d $XDG_DATA_HOME/applications &&
                mkdir -p $XDG_DATA_HOME/applications 
            ! test -f $XDG_DATA_HOME/glib-2.0/schemas/apps.volctl.gschemas.xml && 
                cp data/apps.volctl.gschema.xml $XDG_DATA_HOME/glib-2.0/schemas/
            ! test -f $XDG_DATA_HOME/applications/applications/volctl.desktop && 
                cp data/volctl.desktop $XDG_DATA_HOME/applications/volctl.desktop
            update-desktop-database $XDG_DATA_HOME/applications/
            glib-compile-schemas $XDG_DATA_HOME/glib-2.0/schemas/
            ) 
        fi
    fi
fi
