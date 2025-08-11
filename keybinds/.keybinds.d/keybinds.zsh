#!/bin/zsh

# TTY
# https://stackoverflow.com/questions/16727459/what-makes-ctrlq-work-in-zsh

unsetopt flow_control

# XRESOURCES

# Install bindings from xterm
# xrdb -merge ~/.Xresources
# .Inputrc (readline conf) however has to be compiled, so restart shell

if [[ $machine == 'Linux' ]] && [[ -z $XDG_SESSION_TYPE ]]; then
    XDG_SESSION_TYPE="$(loginctl show-session $(loginctl | grep $(whoami) | awk 'NR=1{print $1}') -p Type | awk -F= 'NR==1{print $2}')"
fi

if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then
    # Set caps to Escape
    setxkbmap -option caps:escape

    # Set Shift delete to backspace
    xmodmap -e "keycode 119 = Delete BackSpace"
fi


# Zsh_aliases at ~/.zsh_aliases.d/
# global zshrc -> /etc/zsh.zshrc
# root shell profiles -> /etc/profile


# At default, ZSH starts in emacs-mode
# If EDITOR is set to anything resembling *vi*, it will jump to vi-mode
# Why??? I don't know, but we better be sure and forceably set it to emacs-mode
bindkey -e

# We could also set it to vi-insert mode without the EDITOR being set to vi, vim, nvim...
#bindkey -a

# Or set it straight to vi-cmd mode
#bindkey -v

[[ -z $PAGER ]] && PAGER='less'

alias list-binds-stty="stty -a"
alias list-binds-zsh-emacs="bindkey -M emacs | $PAGER"
alias list-binds-zsh-vi-insert="bindkey -M viins | $PAGER"
alias list-binds-zsh-vi-cmd="bindkey -M vicmd | $PAGER"

function list-binds-zsh(){
    local CYAN=$(tput setaf 6 && tput bold)
    local normal=$(tput sgr0)
     
    (printf "\t${CYAN}Emacs${normal}\n\n" 
    bindkey -M emacs 
    echo

    printf "\t${CYAN}Vi-insert${normal}\n\n" 
    bindkey -M viins
    echo

    printf "\t${CYAN}Vi-cmd${normal}\n\n" 
    bindkey -M vicmd) | $PAGER 

}

if hash xrdb &> /dev/null; then
    alias list-binds-xterm="xrdb -query -all"
fi

if hash kitty &> /dev/null; then
    alias list-binds-kitty='kitty +kitten show_key -m kitty'
fi

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

# ZLE (ZSH line editor)

# \C : Ctrl
# \M : Meta (alt)
# \e : Escape (alt)
# \t : Tab
# \b : Backspace
# \n : newline
# nop => no operation, but 'redraw-current-line' might work better
# https://unix.stackexchange.com/questions/556703/how-to-bind-a-key-combination-to-null-in-inputrc
# 'bindkey -M <emacs/viins/vicmd>' for mode specific bindings
# You can also run 'read' (or 'cat' + Ctrl+v)
# That way you can read the characters escape sequences


# Up and down arrow will now intelligently complete partially completed
# commands by searching through the existing history.
bindkey -M emacs "\e[A" history-search-backward
bindkey -M vicmd "\e[A" history-search-backward
bindkey -M viins "\e[A" history-search-backward

bindkey -M emacs "\e[B" history-search-forward
bindkey -M vicmd "\e[B" history-search-forward
bindkey -M viins "\e[B" history-search-forward

# Control left/right to jump from bigwords (ignore spaces when jumping) instead of chars
bindkey -M emacs '\e[1;5D' vi-backward-word
bindkey -M vicmd '\e[1;5D' vi-backward-word
bindkey -M viins '\e[1;5D' vi-backward-word

bindkey -M emacs '\e[1;5C' vi-forward-word
bindkey -M vicmd '\e[1;5C' vi-forward-word
bindkey -M viins '\e[1;5C' vi-forward-word

# Full path dirs
alias dirs="dirs -l"
alias dirs-col="dirs -v | column -c $COLUMNS"
alias dirs-col-pretty="dirs -v | column -c $COLUMNS | sed -E \"s|^(0\t[^\t]+)|${GREEN}\1${normal}|\""


if hash starship &>/dev/null && grep -q "^eval \"\$(starship init zsh)\"" ~/.zshrc && (grep -q '\\n' ~/.config/starship.toml || (grep -q 'line_break' ~/.config/starship.toml && ! pcregrep -qM "[line_break]\$(.|\n)*^disabled = true" ~/.config/starship.toml)); then
    function clr1(){ tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc }
    function clr2(){ tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i < $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do tput cuu1; done; tput cuu1; tput rc; echoti cr; dirs-col-pretty  }
