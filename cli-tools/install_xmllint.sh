# https://xmllint.com/

hash xmllint &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! [[ -f $TOP/checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash xmllint &>/dev/null; then
    if [[ "$distro_base" == 'Debian' ]]; then
        eval "$pac_ins_y libxml2-utils"
    elif [[ "$distro_base" == 'Arch' ]]; then
        eval "$pac_ins_y libxml2" 
    fi
fi
