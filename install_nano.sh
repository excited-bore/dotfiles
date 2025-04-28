#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

get-script-dir SCRIPT_DIR

if ! type nano &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins}" nano
    elif [[ "$distro_base" == "Debian" ]]; then
        eval "${pac_ins}" nano
    fi
fi

if ! test -f ~/.nanorc; then
    readyn -p 'Install nanorc (config) at $HOME?' nsrc
    if [[ $nsrc == 'y' ]]; then
        if command ls -A /usr/share/nano &>/dev/null && ! grep -q '/usr/share/nano/' nano/.nanorc; then
            sed -i 's|include "/.*|include "/usr/share/nano/\*\.nanorc"|g' nano/.nanorc
        elif command ls -A /usr/local/share/nano &>/dev/null && ! grep -q '/usr/local/share/nano/' nano/.nanorc; then
            sed -i 's|include "/.*|include "/usr/local/share/nano/\*\.nanorc"|g' nano/.nanorc
        fi
        cp -fv nano/.nanorc ~/.nanorc
    fi
fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) will check for /root/.nanorc"

if ! sudo test -f /root/.nanorc; then
    readyn -p 'Install nanorc (config) at /root/?' nsrc
    if [[ $nsrc == 'y' ]]; then
        if command ls -A /usr/share/nano &>/dev/null && ! grep -q '/usr/share/nano/' nano/.nanorc; then
            sed -i 's|include "/.*|include "/usr/share/nano/\*\.nanorc"|g' nano/.nanorc
        elif command ls -A /usr/local/share/nano &>/dev/null && ! grep -q '/usr/local/share/nano/' nano/.nanorc; then
            sed -i 's|include "/.*|include "/usr/local/share/nano/\*\.nanorc"|g' nano/.nanorc
        fi
        sudo cp -fv nano/.nanorc /root/.nanorc
    fi
fi
