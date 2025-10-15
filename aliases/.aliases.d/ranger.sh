#!/bin/bash --norc

#Source
#https://github.com/ranger/ranger/issues/1554

#https://github.com/JohanChane/ranger-quit_cd_wd

# Ranger 
#alias ranger='ranger 2> /dev/null'
if [ -n "$RANGER_LEVEL" ]; then 
    export PS1="[ranger]$PS1"; 
fi

#function ranger {
#    local IFS=$'\t\n'
#    local tempfile="$(mktemp -t tmp.XXXXXX)"
#    local ranger_cmd=(
#        command
#        ranger
#        --cmd="map q chain shell echo %d > "$tempfile"; quitall"
#    )
#    
#    ${ranger_cmd[@]} "$@"
#    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
#        cd -- "$(cat "$tempfile")"; 
#    fi
#    command rm -f -- "$tempfile" 2>/dev/null
#    clear;
#}
