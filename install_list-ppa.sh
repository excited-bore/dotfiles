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

if ! type list-ppa &> /dev/null || [[ $(pipx list 2> /dev/null | grep list-ppa | awk '{print $4}') =~ 'C:' ]] then
    printf "${CYAN}list-ppa${normal} is not installed (python cmd tool for listing ppas from 'launchpad.net'\n"
    readyn -p "Install list-ppa?" ppa_ins
    if [[ $ppa_ins == 'y' ]]; then
        if ! type pipx &> /dev/null; then
            if ! test -f install_pipx.sh; then
                source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh) 
            else
                . ./install_pipx.sh
            fi  
        fi

        if ! type pipx &> /dev/null && test -f $HOME/.local/bin/pipx; then 
            $HOME/.local/bin/pipx install list-ppa 
        elif type pipx &> /dev/null; then 
            pipx install list-ppa
        fi

        if ! test -f ~/.config/ppas; then 
            readyn -p "Run list-ppa (generates file containin ppas that have a release file for your version in ~/.config/ppas - !! Can take a while - can be rerun)?" ppa_ins
            if [[ $ppa_ins == 'y' ]]; then
                if ! type list-ppa &> /dev/null || [[ $(pipx list 2> /dev/null | grep list-ppa | awk '{print $4}') =~ 'C:' ]]; then
                    lspp="$(pipx list 2> /dev/null | grep venvs | awk '{print $4}')\list-ppa"
		    #lspp="$(pipx list 2> /dev/null | grep venvs | awk '{print $4}' | dos2unix)\list-ppa"
                    $lspp --file ~/.config/ppas
		    unset $lspp
                else
                    list-ppa --file ~/.config/ppas
                fi
            fi 
        fi 
    fi
    unset ppa_ins 
fi

