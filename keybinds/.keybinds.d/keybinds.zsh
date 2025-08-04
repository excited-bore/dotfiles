#!/bin/zsh

# Bash_aliases at ~/.bash_aliases.d/
# global bashrc -> /etc/bash.bashrc
# root shell profiles -> /etc/profile

# https://stackoverflow.com/questions/8366450/complex-keybinding-in-bash

alias list-binds-zsh="bindkey -l"
alias list-binds-stty="stty -a"
alias list-binds-xterm="xrdb -query -all"
alias list-binds-kitty='kitty +kitten show_key -m kitty'

if hash xfconf-query &> /dev/null; then
    function list-binds-xfce4(){
        local usedkeysp="$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' | sort -V)"
        local usedkeysp1="$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' | sort -V)" 
        
        (printf "${GREEN}Known ${CYAN}xfce4${GREEN} keybinds: \n${normal}"
        for i in $(seq 2); do
            local var1; 
            if [[ $i == 1 ]]; then
                var1=($(echo "$usedkeysp" | awk '{print $1}'))
                printf "\n${GREEN}Window Manager shortcuts: \n\n${normal}"
            else 
                usedkeysp=$usedkeysp1 
                var1=($(echo "$usedkeysp1" | awk '{print $1}'))
                printf "\n${GREEN}Application Shortcuts: \n\n${normal}"
            fi
            for i in ${!var1[@]}; do
                printf "%-35s %-35s\n" "${green}${var1[$i]}" "${cyan}$(awk 'NR=='$((i+1))'{$1="";print;}' <<< $usedkeysp | sed 's/^ //')${normal}"; 
            done
        done) | $PAGER
    }
fi



# TTY

# To see the complete character string sent by a key, you can use this command, and type the key within 2 seconds:
# stty raw; sleep 2; echo; stty cooked
# But Ctrl-v, then keycombination still works best

# Turn off flow control and free up Ctrl-s and Ctrl-q
stty -ixon
stty -ixoff
stty start 'undef'
stty stop 'undef'

# Unset redraw current line (Default C-r).
# stty rprnt 'undef'

# Unset quoted insert from (Default C-v)
stty lnext 'undef'

# Unset suspend signal shortcut (Default Ctrl+z)
stty susp 'undef'

# Unset backward word erase shortcut (Default Ctrl+w)
stty werase 'undef'

# unbinds ctrl-c and bind the function to ctrl-s
#stty intr '^c'

# XRESOURCES

# Install bindings from xterm
# xrdb -merge ~/.Xresources
# .Inputrc (readline conf) however has to be compiled, so restart shell

[[ $machine == 'Linux' ]] && [[ -z $XDG_SESSION_TYPE ]] &&
    XDG_SESSION_TYPE="$(loginctl show-session $(loginctl | grep $(whoami) | awk 'NR=1{print $1}') -p Type | awk -F= 'NR==1{print $2}')"

if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then
    # Set caps to Escape
    setxkbmap -option caps:escape

    # Set Shift delete to backspace
    xmodmap -e "keycode 119 = Delete BackSpace"
fi

# READLINE

# \C : Ctrl
# \M : Meta (alt)
# \e : Escape (alt)
# \t : Tab
# \b : Backspace
# \n : newline
# nop => no operation, but 'redraw-current-line' might work better
# https://unix.stackexchange.com/questions/556703/how-to-bind-a-key-combination-to-null-in-inputrc
# 'bind -l' for all options
# 'bind -p' for all bindings
# You can also run 'read' (or 'cat' + Ctrl+v)
# That way you can read the characters escape sequences
# The ^[ indicates an escape character in your shell, so this means that your f.ex. Home key has an escape code of [1~ and you End key has an escape code of [4~. Since these escape codes are not listed in the default Readline configuration, you will need to add them: \e[1~ or \e[4~
# It's good to use unused keys for complex keybindings since you can't combine readline commands with regular bash expressions in the same bind
# Also
# https://unix.stackexchange.com/questions/548726/bash-readline-inputrc-bind-key-to-a-sequence-of-multiple-commands
#
#
# Change editing mode
#bindkey -a '"\C-a": emacs-editing-mode'
#bind -m vi-insert '"\C-a": emacs-editing-mode'
#bindkey -e '"\C-a": vi-editing-mode'

# Up and down arrow will now intelligently complete partially completed
# commands by searching through the existing history.
bindkey -e "\e[A" 'history-search-backward'
bindkey -a "\e[A" 'history-search-backward'
bindkey -v "\e[A" 'history-search-backward'

bindkey -e "\e[B" 'history-search-forward'
bindkey -a "\e[B" 'history-search-forward'
bindkey -v "\e[B" 'history-search-forward'

# Control left/right to jump from bigwords (ignore spaces when jumping) instead of chars
bindkey -e '\e[1;5D' 'vi-backward-word'
bindkey -a '\e[1;5D' 'vi-backward-word'
bindkey -v '\e[1;5D' 'vi-backward-word'

bindkey -e '\e[1;5C' 'vi-forward-word'
bindkey -a '\e[1;5C' 'vi-forward-word'
bindkey -v '\e[1;5C' 'vi-forward-word'

