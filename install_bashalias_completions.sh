#!/bin/bash
if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi

if ! test -f checks/check_aliases_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)" 
else
    . ./checks/check_aliases_dir.sh
fi

if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi

if [ ! -e ~/.bash_completion.d/complete_alias ]; then
    curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias > ~/.bash_completion.d/complete_alias 2> /dev/null
    #if test -f ~/.bash_aliases; then
    #    echo 'complete -F _complete_alias "${!BASH_ALIASES[@]}"' >> ~/.bash_aliases
    #else
    #    echo 'complete -F _complete_alias "${!BASH_ALIASES[@]}"' >> ~/.bashrc
    #fi
    echo 'complete -F _complete_alias "${!BASH_ALIASES[@]}"' >> ~/.bashrc
fi

reade -Q "YELLOW" -i "y" -p "Install bash completions for aliases in /root/.bash_completion.d? [Y/n]: " "n" rcompl
if [ -z $rcompl ] || [ "y" == $rcompl ]; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install 'complete_alias' in /root/.bash_completion.d/' "
    
    if ! sudo test -e /root/.bash_completion.d/complete_alias ; then
        curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias | sudo tee /root/.bash_completion.d/complete_alias 2> /dev/null
        sudo sed -i 's/#complete -F _complete_alias "\(.*\)"/complete -F _complete_alias "\1"/g' /root/.bash_completion.d/complete_alias
    fi
    #if sudo test -f /root/.bash_aliases; then
    #    printf "complete -F _complete_alias \"\${!BASH_ALIASES[@]}\"\n" | sudo tee -a /root/.bash_aliases > /dev/null 
    #else
    #    printf "complete -F _complete_alias \"\${!BASH_ALIASES[@]}\"\n" | sudo tee -a /root/.bashrc > /dev/null
    #fi
    printf "complete -F _complete_alias \"\${!BASH_ALIASES[@]}\"\n" | sudo tee -a /root/.bashrc > /dev/null
fi
