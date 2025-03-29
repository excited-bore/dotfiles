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


if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh)"
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi

if ! [ -e ~/.bash_completion.d/complete_alias ]; then
    curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias 1>~/.bash_completion.d/complete_alias
    if test -f ~/.bash_aliases; then
        if grep -q '!BASH_ALIASES' ~/.bash_aliases; then
            sed -i 's|.*complete -F|complete -F|g' ~/.bash_aliases
        else
            echo 'complete -F _complete_alias "${!BASH_ALIASES[@]}"' >>~/.bash_aliases
        fi
    elif ! grep -q '!BASH_ALIASES' ~/.bashrc; then
        echo 'complete -F _complete_alias "${!BASH_ALIASES[@]}"' >>~/.bashrc
    fi
fi

readyn -p "Install bash completions for aliases in /root/.bash_completion.d?" rcompl
if [ -z $rcompl ] || [[ "y" == $rcompl ]]; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install 'complete_alias' in '/root/.bash_completion.d/'"

    if ! sudo test -e /root/.bash_completion.d/complete_alias; then
        curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias | sudo tee /root/.bash_completion.d/complete_alias &>/dev/null
        sudo sed -i 's/#complete -F _complete_alias "\(.*\)"/complete -F _complete_alias "\1"/g' /root/.bash_completion.d/complete_alias
    fi
    if sudo test -f /root/.bash_aliases; then
        if sudo grep -q '!BASH_ALIASES' /root/.bash_aliases; then
            sudo sed -i 's|.*complete -F|complete -F|g' /root/.bash_aliases
        else
            printf "complete -F _complete_alias \"\${!BASH_ALIASES[@]}\"\n" | sudo tee -a /root/.bash_aliases >/dev/null
        fi
    else
        printf "complete -F _complete_alias \"\${!BASH_ALIASES[@]}\"\n" | sudo tee -a /root/.bashrc >/dev/null
    fi
fi
