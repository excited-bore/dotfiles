alias bash_list_commands="compgen -c | $PAGER"
alias bash_list_keywords="compgen -k | $PAGER"
alias bash_list_builtins="compgen -b | $PAGER"
alias bash_list_aliases="compgen -a | $PAGER"
alias bash_list_user_aliases="compgen -u | $PAGER"
alias bash_list_functions="compgen -A function | $PAGER"
alias bash_list_directory="compgen -d | $PAGER"
alias bash_list_groups="compgen -g | $PAGER"
alias bash_list_services="compgen -s | $PAGER"
alias bash_list_exports="compgen -e | $PAGER"
alias bash_list_shellvars="compgen -v | $PAGER"
alias bash_list_file_and_functions="compgen -f | $PAGER"

_commands(){
    COMPREPLY=($(compgen -c $2))
    return 0
}

_files(){
    COMPREPLY=($(compgen -f $2))
    return 0
}

_groups(){
    COMPREPLY=($(compgen -g $2))
    return 0
}
