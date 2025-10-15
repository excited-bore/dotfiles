_commands(){
    COMPREPLY=($(compgen -c -- ${2}))
    return 0
}

_builtins(){
    COMPREPLY=($(compgen -b -- ${2}))
    return 0
}

_files(){
    COMPREPLY=($(compgen -f -- ${2}))
    return 0
}

_dirs() {
    COMPREPLY=($(compgen -d -- ${2}))
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

_trash(){
    #WORD_ORIG=$COMP_WORDBREAKS
    #COMP_WORDBREAKS=${COMP_WORDBREAKS/:/}
    local cur 
    _get_comp_words_by_ref -n : cur
    COMPREPLY=($(compgen -W "$(gio trash --list | awk '{print $1;}' | sed 's|trash:///|trash\\\:///|g' )" -- "$cur") )
    __ltrim_colon_completions "$cur"
    #COMP_WORDBREAKS=$WORD_ORIG
    return 0
}

complete -F _builtins man-bash

complete -F _cd cd-w
complete -F _cd cp-all-to

if type _fzf_dir_completion &> /dev/null; then
    complete -F _fzf_dir_completion cd
    complete -F _fzf_dir_completion cp-all-to
fi

complete -F _commands refresh refresh-diff

hash viddy &> /dev/null &&
    complete -F _commands viddy

complete -F _files extract
complete -F _files file-insert-after-line
complete -F _files file-put-quotations-around

complete -F _commands edit-whereis  

complete -F _trash trash-list
complete -F _trash trash-restore

complete -F _groups add-to-group

#complete -F _filedir ln-soft
#complete -F _filedir ln-hard
#complete -F _filedir trash

complete -f -o plusdirs -X '!*.@(mp4|m4a|mkv|mp3|ogg)' vlc
