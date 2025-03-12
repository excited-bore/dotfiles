#!/bin/bash

test -z "$PAGER" && type less &> /dev/null && PAGER="$(whereis less | awk '{print $2}')"

alias list-commands-bash="compgen -c | $PAGER"
alias list-keywords-bash="compgen -k | $PAGER"
alias list-builtins-bash="compgen -b | $PAGER"
alias list-aliases-bash="compgen -a | $PAGER"
alias list-users-bash="compgen -u | $PAGER"
alias list-functions-bash="compgen -A function | $PAGER"
alias list-function-content-bash="declare -f"
alias list-directory-bash="compgen -d | $PAGER"
alias list-groups-bash="compgen -g | $PAGER"
alias list-services-bash="compgen -s | $PAGER"
alias list-exports-bash="compgen -e | $PAGER"
alias list-shellvars-bash="compgen -v | $PAGER"
alias list-file-and-dirs-bash="compgen -f | $PAGER"

_commands(){
    COMPREPLY=($(compgen -c -- ${2}))
    return 0
}

_builtins(){
    COMPREPLY=($(compgen -b -- ${2}))
    return 0
}

_files(){
    comptopt -o filenames 2>/dev/null 
    COMPREPLY=($(compgen -f -- ${2}))
    return 0
}

_users(){
    COMPREPLY=($(compgen -u -- ${2}))
    return 0
}

_groups(){
    COMPREPLY=($(compgen -g -- ${2}))
    return 0
}

man-bash(){
    help -m $@ | $MANPAGER;
}

complete -F _builtins man-bash
