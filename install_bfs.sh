# https://github.com/tavianator/bfs

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! hash bfs &> /dev/null; then
    if [[ $distro_base == "Arch" ]]; then
        eval "$pac_ins_y bfs"
    elif [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins_y bfs"
        #if ! test -f ~/.local/bin/fd; then
        #    ln -s /usr/bin/fdfind ~/.local/bin/fd
        #fi
    fi
fi

