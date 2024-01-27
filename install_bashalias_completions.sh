#!/bin/bash
. ./readline/rlwrap_scripts.sh
. ./checks/check_completions_dir.sh


if [ ! -e ~/.bash_completion.d/complete_alias ]; then
    curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias > ~/.bash_completion.d/complete_alias 2> /dev/null
    sed -i 's/#complete -F _complete_alias "\(.*\)"/complete -F _complete_alias "\1"/g' ~/.bash_completion.d/complete_alias
fi
#if ! grep -q "~/.bash_completion.d/complete_alias" ~/.bashrc; then
#    echo ". ~/.bash_completion.d/complete_alias" >> ~/.bashrc
#fi

reade -Q "YELLOW" -i "y" -p "Install bash completions for aliases in /root/.bash_completion.d? [Y/n]:" "y n" rcompl
if [ -z $rcompl ] || [ "y" == $rcompl ]; then
    if ! sudo test -d /root/.bash_completion.d/ ; then 
        sudo mkdir /root/.bash_completion.d
    fi
    if ! sudo test -e /root/.bash_completion.d/complete_alias ; then
        curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias | sudo tee /root/.bash_completion.d/complete_alias 2> /dev/null
        sudo sed -i 's/#complete -F _complete_alias "\(.*\)"/complete -F _complete_alias "\1"/g' /root/.bash_completion.d/complete_alias
    fi
   # if ! sudo grep -q "~/.bash_completion.d/complete_alias" /root/.bashrc; then
   #     printf "\n. ~/.bash_completion.d/complete_alias\n" | sudo tee -a /root/.bashrc
   # fi
fi
