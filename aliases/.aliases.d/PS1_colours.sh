function PS1_update() {
    if ${use_color} ; then
            # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
            #if type -P dircolors >/dev/null ; then
            #	if [[ -f ~/.dir_colors ]] ; then
            #		eval $(dircolors -b ~/.dir_colors)
            #	elif [[ -f /etc/DIR_COLORS ]] ; then
            #		eval $(dircolors -b /etc/DIR_COLORS)
            #	fi
            #fi

            if [[ ${EUID} == 0 ]] ; then
                PS1='\[\033[01;31m\][\h\[\033[01;36m\] $(pwd)\[\033[01;31m\]]\$\[\033[00m\] '
            else
                PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] $(pwd)\[\033[01;32m\]]\$\[\033[00m\] '
            fi
    else
        if [[ ${EUID} == 0 ]] ; then
                # show root@ when we don't have colors
                PS1='\u@\h $(pwd) '
            else
                PS1='\u@\h $(pwd) '
            fi
    fi
}
PROMPT_COMMAND=PS1_update
