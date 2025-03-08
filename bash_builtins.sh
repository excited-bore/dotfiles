
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
