alias r=". ~/.bashrc"

alias list_commands_bash="compgen -c | $PAGER"
alias list_keywords_bash="compgen -k | $PAGER"
alias list_builtins_bash="compgen -b | $PAGER"
alias list_aliases_bash="compgen -a | $PAGER"
alias list_users_bash="compgen -u | $PAGER"
alias list_functions_bash="compgen -A function | $PAGER"
alias list_directory_bash="compgen -d | $PAGER"
alias list_groups_bah="compgen -g | $PAGER"
alias list_services_bash="compgen -s | $PAGER"
alias list_exports_bash="compgen -e | $PAGER"
alias list_shellvars_bash="compgen -v | $PAGER"
alias list_file_and_functions_bash="compgen -f | $PAGER"

_commands(){
    COMPREPLY=($(compgen -c $2))
    return 0
}

_builtins(){
    COMPREPLY=($(compgen -b $2))
    return 0
}

_files(){
    COMPREPLY=($(compgen -f $2))
    return 0
}

_users(){
    COMPREPLY=($(compgen -u $2))
    return 0
}

_groups(){
    COMPREPLY=($(compgen -g $2))
    return 0
}

man-bash(){
    help -m $@ | $MANPAGER;
}

complete -F _builtins man-bash
