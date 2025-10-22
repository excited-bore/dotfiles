hash discord &> /dev/null && SYSTEM_UPDATED='TRUE'

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


if ! hash discord &> /dev/null; then
    if [[ "$distro_base" == "Arch" || "$distro_base" == "Debian" ]]; then
        eval "$pac_ins_y discord" 
    fi 
fi

if ! grep -q 'SKIP_HOST_UPDATE' ~/.config/discord/settings.json; then
    sed -i 's|^{|{\n "SKIP_HOST_UPDATE": true,|g' ~/.config/discord/settings.json 
fi
