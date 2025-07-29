if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if ! hash python &> /dev/null; then
    if [[ "$distro_base" == 'Arch' ]]; then
        eval "$pac_ins_y python" 
    elif [[ "$distro_base" == 'Debian' ]]; then
        eval "$pac_ins_y python3"
        readyn -p "${CYAN}Python3${GREEN} installed. Set as default for ${CYAN}python${GREEN}?" py3py
        if [[ "$py3py" == 'y' ]]; then
            eval "$pac_ins_y python3-is-python" 
        fi
    fi
fi