elif hash starship &>/dev/null && grep -q "^eval \"\$(starship init zsh)\"" ~/.zshrc; then
    function clr1(){ tput cuu1 && tput cuu1 && tput sc; clear && tput rc }
    function clr2(){ tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i < $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do tput cuu1; done; tput cuu1 && tput cuu1; tput rc; echoti cr; dirs-col-pretty }
else
    function clr1(){ tput cuu1 && tput sc; clear && tput rc }
    function clr2(){ tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i <= $(dirs -v | column -c ${COLUMNS} | wc -l) ; i++)); do tput cuu1; done; echoti cr; dirs-col-pretty }
fi

updir(){
    zle beginning-of-line
    pushd +1 &>/dev/null
    clr2
    zle reset-prompt 
}

zle -N updir

# 'dirs' builtins shows all directories in stack
# Ctrl-Up arrow rotates over directory history
bindkey -M emacs '\e[1;5A' updir
bindkey -M vicmd '\e[1;5A' updir
bindkey -M viins '\e[1;5A' updir

# Ctrl-Down -> Dir Down
downdir(){
    # Setting these options saves us from have to use a hacky, selfwritten cd wrapper like in bash
    # localoptions -> options only applicable to function 
    # autopushd -> Make cd push the old directory onto the directory stack. 
    # pushdignoredups -> Ignore duplicates in the directory stack 
    setopt localoptions autopushd pushdignoredups 
    zle beginning-of-line
    cd ..
    clr2
    zle reset-prompt 
}

zle -N downdir
bindkey -M emacs "\e[1;5B" downdir
bindkey -M vicmd "\e[1;5B" downdir
bindkey -M viins "\e[1;5B" downdir

