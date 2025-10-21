# https://github.com/cykerway/complete-alias

SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


if ! [ -e ~/.bash_completion.d/complete_alias.bash ]; then
    wget-curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias 1> ~/.bash_completion.d/complete_alias.bash
fi

if test -f ~/.bashrc && ! grep -q '^complete -F _complete_alias' ~/.bashrc; then
    if grep -q '\[ -f ~/.bash_keybinds \]' ~/.bashrc; then
        sed -i 's|\(\[ -f \~/.bash_keybinds \] \&\& source \~/.bash_keybinds\)|\1\n\ncomplete -F _complete_alias "${!BASH_ALIASES[@]}"\n|g' ~/.bashrc
    elif grep -q '\[ -f ~/.bash_completion \]' ~/.bashrc; then
        sed -i 's|\(\[ -f \~/.bash_completion \] \&\& [ -z ${BASH_COMPLETION_VERSINFO:-} ] \&\& source \~/.bash_completion\)|\1\n\ncomplete -F _complete_alias "${!BASH_ALIASES[@]}"\n|g' ~/.bashrc
    elif grep -q '\[ -f ~/.bash_aliases \]' ~/.bashrc; then
        sed -i 's|\(\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\1\n\ncomplete -F _complete_alias "${!BASH_ALIASES[@]}"\n|g' ~/.bashrc
    else
        echo 'complete -F _complete_alias "${!BASH_ALIASES[@]}"' >> ~/.bashrc
    fi
    if test -f $BASH_ALIAS && ! grep -q 'function unalias' $BASH_ALIAS; then
        readyn -p "Make an unalias wrapper so everytime you unalias a command using 'unalias', it also checks what commands still need autocompletion? (Helps avoiding errors when unaliasing a command, then using autocompletion)" unalias_w
        if [[ $unalias_w == 'y' ]]; then
            printf "\nfunction unalias(){\n\tcommand unalias \$@\n\twhile read -r line; do\n\t\tif [[ \$(echo \"\$line\" | awk '\$2 == \"-F\" { print \$3 }') =~ \"_complete_alias\" ]]; then\n\t\tlocal cmd=\$(echo \"\$line\" | awk '{print \$NF}')\n\t\tif ! [[ \$(type \$cmd 2> /dev/null) =~ \"alias\" ]]; then\n\t\t\tcomplete -r \$cmd\n\t\tfi\n\tfi\n\tdone < <(complete -p)\n}" >> $BASH_ALIAS 
        fi
    fi
    unset unalias_w 
fi
