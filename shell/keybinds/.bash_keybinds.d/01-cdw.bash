# Cd wrapper because there's no autopushd option like in zsh
function cd-w() {
    
    local push=1
    local j=0
    if [[ "$1" == "--" ]]; then
        shift;
    fi 
    
    # Just give the standard cd error if one argument is no directory 
    for i in $@; do
        if ! [ -d $i ]; then 
            builtin cd -- "$i" 
            return 1
        fi
    done
     
    for i in $(dirs -l 2>/dev/null); do
        if test -e "$i"; then
            if [[ -z "${@}" && "$i" == "$HOME" ]] || [[ "$(realpath ${@: -1:1})" == "$i" ]]; then
                push=0
                pushd -n +$j &>/dev/null
            fi
            j=$(($j+1));
        fi
    done
    if [ $push == 1 ]; then
        pushd "$(pwd)" &>/dev/null;  
    fi
    builtin cd -- "$@"; 
    return 0 
}

alias cd='cd-w'
