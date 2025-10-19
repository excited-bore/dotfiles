# https://www.nano-editor.org/

hash nano &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash nano &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins_y}" nano
    elif [[ "$distro_base" == "Debian" ]]; then
        eval "${pac_ins_y}" nano
    fi
fi

nano --help | $PAGER

if test -f $TOP/cli-tools/nano/.nanorc; then
    file=$TOP/cli-tools/nano/.nanorc
else
    dir=$(mktemp -d) 
    wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/nano/.nanorc > $dir/.nanorc
    file=$dir/.nanorc
fi

if ! test -f ~/.nanorc; then
    readyn -p 'Install nanorc (config) at $HOME?' nsrc
    if [[ $nsrc == 'y' ]]; then
        if command ls -A /usr/share/nano &>/dev/null && ! grep -q '/usr/share/nano/' $file; then
            sed -i 's|include "/.*|include "/usr/share/nano/\*\.nanorc"|g' $file
        elif command ls -A /usr/local/share/nano &>/dev/null && ! grep -q '/usr/local/share/nano/' $file; then
            sed -i 's|include "/.*|include "/usr/local/share/nano/\*\.nanorc"|g' $file
        fi
        cp $file ~/.nanorc
    fi
fi

unset nsrc

echo "This next $(tput setaf 1)sudo$(tput sgr0) will check for /root/.nanorc"

if ! sudo test -f /root/.nanorc; then
    readyn -p 'Install nanorc (config) at /root/?' nsrc
    if [[ $nsrc == 'y' ]]; then
        if command ls -A /usr/share/nano &>/dev/null && ! grep -q '/usr/share/nano/' $file; then
            sed -i 's|include "/.*|include "/usr/share/nano/\*\.nanorc"|g' $file
        elif command ls -A /usr/local/share/nano &>/dev/null && ! grep -q '/usr/local/share/nano/' $file; then
            sed -i 's|include "/.*|include "/usr/local/share/nano/\*\.nanorc"|g' $file
        fi
        sudo cp $file /root/.nanorc
    fi
fi

unset nsrc