# Full path dirs
alias dirs="dirs -l"
alias dirs-col="dirs -v | column -c $COLUMNS"
alias dirs-col-pretty="dirs -v | column -c $COLUMNS | sed -e 's/ 0 \\([^\t]*\\)/'\${GREEN}' 0 \\1'\${normal}'/'"

#'Silent' clear
if hash starship &>/dev/null && grep -q "^eval \"\$(starship init bash)\"" ~/.bashrc && (grep -q '\\n' ~/.config/starship.toml || (grep -q 'line_break' ~/.config/starship.toml && ! pcregrep -qM "[line_break]\$(.|\n)*^disabled = true" ~/.config/starship.toml)); then
    function clr1(){ tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null }
    function clr2(){ tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i < $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && dirs-col-pretty && history -d -1 &>/dev/null }
elif hash starship &>/dev/null && grep -q "^eval \"\$(starship init bash)\"" ~/.zshrc; then
    function clr1(){ tput cuu1 && tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null }
    function clr2(){ tput cuu1 && tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i < $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && tput cuu1 && dirs-col-pretty && tput rc && history -d -1 &>/dev/null }
else
    function clr1(){ tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null }
    function clr2(){ tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i <= $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && dirs-col-pretty && tput rc && history -d -1 &>/dev/null }
fi

zle -N clr1
zle -N clr2

updir(){
    pushd +1 &>/dev/null
    zle beginning-of-line
    zle clr2
}

zle -N updir

# 'dirs' builtins shows all directories in stack
# Ctrl-Up arrow rotates over directory history
bindkey -e '\e[1;5A' updir
bindkey -a '\e[1;5A' updir
bindkey -v '\e[1;5A' updir

# Ctrl-Down -> Dir Down
#bindkey -s '"\e266": pushd $(dirs -p | awk '\''END { print }'\'') &>/dev/null\n'
bindkey '\e266' 'cd ..'
bindkey -e "\e[1;5B" "\C-e\C-u\e266 _.\C-m"
bindkey -a "\e[1;5B" "ddi\C-u\e266 _.\C-m"
bindkey -v "\e[1;5B" "\eddi\e266 _.\C-m"

# Ctrl-Down -> Rotate between 2 last directories
#bindkey -s '"\e266": pushd -1 &>/dev/null\n'
#bindkey -e '"\e[1;5B": "\C-e\C-u\e266 _.\C-m"'
#bindkey -a     '"\e[1;5B": "ddi\C-u\e266 _.\C-m"'
#bindkey -v      '"\e[1;5B": "\eddi\e266 _.\C-m"'

# Shift left/right to jump from words instead of chars

# EEEEEUUUUUUH BASH REGEX?????
# https://unix.stackexchange.com/questions/421460/bash-regex-and-https-regex101-com

# This explains a ton
# https://unix.stackexchange.com/questions/251013/bash-regex-capture-group


