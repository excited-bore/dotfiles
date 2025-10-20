__get_all_units1(){
 { SYSTEMD_COLORS=0 __systemctl $1 list-unit-files  --legend=false "$2*"
   SYSTEMD_COLORS=0 __systemctl $1 list-units --all --legend=false "$2*"
 } |
 { while read -r a b
   do echo " $a"
   done
 }
}

complete -F __get_all_units1 systemctl-find-service-file


_system-service-start(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_startable_units --system "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _system-service-start system-service-start

_service-start(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_startable_units --user "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _service-start service-start

_system-service-restart(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_stoppable_units --system "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _system-service-restart system-service-restart

_service-restart(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_stoppable_units --system "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _service-restart service-restart

_system-service-enable-now(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_stoppable_units --system "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _system-service-enable-now system-service-enable-now

_service-enable-now(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_stoppable_units --system "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _service-enable-now service-enable-now

