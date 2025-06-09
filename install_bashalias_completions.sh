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

SCRIPT_DIR=$(get-script-dir)


if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh)
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi

if ! [ -e ~/.bash_completion.d/complete_alias ]; then
    curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias 1> ~/.bash_completion.d/complete_alias
    sed -i 's/#complete -F _complete_alias "\(.*\)"/complete -F _complete_alias "\1"/g' ~/.bash_completion.d/complete_alias
    
fi
if test -f $BASH_ALIAS; then
    if grep -q '_complete_alias' $BASH_ALIAS; then
        sed -i 's|.*complete -F _complete_alias|complete -F _complete_alias|g' $BASH_ALIAS
    else
        echo 'complete -F _complete_alias "${!BASH_ALIASES[@]}"' >> $BASH_ALIAS
    fi
    if ! grep -q 'function unalias' $BASH_ALIAS; then
        readyn -p "Make an unalias wrapper so everytime you unalias a command using 'unalias', it also checks what commands still need autocompletion? (Helps avoiding errors when unaliasing a command, then using autocompletion)" unalias_w
        if [[ $unalias_w == 'y' ]]; then
            printf "\nfunction unalias(){\n\tcommand unalias \$@\n\twhile read -r line; do\n\t\tif [[ \$(echo \"\$line\" | awk '\$2 == \"-F\" { print \$3 }') =~ \"_complete_alias\" ]]; then\n\t\tlocal cmd=\$(echo \"\$line\" | awk '{print \$NF}')\n\t\tif ! [[ \$(type \$cmd 2> /dev/null) =~ \"alias\" ]]; then\n\t\t\tcomplete -r \$cmd\n\t\tfi\n\tfi\n\tdone < <(complete -p)\n}" >> $BASH_ALIAS 
        fi
    fi
    unset unalias_w 
fi

readyn -p "Install bash completions for aliases in /root/.bash_completion.d?" rcompl
if [[ "y" == $rcompl ]]; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install 'complete_alias' in '/root/.bash_completion.d/'"

    if ! sudo test -e /root/.bash_completion.d/complete_alias; then
        curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias | sudo tee /root/.bash_completion.d/complete_alias 1>/dev/null
        sudo sed -i 's/#complete -F _complete_alias "\(.*\)"/complete -F _complete_alias "\1"/g' /root/.bash_completion.d/complete_alias
    fi
    if sudo test -f $BASH_ALIAS_R; then
        if sudo grep -q '_complete_alias' $BASH_ALIAS_R; then
            sudo sed -i 's|.*complete -F _complete_alias|complete -F _complete_alias|g' $BASH_ALIAS_R
        else
            printf "complete -F _complete_alias \"\${!BASH_ALIASES[@]}\"\n" | sudo tee -a $BASH_ALIAS_R 1> /dev/null
        fi
    else
        sudo touch $BASH_ALIAS_R
        printf "complete -F _complete_alias \"\${!BASH_ALIASES[@]}\"\n" | sudo tee -a $BASH_ALIAS_R 1> /dev/null
    fi
    if ! sudo grep -q 'function unalias' $BASH_ALIAS_R; then
        readyn -Y 'YELLOW' -p "Make an unalias wrapper for root (as well) so everytime you unalias a command using 'unalias', it also checks what commands still need autocompletion? (Helps avoiding errors when unaliasing a command, then using autocompletion)" unalias_w
        if [[ $unalias_w == 'y' ]]; then
            printf "\nfunction unalias(){\n\tcommand unalias \$@\n\twhile read -r line; do\n\t\tif [[ \$(echo \"\$line\" | awk '\$2 == \"-F\" { print \$3 }') =~ \"_complete_alias\" ]]; then\n\t\tlocal cmd=\$(echo \"\$line\" | awk '{print \$NF}')\n\t\tif ! [[ \$(type \$cmd 2> /dev/null) =~ \"alias\" ]]; then\n\t\t\tcomplete -r \$cmd\n\t\tfi\n\tfi\n\tdone < <(complete -p)\n}" | sudo tee -a $BASH_ALIAS_R 1> /dev/null 
        fi
    fi
fi
