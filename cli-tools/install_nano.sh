hash nano &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash nano &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins_y}" nano
    elif [[ "$distro_base" == "Debian" ]]; then
        eval "${pac_ins_y}" nano
    fi
fi

nano --help | $PAGER

if ! test -f ~/.nanorc; then
    readyn -p 'Install nanorc (config) at $HOME?' nsrc
    if [[ $nsrc == 'y' ]]; then
        if command ls -A /usr/share/nano &>/dev/null && ! grep -q '/usr/share/nano/' nano/.nanorc; then
            sed -i 's|include "/.*|include "/usr/share/nano/\*\.nanorc"|g' nano/.nanorc
        elif command ls -A /usr/local/share/nano &>/dev/null && ! grep -q '/usr/local/share/nano/' nano/.nanorc; then
            sed -i 's|include "/.*|include "/usr/local/share/nano/\*\.nanorc"|g' nano/.nanorc
        fi
        cp nano/.nanorc ~/.nanorc
    fi
fi

unset nsrc

echo "This next $(tput setaf 1)sudo$(tput sgr0) will check for /root/.nanorc"

if ! sudo test -f /root/.nanorc; then
    readyn -p 'Install nanorc (config) at /root/?' nsrc
    if [[ $nsrc == 'y' ]]; then
        if command ls -A /usr/share/nano &>/dev/null && ! grep -q '/usr/share/nano/' nano/.nanorc; then
            sed -i 's|include "/.*|include "/usr/share/nano/\*\.nanorc"|g' nano/.nanorc
        elif command ls -A /usr/local/share/nano &>/dev/null && ! grep -q '/usr/local/share/nano/' nano/.nanorc; then
            sed -i 's|include "/.*|include "/usr/local/share/nano/\*\.nanorc"|g' nano/.nanorc
        fi
        sudo cp nano/.nanorc /root/.nanorc
    fi
fi

unset nsrc
