# https://github.com/astrand/xclip 
# https://github.com/bugaevc/wl-clipboard

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi


if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then
    if ! hash xclip &>/dev/null || ! hash xsel &>/dev/null; then
        printf "${CYAN}xclip${normal} and/or ${CYAN}xsel${normal} are not installed (clipboard tools for X11 based systems)\n"
        readyn -p "Install xclip and xsel?" nzp_ins
        if [[ $nzp_ins == 'y' ]]; then
            eval "$pac_ins_y xclip xsel"
        fi
        unset nzp_ins
    fi
elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
    if ! hash wl-copy &>/dev/null || ! hash wl-paste &>/dev/null; then
        printf "${CYAN}wl-copy${normal} and/or ${CYAN}wl-paste${normal} are not installed (clipboard tools for Wayland based systems)\n"
        readyn -p "Install wl-clipboard?" nzp_ins
        if [[ $nzp_ins == 'y' ]]; then
            eval "$pac_ins_y wl-clipboard"
        fi
        unset nzp_ins
    fi
fi
