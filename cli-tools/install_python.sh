hash python3 &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash python3 &> /dev/null || ! hash python &> /dev/null; then
    if [[ "$distro_base" == 'Arch' ]]; then
        eval "$pac_ins_y python" 
    elif [[ "$distro_base" == 'Debian' ]]; then
        
        if ! hash python3 &> /dev/null; then
            eval "$pac_ins_y python3"
        fi
        
        readyn -p "${CYAN}Python3${GREEN} installed. Make typing '${CYAN}python${GREEN}' use '${CYAN}python3${GREEN}'?" py3py
        if [[ "$py3py" == 'y' ]]; then
            eval "$pac_ins_y python3-is-python" 
        fi
        unset py3py
    fi
fi