global_rematch() { 
    local s=$1 regex=$2 

    # https://stackoverflow.com/questions/10582763/how-to-return-an-array-in-bash-without-using-globals
    local -n array=$3
    array=()
    
    while [[ $s =~ $regex ]]; do 
        array+=("${BASH_REMATCH[0]}")
        s=${s#*"${BASH_REMATCH[0]}"}
    done
}

unset_array(){
    local -n array=$1
    local indx
    if test -z $2; then
        indx=0
    else
        indx=$2
    fi
    local new_array
    for i in "${!array[@]}"; do
        if ! [[ $i == $indx ]]; then
            new_array+=( "${array[$i]}" )
        fi
    done
    array=("${new_array[@]}")
    unset new_array
}

TRANSPOSE_QUOTED=1

transpose_words() {
    local wordsorspace='space' 
    if test -n "$1" && ! [[ "$1" == 'space' ]]; then
        wordsorspace='words' 
    fi
    
    local directn='left'
    if test -n "$2" && ! [[ "$2" == 'left' ]]; then
        directn='right' 
    fi

    local only_exclude_spaces='[^[:space:]]+'
    local include_only_alphanums='[A-Za-z0-9]+' 

    local notquotedspace_exclude_space='("[^"]*")+|('\''[^'\'']*'\'')+|[^[:space:]]+' 
   
    local words 
    if [[ "$wordsorspace" == 'space' ]]; then 
        [[ $TRANSPOSE_QUOTED ]] && 
            words=$notquotedspace_exclude_space || 
            words=$only_exclude_spaces
    else
        words=$include_only_alphanums
    fi

    local only_include_spaces='[[:space:]]+'  
    local exclude_only_aphanums='[^A-Za-z0-9]+' 
   
    local non_words
    if [[ "$wordsorspace" == 'space' ]]; then
        non_words=$only_include_spaces
    else
        non_words=$exclude_only_aphanums   
    fi 

    local firstnonspaceword='^([^[:space:]]+)' 
    local firstalphanumericword='^([A-Za-z0-9]+)'

    local quotedfirstnonspaceword='^(("[^"]*"+|'\''[^'\'']*'\''+)*[^[:space:]]+)' 

    local firstwordpattrn
    if [[ "$wordsorspace" == 'space' ]]; then
        [[ $TRANSPOSE_QUOTED ]] && 
            firstwordpattrn=$quotedfirstnonspaceword || 
            firstwordpattrn=$firstnonspaceword
    else
        firstwordpattrn=$firstalphanumericword   
    fi


    local tolastnonspaceword='[[:space:]]+[^[:space:]]+$'

    local tolastalphanumericword='[^A-Za-z0-9]+[A-Za-z0-9]+$' 

    local tolastwordpattrn
    if [[ "$wordsorspace" == 'space' ]]; then
        tolastwordpattrn=$tolastnonspaceword  
    else
        tolastwordpattrn=$tolastalphanumericword   
    fi    
    
    local arr arrr line
   
    # Checks leading and trailing spaces, for escaped spaced words which it quotes using '', then exit
    local re='(([^[:space:]'\'']*\\ )+[^[:space:]'\'']*)'
    if [[ "${READLINE_LINE}" =~ $re ]] || [[ "${READLINE_LINE: -1}" == ' ' ]] || [[ ${READLINE_LINE:0:1} == ' ' ]]; then
         
        local quoteds
        global_rematch "${READLINE_LINE}" "$re" quoteds 

        while [[ "${READLINE_LINE}" =~ $re ]] || [[ "${READLINE_LINE: -1}" == ' ' ]] || [[ ${READLINE_LINE:0:1} == ' ' ]]; do

            # Remove leading whitespace
            if [[ "${READLINE_LINE:0:1}" == ' ' ]]; then
                READLINE_LINE="${READLINE_LINE:1}" 
            fi

            # Remove trailing whitespace
            if [[ "${READLINE_LINE: -1}" == ' ' ]]; then
                READLINE_LINE="${READLINE_LINE::-1}" 
            fi
            
            # Quoted escaped spaced words
            if [[ "${READLINE_LINE}" =~ $re ]]; then
                local i=${BASH_REMATCH[0]}
                #echo "'$i'" 
                local j="'$(eval "echo $i")'"
                local ree='.*'$(printf %q "$i")''
                
                if [[ $READLINE_LINE =~ $ree ]]; then
                    local suffxcount=$(($(echo "${BASH_REMATCH[0]}" | wc --chars)))
                    local preffxcount=$(($suffxcount - $(echo $i | wc --chars)))
                    #echo "'${BASH_REMATCH[0]}'"
                    #echo "Suffix: '${READLINE_LINE:$suffxcount}'" 
                    #echo "Suffix - 1: '${READLINE_LINE:$((suffxcount - 1))}'" 
                    #echo "Prefix: '${READLINE_LINE:0:$preffxcount}'" 
                    
                    # Idk but if it loops over multiple (similar??) words that need quoting, it miscounts and IDK ive gone over it multiple times im doing this terribleness  
                    if [[ ${#quoteds} -gt 1 ]]; then
                        READLINE_LINE="${READLINE_LINE:0:$preffxcount}$j${READLINE_LINE:$((suffxcount - 1))}" 
                    else
                        READLINE_LINE="${READLINE_LINE:0:$preffxcount}$j${READLINE_LINE:$suffxcount}" 
                    fi
                    #echo $READLINE_LINE 
                fi
            
            fi
        done 
        return 0 
    fi

    global_rematch "${READLINE_LINE}" "$words" arr
    
    local args=${#arr[@]} 
    if [[ $args -gt 1 ]]; then 

        # Chatgpt helped me with this one
        # Use a rare control char as placeholder,
        # then replace double-quoted and single-quoted strings with said placeholder
        
        if [[ "$wordsorspace" == 'space' ]] && [[ $TRANSPOSE_QUOTED ]]; then
            local placeholder=$'\x01'  
            line=$(echo "${READLINE_LINE}" | sed -E 's/"[^"]*"|'\''[^'\'']*'\''/'"$placeholder"'/g') 
        else
            line="${READLINE_LINE}"
        fi

        global_rematch "$line" $non_words arrr
        
        local index=0
        local olderprefix='' oldprefix='' prefix='' olderword='' olderspcl='' lastword=${arr[0]} lastspcl=${arrr[0]} newword=${arr[1]}  
        while ([[ ${#arr[@]} -ge 1 ]] || [[ ${#arrr[@]} -ge 1 ]]); do 
           
            local linechar=${READLINE_LINE:$index:1}

            local charcount=$(($(echo "${arr[0]}" | wc --chars) - 1)) 
            index=$(($index + $charcount)) 
            
            # get the firstword count and the count of the string up to the last alphanumerical 
            local firstword lasttword cntuptolastword

            if [[ $READLINE_LINE =~ $firstwordpattrn ]]; then
                firstword=$(($(echo "${BASH_REMATCH[0]}" | wc --chars) - 1)) 
            fi

            if [[ $READLINE_LINE =~ $tolastwordpattrn ]]; then
                lasttword=$(($(echo "${BASH_REMATCH[0]}" | wc --chars) - 1)) 
                cntuptolastword=$(($(echo "$READLINE_LINE" | wc --chars) - 1 - $lasttword)) 
            fi 

            if [[ "$lastword" =~ "$linechar" ]]; then

                local prfxcnt=$(($(echo "$prefix" | wc --chars) - 1))
                local oldprfxcnt line
                if [[ $index -eq $(($READLINE_POINT - 1)) ]] && [[ $READLINE_POINT == $cntuptolastword ]] && [[ "$directn" == 'right' ]]; then
                    line="$READLINE_LINE"
                    oldprfxcnt=${#READLINE_LINE}
                elif [[ $index -ge $READLINE_POINT ]]; then
                    if test -n "$olderprefix"; then
                        oldprfxcnt=$(($(echo "$olderprefix" | wc --chars) - 1))
                        if [[ "${#arr[@]}" == 1 ]] && [[ "$directn" == 'left' ]]; then
                            line="$olderprefix$newword$olderspcl$lastword" 
                        else 
                            if [[ "$directn" == 'left' ]]; then
                                local lntcnt=$(($(echo "$oldprefix$lastword" | wc --chars) - 1))
                                local suffix=${READLINE_LINE:$lntcnt}
                                line="$olderprefix$lastword$olderspcl$olderword$suffix" 
                            elif [[ $READLINE_POINT -lt $cntuptolastword ]]; then
                                oldprfxcnt=$(($(echo "$oldprefix$newword$lastspcl" | wc --chars) - 1)) 
                                local lntcnt=$(($(echo "$oldprefix$lastword$lastspcl$newword" | wc --chars) - 1))
                                local suffix=${READLINE_LINE:$lntcnt}
                                line="$oldprefix$newword$lastspcl$lastword$suffix" 
                            else
                                [[ "$directn" == 'right' ]] && ! [[ $READLINE_POINT = ${#READLINE_LINE} ]] &&
                                    READLINE_POINT=${#READLINE_LINE}
                                break
                            fi
                        fi
                    else
                        oldprfxcnt=0
                        if test -n "$oldprefix"; then
                            test -z "$olderspcl" && olderspcl="$lastspcl" && lastspcl=${arrr[1]}
                            if [[ "$directn" == 'left' ]]; then
                                local lntcnt=$(($(echo "$lastword$olderspcl$olderword" | wc --chars) - 1))
                                local suffix=${READLINE_LINE:$lntcnt}
                                line="$lastword$olderspcl$olderword$suffix" 
                            else
                                test -z "$prefix" && 
                                    prfxcnt=$(($(echo "${arr[0]}" | wc --chars) - 1))
                                oldprfxcnt=$(($(echo "$olderword$olderspcl$newword$lastspcl" | wc --chars) - 1))
                                local lntcnt=$(($(echo "$olderword$olderspcl$newword$lastspcl$lastword" | wc --chars) - 1))
                                local suffix=${READLINE_LINE:$lntcnt}
                                line="$olderword$olderspcl$newword$lastspcl$lastword$suffix" 
                            fi
                        elif ([[ "$directn" == 'left' ]] && [[ $READLINE_POINT -gt $firstword ]]) || [[ "$directn" == 'right' ]]; then
                            [[ "$directn" == 'right' ]] && 
                                oldprfxcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                            test -z "$prefix" && prfxcnt=$(($(echo "$lastword" | wc --chars) - 1))
                            local wordcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                            local suffix=${READLINE_LINE:$(($wordcnt))}
                            #    line="${READLINE_LINE $lastword$lastspcl$newword$suffix" ||
                            line="$newword$lastspcl$lastword$suffix" 
                        else
                            if [[ "$directn" == 'left' ]]; then
                                local firstwordcnt=$(($(echo "$firstword" | wc --chars)))
                                if [[ $READLINE_POINT == $firstwordcnt ]]; then
                                    local wordcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                                    local suffix=${READLINE_LINE:$(($wordcnt))} 
                                    line="$newword$lastspcl$lastword$suffix" 
                                fi
                                READLINE_POINT=0
                            fi
                            break
                        fi
                    fi
                    local relpoint=$(($READLINE_POINT - $prfxcnt + $oldprfxcnt))
                    READLINE_LINE=$line
                    READLINE_POINT=$relpoint
                    break
                fi

                test -n "$oldprefix" && olderprefix=$oldprefix
                oldprefix=$prefix
                prefix="$prefix${arr[0]}"
                test -z "$oldprefix" && oldprefix=$prefix 
                unset_array arr 0; 
                olderword=$lastword 
                test -n "${arr[1]}" && 
                    lastword=$newword && newword=${arr[1]} ||
                    newword=${arr[0]}
            fi

            
            linechar=${READLINE_LINE:$index:1}
            charcount=$(($(echo "${arrr[0]}" | wc --chars) - 1)) 
            index=$(($index + $charcount))

            if [[ "$lastspcl" =~ "$linechar" ]]; then
                
                if [[ $index -ge $READLINE_POINT ]]; then
                    local oldprfxcnt line prfxcnt=0 relpoint
                    if test -n "$olderprefix"; then
                        prfxcnt=$(($(echo "$olderprefix" | wc --chars) - 1))
                        if [[ "$directn" == 'left' ]] && ([[ "${#arr[@]}" == 1 ]] || [[ $READLINE_POINT == ${#READLINE_LINE} ]] || [[ $READLINE_POINT == ${#arrr[-1]} ]]); then
                            relpoint=$(($(echo "$olderprefix" | wc --chars) - 1)) 
                            local lntcnt=$(($(echo "$olderprefix$lastword$lastspcl$olderword" | wc --chars) - 1))
                            local suffix=${READLINE_LINE:$lntcnt}
                            line="$olderprefix$newword$olderspcl$olderword" 
                        else 
                            if [[ "$directn" == 'left' ]]; then
                                relpoint=$(($(echo "$olderprefix" | wc --chars) - 1)) 

                                local lntcnt=$(($(echo "$olderprefix$lastword$lastspcl$olderword" | wc --chars) - 1))
                                local suffix=${READLINE_LINE:$lntcnt}
                                line="$olderprefix$lastword$lastspcl$olderword$suffix" 
                            elif [[ $READLINE_POINT -lt $cntuptolastword ]]; then 
                                relpoint=$(($(echo "$oldprefix$olderword$lastspcl$newword${arrr[1]}" | wc --chars) - 1)) 
                                local wordcnt=$(($(echo "$oldprefix$olderword$lastspcl$newword${arrr[1]}$lastword" | wc --chars) - 1)) 
                                local suffix=${READLINE_LINE:$wordcnt}
                                line="$oldprefix$olderword$lastspcl$newword${arrr[1]}$lastword$suffix" 
                            else
                                [[ "$directn" == 'right' ]] && ! [[ $READLINE_POINT = ${#READLINE_LINE} ]] &&
                                    READLINE_POINT=${#READLINE_LINE}
                                break
                            fi
                        fi
                    else
                       oldprfxcnt=0
                       if test -n "$oldprefix"; then
                            test -z "$olderspcl" && olderspcl="$lastspcl" && lastspcl="${arrr[1]}"

                            if [[ $READLINE_POINT -ge $cntuptolastword ]] && [[ "$directn" == 'right' ]]; then 
                                line="$READLINE_LINE"
                                relpoint=${#READLINE_LINE}
                            else
                                if [[ "$directn" == 'left' ]]; then
                                    
                                    if [[ ${#arr[@]} == '1' ]]; then
                                        relpoint=0 
                                        local lntcnt=$(($(echo "$olderword" | wc --chars) - 1))
                                        local suffix=${READLINE_LINE:$lntcnt}
                                        line="$lastword$suffix" 
                                    else
                                        relpoint=$(($(echo "$oldprefix" | wc --chars) - 1)) 
                                        local lntcnt=$(($(echo "$olderword$olderspcl$lastword" | wc --chars) - 1))
                                        local suffix=${READLINE_LINE:$lntcnt}
                                        line="$olderword$olderspcl$lastword$suffix" 
                                    fi
                                else
                                    relpoint=${#READLINE_LINE}
                                    line="$READLINE_LINE" 
                                fi
                            fi
                        elif [[ "$directn" == 'right' ]] || ([[ "$directn" == 'left' ]] && [[ $READLINE_POINT -gt $firstword ]]); then
                            oldprfxcnt=$(($(echo "$lastword" | wc --chars) - 1)) &&
                            prfxcnt=$(($(echo "$prefix$lastspcl" | wc --chars) - 1))
                            local wordcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                            local suffix=${READLINE_LINE:$(($wordcnt))}
                            line="$newword$lastspcl$lastword$suffix" 
                        else
                            [[ "$directn" == 'left' ]] && ! [[ $READLINE_POINT = 0 ]] &&
                                READLINE_POINT=0
                            break
                        fi

                    fi
                    ! [[ $relpoint ]] && relpoint=$(($READLINE_POINT - $prfxcnt))
                    READLINE_LINE=$line
                    READLINE_POINT=$relpoint
                    break
                fi
                olderspcl="$lastspcl" 
                prefix="$prefix$lastspcl"
                oldprefix=$prefix
                unset_array arrr 0; 
                test -n "${arrr[0]}" && lastspcl="${arrr[0]}"; 
            fi
        done
    fi
    unset arr arrr
}

#zle -N transpose_words

# Transpose space-separated words on Shift Left/Right

#bindkey -e -s '\e[1;2D' 'transpose_words space left'
#bindkey -a -s '\e[1;2D' 'transpose_words space left'
#bindkey -v -s '\e[1;2D' 'transpose_words space left'
#
#bindkey -e -s "\e[1;2C" 'transpose_words space right'
#bindkey -a -s "\e[1;2C" 'transpose_words space right'
#bindkey -v -s "\e[1;2C" 'transpose_words space right'
#
## Transpose special character separated words on Alt+Shift Left/Right
#
#bindkey -e -s "\e[1;4D" 'transpose_words words left'
#bindkey -a -s "\e[1;4D" 'transpose_words words left'
#bindkey -v -s "\e[1;4D" 'transpose_words words left'
#
#bindkey -e -s "\e[1;4C" 'transpose_words words right'
#bindkey -a -s "\e[1;4C" 'transpose_words words right'
#bindkey -v -s "\e[1;4C" 'transpose_words words right'


alias __='clear && tput cup $(($LINE_TPUT+1)) $TPUT_COL && tput sc && tput cuu1 && echo "${PS1@P}" && tput cuu1'

# Shift up => Clean reset
#bindkey -s '"\e288": "cd \C-i\n"'
bindkey -s "\e288" "__\n"
bindkey -e '"\e[1;2A": "\C-e\C-u\e288"'
bindkey -a '"\e[1;2A": "ddi\e288"'
bindkey -v '"\e[1;2A": "\eddi\e288"'

# Shift down => cd shortcut
bindkey -e '"\e[1;2B": "\C-e\C-u\e288cd \C-i"'
bindkey -v '"\e[1;2B": "\eddi\e288cd \C-i"'
bindkey -a '"\e[1;2B": "\eddi\e288cd \C-i"'

# Shift left/right to jump from bigwords (ignore spaces when jumping) instead of chars
#bindkey -e -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -a     -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -v      -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#
#bindkey -e -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -a     -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -v      -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'

# Alt left/right to jump to beginning/end line instead of chars
bindkey -e '"\e[1;3D": beginning-of-line'
bindkey -a '"\e[1;3D": beginning-of-line'
bindkey -v '"\e[1;3D": beginning-of-line'

bindkey -e '"\e[1;3C": end-of-line'
bindkey -a '"\e[1;3C": end-of-line'
bindkey -v '"\e[1;3C": end-of-line'

# Alt up/down to change cursor line
function mv_prmpt_up(){ 
    clear 
    let LINE_TPUT=$LINE_TPUT-1
    if [ $LINE_TPUT -lt 0 ]; then 
        let LINE_TPUT=$LINES;
    fi 
    tput cup $LINE_TPUT $COL_TPUT
    zle reset-prompt
    tput sc }
zle -N mv_prmpt_up
bindkey -a "\e[1;3A" mv_prmpt_up
bindkey -e "\e[1;3A" mv_prmpt_up
bindkey -v "\e[1;3A" mv_prmpt_up


function mv_prmpt_dwn(){ 
    clear 
    let LINE_TPUT=$LINE_TPUT+1
    if [ $LINE_TPUT -gt $LINES ];then 
        let LINE_TPUT=0;
    fi 
    tput cup $LINE_TPUT $COL_TPUT
    zle reset-prompt
    tput sc }
zle -N mv_prmpt_dwn
bindkey -e "\e[1;3B" mv_prmpt_dwn
bindkey -a "\e[1;3B" mv_prmpt_dwn
bindkey -v "\e[1;3B" mv_prmpt_dwn
#
# Ctrl-w expands aliases
bindkey -e '"\C-w": history-and-alias-expand-line'
bindkey -a '"\C-w": history-and-alias-expand-line'
bindkey -v '"\C-w": history-and-alias-expand-line'

# Expand by looping through options
bindkey -e 'Tab: menu-complete'
bindkey -a 'Tab: menu-complete'
bindkey -v 'Tab: menu-complete'

# Shift+Tab for reverse
bindkey -e '"\e[Z": menu-complete-backward'
bindkey -a '"\e[Z": menu-complete-backward'
bindkey -v '"\e[Z": menu-complete-backward'

if [[ "$TERM" == 'xterm-kitty' ]]; then
    # (Kitty only) Ctrl-tab for variable autocompletion
    bindkey -e '"\e[9;5u": possible-variable-completions'
    bindkey -a '"\e[9;5u": possible-variable-completions'
    bindkey -v '"\e[9;5u": possible-variable-completions'

fi


# Ctrl-q quits terminal
bindkey -e -s "\C-q" 'exit\n'
bindkey -a -s "\C-q" 'exit\n'
bindkey -v -s "\C-q" 'exit\n'

# Ctrl+z is vi-undo (after being unbound in stty) instead of only on Ctrl+_
bindkey -e '"\C-z": vi-undo'
bindkey -a '"\C-z": vi-undo'
bindkey -v '"\C-z": vi-undo'

# Ctrl-backspace deletes (kills) line backward
bindkey -e '"\C-h": backward-kill-word'
bindkey -a '"\C-h": backward-kill-word'
bindkey -v '"\C-h": backward-kill-word'

# Ctrl-l clears
bindkey -e -s '\C-l' '__'
bindkey -a -s '\C-l' '__'
bindkey -v -s '\C-l' '__'

# Ctrl-d: Delete first character on line
bindkey -e '"\C-d": "\C-a\e[3~"'
bindkey -a '"\C-d": "\e[1;3D\e[3~"'
bindkey -v '"\C-d": "\e[1;3D\e[3~"'

# Ctrl+b: (Ctrl+x Ctrl+b emacs mode) is quoted insert - Default Ctrl+v - Gives (f.ex. 'Ctrl-a') back as '^A'
bindkey -e '"\C-x\C-b": quoted-insert'
bindkey -a '"\C-b": quoted-insert'
bindkey -v '"\C-b": quoted-insert'

# Ctrl+o: Change from vi-mode to emacs mode and back
# This is also configured in ~/.fzf/shell/key-bindings-bash.sh if you have fzf keybinds installed
bindkey -a '"\C-o": emacs-editing-mode'
bindkey -v '"\C-o": emacs-editing-mode'
bindkey -e '"\C-o": vi-editing-mode'

# vi-command ' / emacs C-x ' helps with adding quotes to bash strings
_quote_all() { READLINE_LINE="${READLINE_LINE@Q}"; }
bindkey -e -s '\C-x'\''' '_quote_all'
bindkey -a -s ''\''' '_quote_all'
#bindkey -v -s '\C-x'\''' '_quote_all'

# https://unix.stackexchange.com/questions/85391/where-is-the-bash-feature-to-open-a-command-in-editor-documented
_edit_wo_executing() {
    local editor="${EDITOR:-nano}"
    tmpf="$(mktemp).sh"
    printf "$READLINE_LINE" >"$tmpf"
    $EDITOR "$tmpf"
    # https://stackoverflow.com/questions/6675492/how-can-i-remove-all-newlines-n-using-sed
    #[ "$(sed -n '/^#!\/bin\/bash/p;q' "$tmpf")" ] && sed -i 1d "$tmpf"
    READLINE_LINE="$(<"$tmpf")"
    READLINE_POINT="${#READLINE_LINE}"
    command rm "$tmpf" &>/dev/null
}

bindkey -v -s "\C-e" '_edit_wo_executing'
bindkey -a -s "v" '_edit_wo_executing'
bindkey -a -s "\C-e" '_edit_wo_executing'
bindkey -e -s "\C-e\C-e" '_edit_wo_executing'

# RLWRAP

#if hash rlwrap &> /dev/null; then
#    bindkey -e '"\C-x\C-e" : rlwrap-call-editor'
#    bindkey -a '"\C-e" : rlwrap-call-editor'
#    bindkey -v '"\C-e" : rlwrap-call-editor'
#fi

if hash osc &>/dev/null; then
    
    function osc-copy() {
        echo -n "$READLINE_LINE" | osc copy
    }
    
    function osc-paste() {
        local pasters="$(osc paste)"
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$pasters${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$((READLINE_POINT + ${#pasters}))
    }
    
    bindkey -e -s "\C-s"  'osc-copy\n'
    bindkey -a -s "\C-s"  'osc-copy\n'
    bindkey -v -s "\C-s"  'osc-copy\n'

    # Ctrl-v: Proper paste
    #Q="'"
    #bindkey -s $'"\237": echo bind $Q\\"\\\\225\\": \\"$(osc paste)\\"$Q > /tmp/paste.sh && source /tmp/paste.sh\n'
    bindkey -e -s "\C-v" 'osc-paste\n'
    bindkey -a -s "\C-v" 'osc-paste\n'
    bindkey -v -s "\C-v" 'osc-paste\n'

elif ([[ "$XDG_SESSION_TYPE" == 'x11' ]] && hash xclip &>/dev/null) || ([[ "$XDG_SESSION_TYPE" == 'wayland' ]] && hash wl-copy &> /dev/null); then
  
    function clip-copy() {
        if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then  
            echo -n "$READLINE_LINE" | xclip -i -sel c
        elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
            echo -n "$READLINE_LINE" | wl-copy
        fi
    }

    function clip-paste() {
        
        if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then  
            local pasters="$(xclip -o -sel c)"
        elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
            local pasters="$(wl-paste)"
        fi
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$pasters${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$((READLINE_POINT + ${#pasters}))
    }
    
    # Ctrl-s: Proper copy
    bindkey -e -s "\C-s"  'clip-copy\n'
    bindkey -a -s "\C-s"  'clip-copy\n'
    bindkey -v -s "\C-s"  'clip-copy\n'


    # Ctrl-v: Proper paste
    bindkey -e -s "\C-v": 'clip-paste\n'
    bindkey -a -s "\C-v": 'clip-paste\n'
    bindkey -v -s "\C-v": 'clip-paste\n'

    #Q="'"
    #bindkey -s $'"\237": echo bind $Q\\"\\\\225\\": \\"$(xclip -o -sel c)\\"$Q > /tmp/paste.sh && source /tmp/paste.sh\n'
    #bindkey -e '"\C-v": "\237\225"'
    #bindkey -a     '"\C-v": "\237\225"'
    #bindkey -v      '"\C-v": "\237\225"'
fi

if hash autojump &>/dev/null; then
    # Ctrl-x Ctrl-j for autojump
    bindkey -e '"\C-x\C-j": "j \C-i"'
    bindkey -a '"\C-x\C-j": "j \C-i"'
    bindkey -v '"\C-x\C-j": "j \C-i"'
fi

if hash fzf &>/dev/null; then
    
    #if [[ "$TERM" == 'xterm-kitty' ]]; then
    #    # (Kitty only) Ctrl-tab for fzf autocompletion
    #    bindkey -e '"\e[9;5u": " **\t"'
    #    bindkey -a '"\e[9;5u": " **\t"'
    #    bindkey -v '"\e[9;5u": " **\t"'
    #fi

    if type ripgrep-dir &>/dev/null; then
        # Alt-g: Ripgrep function overview
        bindkey -e -s "\C-g" "ripgrep-dir\n"
        bindkey -a -s "\C-g" "ripgrep-dir\n"
        bindkey -v -s "\C-g" "ripgrep-dir\n"
    fi

    if type fzf_rifle &>/dev/null; then
        # CTRL-F - Paste the selected file path into the command line
        bindkey -e -s "\C-f" 'fzf_rifle\n'
        bindkey -a -s "\C-f" 'fzf_rifle\n'
        bindkey -v -s "\C-f" 'fzf_rifle\n'

        # F4 - Rifle search
        bindkey -e -s "\eOS" "fzf_rifle\n"
        bindkey -a -s "\eOS" "fzf_rifle\n"
        bindkey -v -s "\eOS" "fzf_rifle\n"
    fi
fi

# F2 - ranger (file explorer)
if hash ranger &>/dev/null; then
    bindkey -s '\201' 'ranger\n'
    bindkey -e '"\eOQ": "\201\n\C-l"'
    bindkey -a '"\eOQ": "\201\n\C-l"'
    bindkey -v '"\eOQ": "\201\n\C-l"'
fi

# F3 - lazygit (Git helper)
if hash lazygit &>/dev/null; then
    bindkey -s '\202' 'stty sane && lazygit\n'
    bindkey -e '"\eOR": "\202\n\C-l"'
    bindkey -a '"\eOR": "\202\n\C-l"'
    bindkey -v '"\eOR": "\202\n\C-l"'
fi

# F5, Ctrl-r - Reload .bashrc
#bind '"\205": re-read-init-file;'
bindkey -s '\206' 'source ~/.zshrc\n'
bindkey -e '"\e[15~": "\206"'
bindkey -a '"\e[15~": "\206"'
bindkey -v '"\e[15~": "\206"'

# F6 - (neo/fast/screen)fetch (System overview)
if hash neofetch &>/dev/null || hash fastfetch &>/dev/null || hash screenfetch &>/dev/null || hash onefetch &>/dev/null; then

    # Last one loaded is the winner
    if hash neofetch &>/dev/null; then
        bindkey -s '\207' 'stty sane && neofetch\n'
        fetch="neofetch"
    fi

    if hash screenfetch &>/dev/null; then
        bindkey -s '\207' 'stty sane && screenfetch\n'
        fetch="screenfetch"
    fi

    if hash fastfetch &>/dev/null; then
        bindkey -s '\207' 'stty sane && fastfetch\n'
        fetch="fastfetch"
    fi

    if hash onefetch &>/dev/null; then
        if hash neofetch &>/dev/null || hash fastfetch &>/dev/null || hash screenfetch &>/dev/null; then
            bindkey -s '\207' 'stty sane; hash git &> /dev/null && git rev-parse --git-dir &> /dev/null && readyn -p "Use onefetch? (lists github stats): " gstats && [[ $gstats == "y" ]] && onefetch || '"$fetch"'\n'
        else
            bindkey -s '\207' 'stty sane && '"$fetch"'\n'
        fi
    fi

    bindkey -e '"\e[17~": "\207\n"'
    bindkey -a '"\e[17~": "\207\n"'
    bindkey -v '"\e[17~": "\207\n"'
fi
unset fetch

# F7 - Htop and alternatives

bindkey -s '\208' 'stty sane && readyn -p "Start htop as root?" ansr && [[ "$ansr" == "y" ]] && sudo htop || htop\n'

# Last one loaded is the winner

if hash bashtop &>/dev/null || hash btop &>/dev/null || hash bpytop &>/dev/null; then

    if hash bpytop &>/dev/null; then
        bindkey -s '\208' 'stty sane && readyn -p "Start htop as root?" ansr && [[ "$ansr" == "y" ]] && sudo htop || readyn -p "Use bpytop instead of htop?" ansr && [[ "$ansr" == "y" ]] && bpytop || htop\n'
    fi

    if hash bashtop &>/dev/null; then
        bindkey -s '\208' 'stty sane && readyn -p "Start htop as root?" ansr && [[ "$ansr" == "y" ]] && sudo htop || readyn -p "Use bashtop instead of htop?" ansr && [[ "$ansr" == "y" ]] && bashtop || htop\n'
    fi

    if hash btop &>/dev/null; then
        bindkey -s '\208' 'stty sane && readyn -p "Start btop as root?" ansr && [[ "$ansr" == "y" ]] && sudo btop || btop\n'
    fi

fi

bindkey -e '"\e[18~": "\208\n\C-l"'
bindkey -a '"\e[18~": "\208\n\C-l"'
bindkey -v '"\e[18~": "\208\n\C-l"'

# F8 - Lazydocker (Docker TUI)
if hash lazydocker &>/dev/null; then

    bindkey -s '\209' 'stty sane && lazydocker\n'
    bindkey -e '"\e[19~": "\209\n"'
    bindkey -a '"\e[19~": "\209\n"'
    bindkey -v '"\e[19~": "\209\n"'
fi