# Ctrl-Down -> Rotate between 2 last directories
#bindkey -s '"\e266": pushd -1 &>/dev/null\n'
#bindkey -M emacs '"\e[1;5B": "\C-e\C-u\e266 _.\C-m"'
#bindkey -M vicmd     '"\e[1;5B": "ddi\C-u\e266 _.\C-m"'
#bindkey -M viins      '"\e[1;5B": "\eddi\e266 _.\C-m"'

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
    if [[ "${BUFFER}" =~ $re ]] || [[ "${BUFFER: -1}" == ' ' ]] || [[ ${BUFFER:0:1} == ' ' ]]; then
         
        local quoteds
        global_rematch "${BUFFER}" "$re" quoteds 

        while [[ "${BUFFER}" =~ $re ]] || [[ "${BUFFER: -1}" == ' ' ]] || [[ ${BUFFER:0:1} == ' ' ]]; do

            # Remove leading whitespace
            if [[ "${BUFFER:0:1}" == ' ' ]]; then
                BUFFER="${BUFFER:1}" 
            fi

            # Remove trailing whitespace
            if [[ "${BUFFER: -1}" == ' ' ]]; then
                BUFFER="${BUFFER::-1}" 
            fi
            
            # Quoted escaped spaced words
            if [[ "${BUFFER}" =~ $re ]]; then
                local i=${BASH_REMATCH[0]}
                #echo "'$i'" 
                local j="'$(eval "echo $i")'"
                local ree='.*'$(printf %q "$i")''
                
                if [[ $BUFFER =~ $ree ]]; then
                    local suffxcount=$(($(echo "${BASH_REMATCH[0]}" | wc --chars)))
                    local preffxcount=$(($suffxcount - $(echo $i | wc --chars)))
                    #echo "'${BASH_REMATCH[0]}'"
                    #echo "Suffix: '${BUFFER:$suffxcount}'" 
                    #echo "Suffix - 1: '${BUFFER:$((suffxcount - 1))}'" 
                    #echo "Prefix: '${BUFFER:0:$preffxcount}'" 
                    
                    # Idk but if it loops over multiple (similar??) words that need quoting, it miscounts and IDK ive gone over it multiple times im doing this terribleness  
                    if [[ ${#quoteds} -gt 1 ]]; then
                        BUFFER="${BUFFER:0:$preffxcount}$j${BUFFER:$((suffxcount - 1))}" 
                    else
                        BUFFER="${BUFFER:0:$preffxcount}$j${BUFFER:$suffxcount}" 
                    fi
                    #echo $BUFFER 
                fi
            
            fi
        done 
        return 0 
    fi

    global_rematch "${BUFFER}" "$words" arr
    
    local args=${#arr[@]} 
    if [[ $args -gt 1 ]]; then 

        # Chatgpt helped me with this one
        # Use a rare control char as placeholder,
        # then replace double-quoted and single-quoted strings with said placeholder
        
        if [[ "$wordsorspace" == 'space' ]] && [[ $TRANSPOSE_QUOTED ]]; then
            local placeholder=$'\x01'  
            line=$(echo "${BUFFER}" | sed -E 's/"[^"]*"|'\''[^'\'']*'\''/'"$placeholder"'/g') 
        else
            line="${BUFFER}"
        fi

        global_rematch "$line" $non_words arrr
        
        local index=0
        local olderprefix='' oldprefix='' prefix='' olderword='' olderspcl='' lastword=${arr[0]} lastspcl=${arrr[0]} newword=${arr[1]}  
        while ([[ ${#arr[@]} -ge 1 ]] || [[ ${#arrr[@]} -ge 1 ]]); do 
           
            local linechar=${BUFFER:$index:1}

            local charcount=$(($(echo "${arr[0]}" | wc --chars) - 1)) 
            index=$(($index + $charcount)) 
            
            # get the firstword count and the count of the string up to the last alphanumerical 
            local firstword lasttword cntuptolastword

            if [[ $BUFFER =~ $firstwordpattrn ]]; then
                firstword=$(($(echo "${BASH_REMATCH[0]}" | wc --chars) - 1)) 
            fi

            if [[ $BUFFER =~ $tolastwordpattrn ]]; then
                lasttword=$(($(echo "${BASH_REMATCH[0]}" | wc --chars) - 1)) 
                cntuptolastword=$(($(echo "$BUFFER" | wc --chars) - 1 - $lasttword)) 
            fi 

            if [[ "$lastword" =~ "$linechar" ]]; then

                local prfxcnt=$(($(echo "$prefix" | wc --chars) - 1))
                local oldprfxcnt line
                if [[ $index -eq $(($CURSOR - 1)) ]] && [[ $CURSOR == $cntuptolastword ]] && [[ "$directn" == 'right' ]]; then
                    line="$BUFFER"
                    oldprfxcnt=${#BUFFER}
                elif [[ $index -ge $CURSOR ]]; then
                    if test -n "$olderprefix"; then
                        oldprfxcnt=$(($(echo "$olderprefix" | wc --chars) - 1))
                        if [[ "${#arr[@]}" == 1 ]] && [[ "$directn" == 'left' ]]; then
                            line="$olderprefix$newword$olderspcl$lastword" 
                        else 
                            if [[ "$directn" == 'left' ]]; then
                                local lntcnt=$(($(echo "$oldprefix$lastword" | wc --chars) - 1))
                                local suffix=${BUFFER:$lntcnt}
                                line="$olderprefix$lastword$olderspcl$olderword$suffix" 
                            elif [[ $CURSOR -lt $cntuptolastword ]]; then
                                oldprfxcnt=$(($(echo "$oldprefix$newword$lastspcl" | wc --chars) - 1)) 
                                local lntcnt=$(($(echo "$oldprefix$lastword$lastspcl$newword" | wc --chars) - 1))
                                local suffix=${BUFFER:$lntcnt}
                                line="$oldprefix$newword$lastspcl$lastword$suffix" 
                            else
                                [[ "$directn" == 'right' ]] && ! [[ $CURSOR = ${#BUFFER} ]] &&
                                    CURSOR=${#BUFFER}
                                break
                            fi
                        fi
                    else
                        oldprfxcnt=0
                        if test -n "$oldprefix"; then
                            test -z "$olderspcl" && olderspcl="$lastspcl" && lastspcl=${arrr[1]}
                            if [[ "$directn" == 'left' ]]; then
                                local lntcnt=$(($(echo "$lastword$olderspcl$olderword" | wc --chars) - 1))
                                local suffix=${BUFFER:$lntcnt}
                                line="$lastword$olderspcl$olderword$suffix" 
                            else
                                test -z "$prefix" && 
                                    prfxcnt=$(($(echo "${arr[0]}" | wc --chars) - 1))
                                oldprfxcnt=$(($(echo "$olderword$olderspcl$newword$lastspcl" | wc --chars) - 1))
                                local lntcnt=$(($(echo "$olderword$olderspcl$newword$lastspcl$lastword" | wc --chars) - 1))
                                local suffix=${BUFFER:$lntcnt}
                                line="$olderword$olderspcl$newword$lastspcl$lastword$suffix" 
                            fi
                        elif ([[ "$directn" == 'left' ]] && [[ $CURSOR -gt $firstword ]]) || [[ "$directn" == 'right' ]]; then
                            [[ "$directn" == 'right' ]] && 
                                oldprfxcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                            test -z "$prefix" && prfxcnt=$(($(echo "$lastword" | wc --chars) - 1))
                            local wordcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                            local suffix=${BUFFER:$(($wordcnt))}
                            #    line="${BUFFER $lastword$lastspcl$newword$suffix" ||
                            line="$newword$lastspcl$lastword$suffix" 
                        else
                            if [[ "$directn" == 'left' ]]; then
                                local firstwordcnt=$(($(echo "$firstword" | wc --chars)))
                                if [[ $CURSOR == $firstwordcnt ]]; then
                                    local wordcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                                    local suffix=${BUFFER:$(($wordcnt))} 
                                    line="$newword$lastspcl$lastword$suffix" 
                                fi
                                CURSOR=0
                            fi
                            break
                        fi
                    fi
                    local relpoint=$(($CURSOR - $prfxcnt + $oldprfxcnt))
                    BUFFER=$line
                    CURSOR=$relpoint
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

            
            linechar=${BUFFER:$index:1}
            charcount=$(($(echo "${arrr[0]}" | wc --chars) - 1)) 
            index=$(($index + $charcount))

            if [[ "$lastspcl" =~ "$linechar" ]]; then
                
                if [[ $index -ge $CURSOR ]]; then
                    local oldprfxcnt line prfxcnt=0 relpoint
                    if test -n "$olderprefix"; then
                        prfxcnt=$(($(echo "$olderprefix" | wc --chars) - 1))
                        if [[ "$directn" == 'left' ]] && ([[ "${#arr[@]}" == 1 ]] || [[ $CURSOR == ${#BUFFER} ]] || [[ $CURSOR == ${#arrr[-1]} ]]); then
                            relpoint=$(($(echo "$olderprefix" | wc --chars) - 1)) 
                            local lntcnt=$(($(echo "$olderprefix$lastword$lastspcl$olderword" | wc --chars) - 1))
                            local suffix=${BUFFER:$lntcnt}
                            line="$olderprefix$newword$olderspcl$olderword" 
                        else 
                            if [[ "$directn" == 'left' ]]; then
                                relpoint=$(($(echo "$olderprefix" | wc --chars) - 1)) 

                                local lntcnt=$(($(echo "$olderprefix$lastword$lastspcl$olderword" | wc --chars) - 1))
                                local suffix=${BUFFER:$lntcnt}
                                line="$olderprefix$lastword$lastspcl$olderword$suffix" 
                            elif [[ $CURSOR -lt $cntuptolastword ]]; then 
                                relpoint=$(($(echo "$oldprefix$olderword$lastspcl$newword${arrr[1]}" | wc --chars) - 1)) 
                                local wordcnt=$(($(echo "$oldprefix$olderword$lastspcl$newword${arrr[1]}$lastword" | wc --chars) - 1)) 
                                local suffix=${BUFFER:$wordcnt}
                                line="$oldprefix$olderword$lastspcl$newword${arrr[1]}$lastword$suffix" 
                            else
                                [[ "$directn" == 'right' ]] && ! [[ $CURSOR = ${#BUFFER} ]] &&
                                    CURSOR=${#BUFFER}
                                break
                            fi
                        fi
                    else
                       oldprfxcnt=0
                       if test -n "$oldprefix"; then
                            test -z "$olderspcl" && olderspcl="$lastspcl" && lastspcl="${arrr[1]}"

                            if [[ $CURSOR -ge $cntuptolastword ]] && [[ "$directn" == 'right' ]]; then 
                                line="$BUFFER"
                                relpoint=${#BUFFER}
                            else
                                if [[ "$directn" == 'left' ]]; then
                                    
                                    if [[ ${#arr[@]} == '1' ]]; then
                                        relpoint=0 
                                        local lntcnt=$(($(echo "$olderword" | wc --chars) - 1))
                                        local suffix=${BUFFER:$lntcnt}
                                        line="$lastword$suffix" 
                                    else
                                        relpoint=$(($(echo "$oldprefix" | wc --chars) - 1)) 
                                        local lntcnt=$(($(echo "$olderword$olderspcl$lastword" | wc --chars) - 1))
                                        local suffix=${BUFFER:$lntcnt}
                                        line="$olderword$olderspcl$lastword$suffix" 
                                    fi
                                else
                                    relpoint=${#BUFFER}
                                    line="$BUFFER" 
                                fi
                            fi
                        elif [[ "$directn" == 'right' ]] || ([[ "$directn" == 'left' ]] && [[ $CURSOR -gt $firstword ]]); then
                            oldprfxcnt=$(($(echo "$lastword" | wc --chars) - 1)) &&
                            prfxcnt=$(($(echo "$prefix$lastspcl" | wc --chars) - 1))
                            local wordcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                            local suffix=${BUFFER:$(($wordcnt))}
                            line="$newword$lastspcl$lastword$suffix" 
                        else
                            [[ "$directn" == 'left' ]] && ! [[ $CURSOR = 0 ]] &&
                                CURSOR=0
                            break
                        fi

                    fi
                    ! [[ $relpoint ]] && relpoint=$(($CURSOR - $prfxcnt))
                    BUFFER=$line
                    CURSOR=$relpoint
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

#bindkey -M emacs -s '\e[1;2D' 'transpose_words space left'
#bindkey -M vicmd -s '\e[1;2D' 'transpose_words space left'
#bindkey -M viins -s '\e[1;2D' 'transpose_words space left'
#
#bindkey -M emacs -s "\e[1;2C" 'transpose_words space right'
#bindkey -M vicmd -s "\e[1;2C" 'transpose_words space right'
#bindkey -M viins -s "\e[1;2C" 'transpose_words space right'
#
## Transpose special character separated words on Alt+Shift Left/Right
#
#bindkey -M emacs -s "\e[1;4D" 'transpose_words words left'
#bindkey -M vicmd -s "\e[1;4D" 'transpose_words words left'
#bindkey -M viins -s "\e[1;4D" 'transpose_words words left'
#
#bindkey -M emacs -s "\e[1;4C" 'transpose_words words right'
#bindkey -M vicmd -s "\e[1;4C" 'transpose_words words right'
#bindkey -M viins -s "\e[1;4C" 'transpose_words words right'


function clear-screen(){ 
    clear 
    tput cup $(($LINE_TPUT+1)) $TPUT_COL 
    tput sc 
    tput cuu1 
    zle reset-prompt 
}

function show-cd(){ 
    clear 
    tput cup $(($LINE_TPUT+1)) $TPUT_COL 
    tput sc 
    tput cuu1 
    # If the current buffer doesn't start with 'cd ', insert it
    if [[ "$BUFFER" != cd\ * && "$BUFFER" != cd ]]; then
        BUFFER="cd "
        CURSOR=${#BUFFER}  # move cursor to end
    fi 
    zle reset-prompt 
    zle menu-complete
}

zle -N clear-screen
zle -N show-cd

# Shift up => Clean reset
bindkey -M emacs "\e[1;2A" clear-screen
bindkey -M vicmd "\e[1;2A" clear-screen
bindkey -M viins "\e[1;2A" clear-screen

# Shift down => cd shortcut
bindkey -M emacs "\e[1;2B" show-cd 
bindkey -M viins "\e[1;2B" show-cd
bindkey -M vicmd "\e[1;2B" show-cd

# Shift left/right to jump from bigwords (ignore spaces when jumping) instead of chars
#bindkey -M emacs -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -M vicmd     -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -M viins      -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#
#bindkey -M emacs -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -M vicmd     -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bindkey -M viins      -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'

# Alt left/right to jump to beginning/end line instead of chars
bindkey -M emacs "\e[1;3D" beginning-of-line
bindkey -M vicmd "\e[1;3D" beginning-of-line
bindkey -M viins "\e[1;3D" beginning-of-line

bindkey -M emacs "\e[1;3C" end-of-line
bindkey -M vicmd "\e[1;3C" end-of-line
bindkey -M viins "\e[1;3C" end-of-line

# Alt up/down to change cursor line
function mv_prmpt_up(){ 
    clear 
    let LINE_TPUT=$LINE_TPUT-1
    if [ $LINE_TPUT -lt 0 ]; then 
        let LINE_TPUT=$LINES;
    fi 
    tput cup $LINE_TPUT $COL_TPUT
    zle reset-prompt
    tput sc 
}
zle -N mv_prmpt_up
bindkey -M vicmd "\e[1;3A" mv_prmpt_up
bindkey -M emacs "\e[1;3A" mv_prmpt_up
bindkey -M viins "\e[1;3A" mv_prmpt_up


function mv_prmpt_dwn(){ 
    clear 
    let LINE_TPUT=$LINE_TPUT+1
    if [ $LINE_TPUT -gt $LINES ];then 
        let LINE_TPUT=0;
    fi 
    tput cup $LINE_TPUT $COL_TPUT
    zle reset-prompt
    tput sc 
}

zle -N mv_prmpt_up
zle -N mv_prmpt_dwn

bindkey -M vicmd "\e[1;3A" mv_prmpt_up
bindkey -M emacs "\e[1;3A" mv_prmpt_up
bindkey -M viins "\e[1;3A" mv_prmpt_up

bindkey -M emacs "\e[1;3B" mv_prmpt_dwn
bindkey -M vicmd "\e[1;3B" mv_prmpt_dwn
bindkey -M viins "\e[1;3B" mv_prmpt_dwn

function expand-aliases() {
    local cmd=${BUFFER%% *}
    local rest=${BUFFER#"$cmd"}
    local expansion=$(alias "$cmd" 2>/dev/null | sed -E "s/^$cmd='(.*)'$/\1/")

    if [[ -n "$expansion" ]]; then
        BUFFER="$expansion$rest"
        CURSOR=${#BUFFER}
    fi
}

zle -N expand-aliases

# Ctrl-w expands aliases
bindkey -M emacs "\C-w" expand-aliases
bindkey -M vicmd "\C-w" expand-aliases
bindkey -M viins "\C-w" expand-aliases

# Expand by looping through options
bindkey -M emacs 'Tab' menu-complete
bindkey -M vicmd 'Tab' menu-complete
bindkey -M viins 'Tab' menu-complete

# Shift+Tab for reverse
bindkey -M emacs "\e[Z" reverse-menu-complete
bindkey -M vicmd "\e[Z" reverse-menu-complete 
bindkey -M viins "\e[Z" reverse-menu-complete 

if [[ "$TERM" == 'xterm-kitty' ]]; then
    # (Kitty only) Ctrl-tab for variable autocompletion
    bindkey -M emacs "\e[9;5u" complete-word
    bindkey -M vicmd "\e[9;5u" complete-word
    bindkey -M viins "\e[9;5u" complete-word
fi

function exit-zsh(){ exit }

zle -N exit-zsh

# Ctrl-q quits terminal
bindkey -M emacs '\C-q' exit-zsh
bindkey -M vicmd '\C-q' exit-zsh
bindkey -M viins '\C-q' exit-zsh

# Ctrl+z is vi-undo (after being unbound in stty) instead of only on Ctrl+_
bindkey -M emacs "\C-z" vi-undo-change
bindkey -M vicmd "\C-z" vi-undo-change
bindkey -M viins "\C-z" vi-undo-change 

# Ctrl-backspace deletes (kills) line backward
bindkey -M emacs "\C-h" backward-kill-word
bindkey -M vicmd "\C-h" backward-kill-word
bindkey -M viins "\C-h" backward-kill-word

# Ctrl-l clears
bindkey -M vicmd '\C-l' clear-screen
bindkey -M emacs '\C-l' clear-screen
bindkey -M viins '\C-l' clear-screen

function delete-first-char() {
    if [[ -n "$BUFFER" ]]; then
        BUFFER=${BUFFER:1}       
        (( CURSOR > 0 )) && (( CURSOR-- ))  
    fi
}

zle -N delete-first-char

# Ctrl-d: Delete first character on line
bindkey -M emacs "\C-d" delete-first-char
bindkey -M vicmd "\C-d" delete-first-char
bindkey -M viins "\C-d" delete-first-char  

# Ctrl+b: (Ctrl+x Ctrl+b emacs mode) is quoted insert - Default Ctrl+v - Gives (f.ex. 'Ctrl-a') back as '^A'
bindkey -M emacs "\C-x\C-b" quoted-insert
bindkey -M vicmd "\C-b" quoted-insert
bindkey -M viins "\C-b" quoted-insert



function emacs-mode() {
    if [[ "${KEYMAP}" == 'vicmd' ]]; then
        zle vi-insert 
    fi
    setopt emacs
    PS1=$(echo $PS1 | sed 's/^(vi)//' | sed 's/^(emacs)//')  
    PS1="(emacs)$PS1" 
    zle reset-prompt 
}

function vi-mode() {
    setopt vi
    PS1=$(echo $PS1 | sed 's/^(vi)//' | sed 's/^(emacs)//')  
    PS1="(vi)$PS1" 
    zle reset-prompt 
}

zle -N emacs-mode
zle -N vi-mode


# Ctrl+o: Change from vi-mode to emacs mode and back
# This is also configured in ~/.fzf/shell/key-bindings-bash.sh if you have fzf keybinds installed
bindkey -M vicmd "\C-o" emacs-mode
bindkey -M viins "\C-o" emacs-mode
bindkey -M emacs "\C-o" vi-mode


# vi-command ' / emacs C-x ' helps with adding quotes to bash strings
function quote-all-zsh() { BUFFER="${BUFFER@Q}"; zle reset-prompt }
zle -N quote-all-zsh
bindkey -M emacs -s '\C-x'\''' quote-all-zsh
bindkey -M vicmd -s ''\''' quote-all-zsh
#bindkey -M viins -s '\C-x'\''' '_quote_all'


#https://thevaluable.dev/zsh-install-configure-mouseless/

zstyle :zle:edit-command-line editor $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line

bindkey -M viins "\C-e" edit-command-line
bindkey -M vicmd "\C-e" edit-command-line
bindkey -M emacs "\C-e\C-e" edit-command-line


# RLWRAP

#if hash rlwrap &> /dev/null; then
#    bindkey -M emacs '"\C-x\C-e" : rlwrap-call-editor'
#    bindkey -M vicmd '"\C-e" : rlwrap-call-editor'
#    bindkey -M viins '"\C-e" : rlwrap-call-editor'
#fi

if hash osc &>/dev/null; then
    
    function osc-copy() {
        echo -n "$BUFFER" | osc copy
    }
    
    function osc-paste() {
        local pasters="$(osc paste)"
        BUFFER="${BUFFER:0:$CURSOR}$pasters${BUFFER:$CURSOR}"
        CURSOR=$((CURSOR + ${#pasters}))
    }
   
    zle -N osc-copy
    zle -N osc-paste

    bindkey -M emacs "\C-s" osc-copy
    bindkey -M vicmd "\C-s" osc-copy
    bindkey -M viins "\C-s" osc-copy

    bindkey -M vicmd "\C-v" osc-paste
    bindkey -M emacs "\C-v" osc-paste
    bindkey -M viins "\C-v" osc-paste

elif ([[ "$XDG_SESSION_TYPE" == 'x11' ]] && hash xclip &>/dev/null) || ([[ "$XDG_SESSION_TYPE" == 'wayland' ]] && hash wl-copy &> /dev/null); then
  
    function clip-copy() {
        if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then  
            echo -n "$BUFFER" | xclip -i -sel c
        elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
            echo -n "$BUFFER" | wl-copy
        fi
    }

    function clip-paste() {
        if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then  
            local pasters="$(xclip -o -sel c)"
        elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
            local pasters="$(wl-paste)"
        fi
        BUFFER="${BUFFER:0:$CURSOR}$pasters${BUFFER:$CURSOR}"
        CURSOR=$((CURSOR + ${#pasters}))
    }
   
    zle -N clip-copy
    zle -N clip-paste

    # Ctrl-s: Proper copy
    bindkey -M emacs "\C-s" clip-copy
    bindkey -M vicmd "\C-s" clip-copy
    bindkey -M viins "\C-s" clip-copy

    # Ctrl-v: Proper paste
    bindkey -M emacs "\C-v" clip-paste
    bindkey -M vicmd "\C-v" clip-paste
    bindkey -M viins "\C-v" clip-paste

fi

if hash autojump &>/dev/null; then
    function show-j(){ 
        clear 
        tput cup $(($LINE_TPUT+1)) $TPUT_COL 
        tput sc 
        tput cuu1 
        if [[ "$BUFFER" != j\ * && "$BUFFER" != j ]]; then
            BUFFER="j "
            CURSOR=${#BUFFER}
        fi 
        zle reset-prompt 
        zle menu-complete
    }
          
    zle -N show-j   

    # Ctrl-x Ctrl-j for autojump
    bindkey -M emacs "\C-x\C-j" show-j 
    bindkey -M vicmd "\C-j" show-j 
    bindkey -M viins "\C-j" show-j 
fi

if hash fzf &>/dev/null; then
    
    #if [[ "$TERM" == 'xterm-kitty' ]]; then
    #    # (Kitty only) Ctrl-tab for fzf autocompletion
    #    bindkey -M emacs '"\e[9;5u": " **\t"'
    #    bindkey -M vicmd '"\e[9;5u": " **\t"'
    #    bindkey -M viins '"\e[9;5u": " **\t"'
    #fi

    if type ripgrep-dir &>/dev/null; then
        
        function ripgrep-dir-zsh(){
            ripgrep-dir
            zle reset-prompt
        }
         
        zle -N ripgrep-dir-zsh
        
        # Ctrl-g: Ripgrep function overview
        bindkey -M emacs "\C-g" ripgrep-dir-zsh
        bindkey -M vicmd "\C-g" ripgrep-dir-zsh
        bindkey -M viins "\C-g" ripgrep-dir-zsh
    fi

    if type fzf_rifle &>/dev/null; then
       
        function fzf_rifle-zsh(){
            fzf_rifle
            zle reset-prompt
        }
         
        zle -N fzf_rifle-zsh
       
        # CTRL-F - Paste the selected file path into the command line
        bindkey -M emacs "\C-f" fzf_rifle-zsh
        bindkey -M vicmd "\C-f" fzf_rifle-zsh
        bindkey -M viins "\C-f" fzf_rifle-zsh

        # F4 - Rifle search
        bindkey -M emacs "\eOS" fzf_rifle-zsh
        bindkey -M vicmd "\eOS" fzf_rifle-zsh
        bindkey -M viins "\eOS" fzf_rifle-zsh
    fi
fi

# F2 - ranger (file explorer)
if hash ranger &>/dev/null; then
    # https://unix.stackexchange.com/questions/475310/how-to-bind-a-keyboard-shortcut-in-zsh-to-a-program-requiring-stdin 
    function ranger-zsh () {
        ranger --choosedir=$HOME/.rangerdir < $TTY
        LASTDIR=`cat $HOME/.rangerdir`
        cd "$LASTDIR"
        zle reset-prompt
        unset LASTDIR 
    }
    
    zle -N ranger-zsh 
   
    bindkey -M emacs "\eOQ" ranger-zsh
    bindkey -M vicmd "\eOQ" ranger-zsh
    bindkey -M viins "\eOQ" ranger-zsh
fi

# F3 - lazygit (Git helper)
if hash lazygit &>/dev/null; then
    function lazygit-zsh () {
        lazygit
        zle reset-prompt
    }
    
    zle -N lazygit-zsh
    bindkey -M emacs "\eOR" lazygit-zsh
    bindkey -M vicmd "\eOR" lazygit-zsh
    bindkey -M viins "\eOR" lazygit-zsh
fi

# F5, Ctrl-r - Reload .zshrc
#bind '"\205": re-read-init-file;'
function resource-zsh(){ source ~/.zshrc }
zle -N resource-zsh
bindkey -M emacs "\e[15~" resource-zsh
bindkey -M vicmd "\e[15~" resource-zsh 
bindkey -M viins "\e[15~" resource-zsh 

# F6 - (neo/fast/screen)fetch (System overview)
if hash neofetch &>/dev/null || hash fastfetch &>/dev/null || hash screenfetch &>/dev/null || hash onefetch &>/dev/null; then

    if hash onefetch &>/dev/null; then
        if hash neofetch &>/dev/null || hash fastfetch &>/dev/null || hash screenfetch &>/dev/null; then
            function fetchbind-zsh(){
                if hash git &> /dev/null && git rev-parse --git-dir &> /dev/null; then
                    local gstats 
                    readyn -p "Use onefetch? (lists github stats)" gstats 
                    if [[ "$gstats" == "y" ]]; then
                        onefetch 
                    else
                        echo 
                        if hash fastfetch &>/dev/null; then
                            fastfetch
                        elif hash screenfetch &>/dev/null; then
                            screenfetch
                        elif hash neofetch &>/dev/null; then
                            neofetch
                        fi
                    fi
                else
                    echo 
                    if hash fastfetch &>/dev/null; then
                        fastfetch
                    elif hash screenfetch &>/dev/null; then
                        screenfetch
                    elif hash neofetch &>/dev/null; then
                        neofetch
                    fi
                fi
                zle reset-prompt
            }
        else
            function fetchbind-zsh(){ stty sane; onefetch }
        fi
    else
        if hash neofetch &>/dev/null; then
            function fetchbind-zsh(){ stty sane; echo; neofetch }
        fi

        if hash screenfetch &>/dev/null; then
            function fetchbind-zsh(){ stty sane; echo;screenfetch }
        fi

        if hash fastfetch &>/dev/null; then
            function fetchbind-zsh(){ stty sane; echo; fastfetch }
        fi
    fi
    
    zle -N fetchbind-zsh

    bindkey -M emacs "\e[17~" fetchbind-zsh
    bindkey -M vicmd "\e[17~" fetchbind-zsh 
    bindkey -M viins "\e[17~" fetchbind-zsh 
    
    unset fetch
fi

# F7 - Htop and alternatives

function htop-btop-zsh(){
    stty sane
    local ansr ansr1 
    if hash btop &>/dev/null; then
         readyn -p "Use btop instead of htop?" ansr 
         if [[ "$ansr" == "y" ]]; then
             readyn -p "Start btop as root?" ansr1 
             if [[ "$ansr1" == "y" ]]; then
                sudo btop
             else 
                btop
             fi
         fi
    
    elif hash bashtop &>/dev/null; then
         readyn -p "Use bashtop instead of htop?" ansr 
         if [[ "$ansr" == "y" ]]; then
             readyn -p "Start bashtop as root?" ansr1 
             if [[ "$ansr1" == "y" ]]; then
                sudo bashtop
             else 
                bashtop
             fi
         fi
    elif hash bpytop &>/dev/null; then
         readyn -p "Use bpytop instead of htop?" ansr 
         if [[ "$ansr" == "y" ]]; then
             readyn -p "Start bpytop as root?" ansr1 
             if [[ "$ansr1" == "y" ]]; then
                sudo bpytop
             else 
                bpytop
             fi
         fi
    fi
    
    if (! hash bpytop &> /dev/null && ! hash bpytop &> /dev/null && ! hash bpytop &> /dev/null) || [[ "$ansr" == 'n' ]]; then
        readyn -p "Start htop as root?" ansr1 && [[ "$ansr1" == "y" ]] && sudo htop || htop
    fi
    zle reset-prompt 
}

zle -N htop-btop-zsh

bindkey -M emacs "\e[18~" htop-btop-zsh
bindkey -M vicmd "\e[18~" htop-btop-zsh
bindkey -M viins "\e[18~" htop-btop-zsh

# F8 - Lazydocker (Docker TUI)
if hash lazydocker &>/dev/null; then
    function lazydocker-zsh () {
        lazydocker
        zle reset-prompt
    }
    
    zle -N lazydocker-zsh
    bindkey -M emacs "\e[19~" lazydocker-zsh
    bindkey -M vicmd "\e[19~" lazydocker-zsh 
    bindkey -M viins "\e[19~" lazydocker-zsh 
fi
