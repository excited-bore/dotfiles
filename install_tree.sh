if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! hash tree &> /dev/null; then 
    if [[ "$distro_base" == "Arch" ]] || [[ "$distro_base" == "Debian" ]] ;then
        eval "$pac_ins_y tree"
    fi
fi
