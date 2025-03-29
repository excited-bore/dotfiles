#!/usr/bin/env bash

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

if ! type thefuck &>/dev/null; then
    if [[ $machine == 'Mac' ]] && type brew &>/dev/null; then
        brew install thefuck
    elif [[ $distro_base == 'Arch' ]]; then
        sudo pacman -S thefuck
    elif type pkg &>/dev/null; then
        pkg install thefuck
    elif type crew &>/dev/null; then
        crew install thefuck
    else
        if ! type pipx &>/dev/null; then
            if ! test -f install_pipx.sh; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)"
            else
                . ./install_pipx.sh
            fi
            if test -f $HOME/.local/bin/pipx && ! type pipx &>/dev/null; then
                $HOME/.local/bin/pipx install --upgrade thefuck
            elif type pipx &>/dev/null; then
                pipx install --upgrade thefuck
            fi
        fi
    fi
fi

if ! grep -q 'eval $(thefuck --alias' ~/.bashrc; then
    reade -Q 'GREEN' -i 'f fuk oops ops fuck hell heck hek egh huhn huh nono again agin asscreamIscream' -p "Alias for name 'thefuck'? [Empty: 'f' - 'thefuck' cant be used]: " ansr
    if [[ $ansr == 'thefuck' ]]; then
        printf "'thefuck' cant be aliased to 'thefuck'\n"
        printf "Using 'f' as alias\n"
        ansr='f'
    fi

    if ! test -z $ansr; then
        printf "eval \$(thefuck --alias $ansr)\n" >>~/.bashrc
    fi
    unset ansr
fi
