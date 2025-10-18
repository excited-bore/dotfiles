hash ex &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! test -f ~/.exrc; then
    readyn -p "Install exrc (ex config) at $HOME?"  nsrc
    if [[ $nsrc == 'y' ]]; then
        cp ex/.exrc ~/.exrc
    fi
fi
unset nsrc

echo "This next $(tput setaf 1)sudo$(tput sgr0) will check for /root/.exrc";
if ! sudo test -f /root/.exrc; then
    readyn -p 'Install exrc (ex config) at /root?' nsrc
    if [[ $nsrc == 'y' ]]; then
        sudo cp ex/.exrc /root/.exrc
    fi
fi
unset nsrc
