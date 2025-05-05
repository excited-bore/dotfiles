#!/bin/bash

SYSTEM_UPDATED='TRUE'

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

printf "Output ${GREEN}'locale'${normal}:\n"
locale
echo

readyn -p 'Switch locale?' swtch
if [[ "$swtch" == 'y' ]]; then
    all=$(locale -a)
    if type fzf &> /dev/null; then
        lcle=$(echo "$all" | fzf --reverse --query 'utf8' --height 50%)
    else
        readyn -p 'Only look for UTF8 based locale?' swtch
        if [[ "$swtch" == 'y' ]]; then
           all=$(echo "$all" | grep --color=never 'utf8') 
        fi
        echo "$all" | column -c ${COLUMNS} | less -N --line-num-width=3
        reade -Q 'GREEN' -i "$all" -p 'Which one?: ' lcle
    fi
    if test -n "$lcle"; then
        readyn -p "Switch LANG to '$lcle'?" swtch
        if [[ "$swtch" == 'y' ]]; then
            if hash update-locale &> /dev/null; then
                sudo update-locale LANG=$lcle LANGUAGE
            else 
                sudo localectl set-locale LANG=$lcle 
            fi
        fi
    else
        echo "Supplied locale is empty. Skipping locale change.."
    fi
fi

printf "Output ${GREEN}'localectl'${normal}:\n"
localectl
echo
