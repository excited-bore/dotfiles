#!/bin/bash

# Bash_aliases at ~/.bash_aliases.d/
# global bashrc -> /etc/bash.bashrc
# root shell profiles -> /etc/profile

# Vi/emacs style editing shortcuts/interface
# https://unix.stackexchange.com/questions/303479/what-are-readlines-modes-keymaps-and-their-default-bindings
# bind 'set editing-mode vi'
# bind 'set editing-mode emacs'

# https://stackoverflow.com/questions/8366450/complex-keybinding-in-bash

alias list-binds-stty="stty -a"
alias list-binds-readline="{ printf \"\nList commands bound to keys\n\n\" ; bind -X ; echo; echo \"List key sequences that invoke macros and their values\"; echo; bind -S ; echo ;  echo \"List readline functions (possibly) bound to keys\"; bind -P; } | $PAGER"
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
#bind -m vi-command '"\C-a": emacs-editing-mode'
#bind -m vi-insert '"\C-a": emacs-editing-mode'
#bind -m emacs-standard '"\C-a": vi-editing-mode'

# up and down arrow will now intelligently complete partially completed
# commands by searching through the existing history.
bind -m emacs-standard '"\e[a": history-search-backward'
bind -m vi-command '"\e[a": history-search-backward'
bind -m vi-insert '"\e[a": history-search-backward'

bind -m emacs-standard '"\e[b": history-search-forward'
bind -m vi-command '"\e[b": history-search-forward'
bind -m vi-insert '"\e[b": history-search-forward'

# Shift arrow key fix
# https://unix.stackexchange.com/questions/444214/bash-shiftarrow-keys-make-a-b-c-d

# also shift arrow keys left/right now select stuff by setting the mark
# i use `exchange-point-and-mark` twice over `set-mark` since this highlights the region properly
# *n o  i d e a* why there's not even an option in readline that allows `set-mark` to do the same, it ig this at least works so *whatever*..


# Ctrl-Alt-Left/Right should move the region 1 char to the left/right
# And since the only way to reactivate the region after moving is, is by using a readline function bound to a key..
# ....We basically have to make a function that does this, then bind a key to that and a escape sequence bound to the activation of the region
# .... Because we can only use readline functions when they're bound to a key/escape sequence
# ... and then rebind Ctrl-Alt-Left/Right after the region becomes deactivated

function move-region(){
    local len word prevc nextc linelen="${#READLINE_LINE}"
    if [[ $READLINE_POINT -lt $READLINE_MARK ]]; then
        len=$(( $READLINE_MARK - $READLINE_POINT )) 
        word="${READLINE_LINE:$READLINE_POINT:$len}"
        if [[ $1 == 'left' ]]; then
            if [[ $READLINE_POINT != 0 ]]; then
                prevc="${READLINE_LINE:$(($READLINE_POINT-1)):1}"
                READLINE_LINE="${READLINE_LINE:0:$(($READLINE_POINT-1))}$word$prevc${READLINE_LINE:$READLINE_MARK}"
                READLINE_POINT=$((READLINE_POINT-1))
                READLINE_MARK=$((READLINE_MARK-1))
            else 
                READLINE_LINE="${READLINE_LINE:${#word}}$word"
                READLINE_POINT=$((${#READLINE_LINE}-${#word}))
                READLINE_MARK=${#READLINE_LINE}
            fi
        elif [[ $1 == 'right' ]]; then
            if [[ $READLINE_MARK != $linelen ]]; then
                nextc="${READLINE_LINE:$READLINE_MARK:1}"
                READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$nextc$word${READLINE_LINE:$((READLINE_MARK+1))}"
                READLINE_POINT=$((READLINE_POINT+1))
                READLINE_MARK=$((READLINE_MARK+1))
            else
                READLINE_LINE="$word${READLINE_LINE:0:$((${#READLINE_LINE} - ${#word}))}"
                READLINE_POINT=0
                READLINE_MARK=${#word}
            fi
        fi
    elif [[ $READLINE_MARK -lt $READLINE_POINT ]]; then
        len=$(( $READLINE_POINT - $READLINE_MARK )) 
        word="${READLINE_LINE:$READLINE_MARK:$len}" 
        if [[ $1 == 'left' ]]; then
            if [[ $READLINE_MARK != 0 ]]; then
                prevc="${READLINE_LINE:$(($READLINE_MARK-1)):1}"
                READLINE_LINE="${READLINE_LINE:0:$(($READLINE_MARK-1))}$word$prevc${READLINE_LINE:$READLINE_POINT}"
                READLINE_POINT=$((READLINE_POINT-1))
                READLINE_MARK=$((READLINE_MARK-1))
            else
                READLINE_LINE="${READLINE_LINE:${#word}}$word"
                READLINE_MARK=$((${#READLINE_LINE}-${#word}))
                READLINE_POINT=${#READLINE_LINE}
            fi
        elif [[ $1 == 'right' ]]; then
            if [[ $READLINE_POINT != $linelen ]]; then
                nextc="${READLINE_LINE:$READLINE_POINT:1}"
                READLINE_LINE="${READLINE_LINE:0:$READLINE_MARK}$nextc$word${READLINE_LINE:$((READLINE_POINT+1))}"
                READLINE_POINT=$((READLINE_POINT+1))
                READLINE_MARK=$((READLINE_MARK+1))
            else
                READLINE_LINE="$word${READLINE_LINE:0:$((${#READLINE_LINE} - ${#word}))}"
                READLINE_MARK=0
                READLINE_POINT=${#word}
            fi
        fi
    fi
} 

bind '"\e102": exchange-point-and-mark'
bind -x '"\e113": "move-region left"'  
bind -x '"\e114": "move-region right"'  

READLINE_MARK_SET=''

function set-mark-and-bind-move-region(){
    #local keymap leftmap leftmapx rightmap rightmapx
    
    if [[ -z $READLINE_MARK_SET || $READLINE_MARK_SET == 0 ]]; then 
        READLINE_MARK_SET=1; 
        READLINE_MARK=$READLINE_POINT; 
       
        # Check which keymap is active 
        if set -o | grep -Eq 'emacs\s+on'; then
            keymap="emacs-standard"
        else
            keymap="vi-insert" 
        fi
        
        CTRL_ALT_KM=$keymap
        
        if ! bind -m $keymap -X | grep -q '\\e\[1;7D": "\\e101\\e108\\e113\\e102\\e102'; then
            # Ctrl-Alt-Left should move a region 1 char to the left 
            if bind -m $keymap -p | grep -q '"\\e\[1;7D":'; then
                leftmap=$(bind -m $keymap -p | grep '"\\e\[1;7D":' | awk '{$1=""; print}' | xargs)
            elif bind -m $keymap -s | grep -q '"\\e\[1;7D":'; then
                leftmap=$(bind -m $keymap -s | grep '"\\e\[1;7D":' | awk '{$1=""; print}' | xargs)
            elif bind -m $keymap -X | grep -q '"\\e\[1;7D"'; then
                leftmapx='-x ' 
                leftmap=$(bind -m $keymap -X | grep '"\\e\[1;7D"' | awk '{$1=""; print}' | xargs)
            fi
            bind -m $keymap '"\e[1;7D": "\e101\e108\e113\e102\e102"' 
            CTRL_ALT_LEFTX=$leftmapx
            CTRL_ALT_LEFTM=$leftmap
        fi
         
        if ! bind -m $keymap -X | grep -q '\\e\[1;7C": "\\e101\\e108\\e114\\e102\\e102'; then
            if bind -m $keymap -p | grep -q '"\\e\[1;7C":'; then
                rightmap=$(bind -m $keymap -p | grep '"\\e\[1;7C":' | awk '{$1=""; print}' | xargs)
            elif bind -m $keymap -s | grep -q '"\\e\[1;7C":'; then
                rightmap=$(bind -m $keymap -s | grep '"\\e\[1;7C":' | awk '{$1=""; print}' | xargs)
            elif bind -m $keymap -X | grep -q '"\\e\[1;7C"'; then
                rightmapx='-x '
                rightmap=$(bind -m $keymap -X | grep '"\\e\[1;7C"' | awk '{$1=""; print}' | xargs)
            fi
            bind -m $keymap '"\e[1;7C": "\e101\e108\e114\e102\e102"' 
            CTRL_ALT_RIGHTX=$rightmapx
            CTRL_ALT_RIGHTM=$rightmap
        fi
    fi
}

function reset-mark(){
   READLINE_MARK=$READLINE_POINT 
   READLINE_MARK_SET=0
   if [[ -n $CTRL_ALT_LEFTM ]]; then
       bind -m $CTRL_ALT_KM $CTRL_ALT_LEFTX "\"\e[1;7D\": \"$CTRL_ALT_LEFTM\""
       CTRL_ALT_LEFTM="" 
   fi
   if [[ -n $CTRL_ALT_RIGHTM ]]; then
       bind -m $CTRL_ALT_KM $CTRL_ALT_RIGHTX "\"\e[1;7C\": \"$CTRL_ALT_RIGHTM\""
       CTRL_ALT_RIGHTM="" 
   fi
}

#bind '"\e101": set-mark'
bind -x '"\e101": set-mark-and-bind-move-region'
bind -x '"\e105": reset-mark'
bind -x '"\e106": echo "Mark: $READLINE_MARK"; echo "Point: $READLINE_POINT"'

bind '"\e103": backward-char'
bind '"\e104": forward-char'

# Fix for after expanding region to the left
bind -x '"\e107": [[ $READLINE_MARK == $READLINE_POINT && -n $READLINE_MARK_SET ]] && READLINE_MARK=$(($READLINE_MARK - 1))'
# Fix for after expanding region to the right
bind -x '"\e108": [[ $READLINE_MARK == $READLINE_POINT && -n $READLINE_MARK_SET ]] && READLINE_MARK=$(($READLINE_MARK + 1));'


bind -m emacs-standard '"\e[1;2C": "\e101\e104\e108\e102\e102"'
bind -m vi-command '"\e[1;2C": "\e101\e104\e108\e102\e102"'
bind -m vi-insert '"\e[1;2C": "\e101\e104\e108\e102\e102"'

bind -m emacs-standard '"\e[1;2D": "\e101\e103\e108\e102\e102"'
bind -m vi-command '"\e[1;2D": "\e101\e103\e108\e102\e102"'
bind -m vi-insert '"\e[1;2D": "\e101\e103\e108\e102\e102"'

# Shift Up/Down selects untill the beginning/end of a line

bind '"\e111": end-of-line'
bind '"\e112": beginning-of-line'

bind -m emacs-standard '"\e[1;2A": "\e101\e111\e107\e102\e102"'
bind -m vi-command '"\e[1;2A": "\e101\e111\e107\e102\e102"'
bind -m vi-insert '"\e[1;2A": "\e101\e111\e107\e102\e102"'

bind -m emacs-standard '"\e[1;2B": "\e101\e112\e108\e102\e102"'
bind -m vi-command '"\e[1;2B": "\e101\e112\e108\e102\e102"'
bind -m vi-insert '"\e[1;2B": "\e101\e112\e108\e102\e102"'

# Arrow Key resets mark / selection

bind -m emacs-standard '"\e[C": "\e104\e105"'
bind -m vi-command '"\e[C": "\e104\e105"'
bind -m vi-insert '"\e[C": "\e104\e105"'

bind -m emacs-standard '"\e[D": "\e103\e105"'
bind -m vi-command '"\e[D": "\e103\e105"'
bind -m vi-insert '"\e[D": "\e103\e105"'


# Control left/right to jump from bigwords (ignore spaces when jumping) instead of chars

bind '"\e109": vi-forward-word'
bind '"\e110": vi-backward-word'

bind -m emacs-standard '"\e[1;5C": "\e109\e105"'
bind -m vi-command '"\e[1;5C": "\e109\e105"'
bind -m vi-insert '"\e[1;5C": "\e109\e105"'

bind -m emacs-standard '"\e[1;5D": "\e110\e105"'
bind -m vi-command '"\e[1;5D": "\e110\e105"'
bind -m vi-insert '"\e[1;5D": "\e110\e105"'

# Control Up/Down - Move to beginning or end of lin e

bind -m emacs-standard '"\e[1;5A": "\e111\e105"' 
bind -m vi-command '"\e[1;5A": "\e111\e105"'
bind -m vi-insert '"\e[1;5A": "\e111\e105"'

bind -m emacs-standard '"\e[1;5B": "\e112\e105"'
bind -m vi-command '"\e[1;5B": "\e112\e105"'
bind -m vi-insert '"\e[1;5B": "\e112\e105"'

# make sure $columns gets set
shopt -s checkwinsize

# full path dirs
alias dirs="dirs -l"
alias dirs-col="dirs -v | column -c $COLUMNS"
alias dirs-col-pretty="dirs -v | column -c $COLUMNS | sed -e 's/ 0 \\([^\t]*\\)/'\${GREEN}' 0 \\1'\${normal}'/'"

#'silent' clear
if hash starship &>/dev/null && [[ $STARSHIP_SHELL == 'bash' ]] && (grep -q '\\n' ~/.config/starship.toml || (grep -q 'line_break' ~/.config/starship.toml && ! pcregrep -qM "[line_break]\$(.|\n)*^disabled = true" ~/.config/starship.toml)); then
    alias _="tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null"
    alias _.="tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i < \$(dirs -v | column -c \${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && dirs-col-pretty && history -d -1 &>/dev/null"
elif hash starship &>/dev/null && [[ $STARSHIP_SHELL == 'bash' ]]; then
    alias _="tput cuu1 && tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null"
    alias _.="tput cuu1 && tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i < \$(dirs -v | column -c \${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && tput cuu1 && dirs-col-pretty && tput rc && history -d -1 &>/dev/null"
else
    alias _="tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null"
    alias _.="tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i <= \$(dirs -v | column -c \${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && dirs-col-pretty && tput rc && history -d -1 &>/dev/null"
fi

alias __='clear && tput cup $(($LINE_TPUT+1)) $TPUT_COL && tput sc && tput cuu1 && echo "${PS1@P}" && tput cuu1'

# Control-Alt-Up/Down to change cursor line
bind -m emacs-standard -x '"\e[1;7A": clear && let LINE_TPUT=$LINE_TPUT-1; if [ $LINE_TPUT -lt 0 ];then let LINE_TPUT=$LINES;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'
bind -m vi-command -x '"\e[1;7A": clear && let LINE_TPUT=$LINE_TPUT-1; if [ $LINE_TPUT -lt 0 ];then let LINE_TPUT=$LINES;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'
bind -m vi-insert -x '"\e[1;7A": clear && let LINE_TPUT=$LINE_TPUT-1; if [ $LINE_TPUT -lt 0 ];then let LINE_TPUT=$LINES;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'

bind -m emacs-standard -x '"\e[1;7B": clear && let LINE_TPUT=$LINE_TPUT+1; if [ $LINE_TPUT -gt $LINES ];then let LINE_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'
bind -m vi-command -x '"\e[1;7B": clear && let LINE_TPUT=$LINE_TPUT+1; if [ $LINE_TPUT -gt $LINES ];then let LINE_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'
bind -m vi-insert -x '"\e[1;7B": clear && let LINE_TPUT=$LINE_TPUT+1; if [ $LINE_TPUT -gt $LINES ];then let LINE_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'

# Ctrl-Alt+Shift Left/Right => Move character or region

bind -m emacs-standard '"\e[1;7D": "\e101\e108\e113\e102\e102"'
bind -m vi-command '"\e[1;7D": "\e101\e108\e113\e102\e102"'
bind -m vi-insert '"\e[1;7D": "\e101\e108\e113\e102\e102"'

bind -m emacs-standard '"\e[1;7C": "\e101\e108\e114\e102\e102"'
bind -m vi-command '"\e[1;7C": "\e101\e108\e114\e102\e102"'
bind -m vi-insert '"\e[1;7C": "\e101\e108\e114\e102\e102"'

# Transpose special character separated words on Ctrl-Alt+Shift Left/Right
#bind -m emacs-standard -x '"\e[1;7D": transpose_words space left'
#bind -m vi-command -x '"\e[1;7D": transpose_words space left'
#bind -m vi-insert -x '"\e[1;7D": transpose_words space left'

#bind -m emacs-standard -x '"\e[1;7C": transpose_words space right'
#bind -m vi-command -x '"\e[1;7C": transpose_words space right'
#bind -m vi-insert -x '"\e[1;7C": transpose_words space right'

#bind -m emacs-standard -x '"\e[1;7D": transpose_words words left'
#bind -m vi-command -x '"\e[1;7D": transpose_words words left'
#bind -m vi-insert -x '"\e[1;7D": transpose_words words left'

#bind -m emacs-standard -x '"\e[1;7C": transpose_words words right'
#bind -m vi-command -x '"\e[1;7C": transpose_words words right'
#bind -m vi-insert -x '"\e[1;7C": transpose_words words right'


# Ctrl+o: Change from vi-mode to emacs mode and back
# This is also configured in ~/.fzf/shell/key-bindings-bash.sh if you have fzf keybinds installed
bind -m vi-command '"\C-o": emacs-editing-mode'
bind -m vi-insert '"\C-o": emacs-editing-mode'
bind -m emacs-standard '"\C-o": vi-editing-mode'

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

complete -F _cd cd-w

if type _fzf_dir_completion &> /dev/null; then
    complete -F _fzf_dir_completion cd
fi

alias cd='cd-w'


# 'dirs' builtins shows all directories in stack
# Alt-Right arrow rotates forward over directory history
bind -x '"\e277": pushd +1 &>/dev/null'
bind -m emacs-standard '"\e[1;3C": "\C-e\C-u\e277 _.\C-m"'
bind -m vi-command '"\e[1;3C": "ddi\e277 _.\C-m"'
bind -m vi-insert '"\e[1;3C": "\eddi\e277 _.\C-m"'

# Alt-Left arrow rotates backward over directory history
bind -x '"\e266": pushd -0 &>/dev/null'
bind -m emacs-standard '"\e[1;3D": "\C-e\C-u\e266 _.\C-m"'
bind -m vi-command '"\e[1;3D": "ddi\C-u\e266 _.\C-m"'
bind -m vi-insert '"\e[1;3D": "\eddi\e266 _.\C-m"'

# Alt-Up goes up one directory
bind -x '"\e288": cd ..'
bind -m emacs-standard '"\e[1;3A": "\C-e\C-u\e288 _.\C-m"'
bind -m vi-command '"\e[1;3A": "\C-e\C-u\e288 _.\C-m"'
bind -m vi-insert '"\e[1;3A": "\C-e\C-u\e288 _.\C-m"'

# Alt-Down prompts you to select a folder to go into
# With fzf keybinds or with tabcomplete
if ! hash fzf &> /dev/null || ! [ -f $HOME/.keybinds.d/fzf-bindings.bash ]; then
    bind -x '"\e299": "__"'
    bind -m emacs-standard '"\e[1;3B": "\C-e\C-u\e299cd \C-i"'
    bind -m vi-command '"\e[1;3B": "\eddi\e299cd \C-i"'
    bind -m vi-insert '"\e[1;3B": "\eddi\e299cd \C-i"'
else
    if ! [ -f $HOME/.keybinds.d/fzf-bindings.bash ]; then
        __fzf_cd__() {
          local dir=$(
            FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} \
            FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "${FZF_ALT_C_OPTS-} +m") \
            FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd)
          ); [[ -n $dir ]] && cd -- "$dir"
        }
        bind -x '"\e987": "__fzf_cd__"'
        bind -m emacs-standard '"\e[1;3B": "\e987_\C-m"'
        bind -m vi-command '"\e[1;3B": "\e987_\C-m"'
        bind -m vi-insert '"\e[1;3B": "\e987_\C-m"'
    fi
    if hash bfs &> /dev/null; then
        # https://github.com/tavianator/bfs/issues/163 
        FZF_ALT_C_COMMAND="[[ -n \"\$(command ls -Ahp | command grep \".*/$\")\" ]] && bfs -s -x -type d -printf '%P\n' -exclude -name '.git' -exclude -name 'node_modules' | sed '/^[[:space:]]*$/d' || echo .." 
        # Alternative with previous directory added
        # FZF_ALT_C_COMMAND="[[ -n \"\$(command ls -Ahp | command grep \".*/$\")\" ]] && echo \"..\n\$(bfs -s -x -type d -printf '%P\n' -exclude -name '.git' -exclude -name 'node_modules' | sed '/^[[:space:]]*$/d')\" || echo .." 
    elif hash fd &> /dev/null; then
        FZF_ALT_C_COMMAND="fd -H --type d --exclude '.git' --exclude 'node_modules'" 
    fi
    
    FZF_ALT_C_OPTS='--bind "ctrl-v:become(vlc --recursive expand {})"
                    --bind "ctrl-g:become(. ~/.bash_aliases.d/ripgrep-directory.sh && cd {} && ripgrep-dir > /dev/tty)"' 
    if hash eza &> /dev/null; then
        FZF_ALT_C_OPTS="$FZF_ALT_C_OPTS --preview 'eza --tree --color=always --icons=always --all {}'"
    elif hash tree &> /dev/null; then 
        FZF_ALT_C_OPTS="$FZF_ALT_C_OPTS --preview 'tree -C {}'"
    fi
fi


# Ctrl-w expands aliases
bind -m emacs-standard '"\C-w": history-and-alias-expand-line'
bind -m vi-command '"\C-w": history-and-alias-expand-line'
bind -m vi-insert '"\C-w": history-and-alias-expand-line'

# Expand by looping through options
bind -m emacs-standard 'Tab: menu-complete'
bind -m vi-command 'Tab: menu-complete'
bind -m vi-insert 'Tab: menu-complete'

# Shift+Tab for reverse
bind -m emacs-standard '"\e[Z": menu-complete-backward'
bind -m vi-command '"\e[Z": menu-complete-backward'
bind -m vi-insert '"\e[Z": menu-complete-backward'

if [[ "$TERM" == 'xterm-kitty' ]]; then
    # (Kitty only) Ctrl-tab for variable autocompletion
    bind -m emacs-standard '"\e[9;5u": possible-variable-completions'
    bind -m vi-command '"\e[9;5u": possible-variable-completions'
    bind -m vi-insert '"\e[9;5u": possible-variable-completions'

fi

# Ctrl-q quits terminal
bind -m emacs-standard -x '"\C-q": exit'
bind -m vi-command -x '"\C-q": exit'
bind -m vi-insert -x '"\C-q": exit'

# Ctrl+z is vi-undo (after being unbound in stty) instead of only on Ctrl+_
bind -m emacs-standard '"\C-z": vi-undo'
bind -m vi-command '"\C-z": vi-undo'
bind -m vi-insert '"\C-z": vi-undo'

# Ctrl-backspace deletes (kills) line backward
bind -m emacs-standard '"\C-h": backward-kill-word'
bind -m vi-command '"\C-h": backward-kill-word'
bind -m vi-insert '"\C-h": backward-kill-word'

# Ctrl-l clears
bind -m emacs-standard -x '"\C-l": __'
bind -m vi-command -x '"\C-l": __'
bind -m vi-insert -x '"\C-l": __'

# Ctrl-d: Delete first character on line
#bind -m emacs-standard '"\C-d": "\C-a\e[3~"'
#bind -m vi-command '"\C-d": "\e[1;3D\e[3~"'
#bind -m vi-insert '"\C-d": "\e[1;3D\e[3~"'

# Ctrl+b: (Ctrl+x Ctrl+b emacs mode) is quoted insert - Default Ctrl+v - Gives (f.ex. 'Ctrl-a') back as '^A'
#bind -m emacs-standard '"\C-x\C-b": quoted-insert'
#bind -m vi-command '"\C-b": quoted-insert'
#bind -m vi-insert '"\C-b": quoted-insert'

# vi-command ' / emacs C-x ' helps with adding quotes to bash strings
_quote_all() { READLINE_LINE="${READLINE_LINE@Q}"; }
bind -m emacs-standard -x '"\C-x'\''":_quote_all'
bind -m vi-command -x '"'\''":_quote_all'
#bind -m vi-insert      -x '"\C-x'\''":_quote_all'

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

bind -m vi-insert -x '"\C-e":_edit_wo_executing'
bind -m vi-command -x '"\C-e":_edit_wo_executing'
bind -m emacs-standard -x '"\C-e\C-e":_edit_wo_executing'

# RLWRAP

#if hash rlwrap &> /dev/null; then
#    bind -m emacs-standard '"\C-x\C-e" : rlwrap-call-editor'
#    bind -m vi-command '"\C-e" : rlwrap-call-editor'
#    bind -m vi-insert '"\C-e" : rlwrap-call-editor'
#fi

if hash osc &>/dev/null; then
    
    function osc-copy() {
        if [[ -n $READLINE_MARK_SET ]]; then 
            if [[ $READLINE_MARK -gt $READLINE_POINT ]]; then
                local len=$(( $READLINE_MARK - $READLINE_POINT )) 
                echo -n "${READLINE_LINE:$READLINE_POINT:$len}" | osc copy
            else 
                local len=$(( $READLINE_POINT - $READLINE_MARK )) 
                echo -n "${READLINE_LINE:$READLINE_MARK:$len}" | osc copy
            fi
        else
            echo -n "$READLINE_LINE" | osc copy
        fi
        READLINE_MARK_SET=
    }
    
    function osc-paste() {
        if [[ -n $READLINE_MARK_SET ]]; then 
            if [[ $READLINE_MARK -gt $READLINE_POINT ]]; then 
                READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${READLINE_LINE:$READLINE_MARK}"
            else
                READLINE_LINE="${READLINE_LINE:0:$READLINE_MARK}${READLINE_LINE:$READLINE_POINT}"
            fi
        fi 
        local pasters="$(osc paste)"
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$pasters${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$((READLINE_POINT + ${#pasters}))
        READLINE_MARK_SET=
    }
    
    bind -m emacs-standard -x '"\C-s" : osc-copy'
    bind -m vi-command -x '"\C-s" : osc-copy'
    bind -m vi-insert -x '"\C-s" : osc-copy'

    # Ctrl-v: Proper paste
    bind -m emacs-standard -x '"\C-v": osc-paste'
    bind -m vi-command -x '"\C-v": osc-paste'
    bind -m vi-insert -x '"\C-v": osc-paste'

elif ([[ "$XDG_SESSION_TYPE" == 'x11' ]] && hash xclip &>/dev/null) || ([[ "$XDG_SESSION_TYPE" == 'wayland' ]] && hash wl-copy &> /dev/null); then
  
    function clip-copy() {
        if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then  
            if [[ -n $READLINE_MARK_SET ]]; then 
                if [[ $READLINE_MARK -gt $READLINE_POINT ]]; then
                    local len=$(( $READLINE_MARK - $READLINE_POINT )) 
                    echo -n "${READLINE_LINE:$READLINE_POINT:$len}" | xclip -i -sel c
                else 
                    local len=$(( $READLINE_POINT - $READLINE_MARK )) 
                    echo -n "${READLINE_LINE:$READLINE_MARK:$len}" | xclip -i -sel c
                fi
            else
                echo -n "$READLINE_LINE" | xclip -i -sel c
            fi
        elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
            if [[ -n $READLINE_MARK_SET ]]; then 
                if [[ $READLINE_MARK -gt $READLINE_POINT ]]; then
                    local len=$(( $READLINE_MARK - $READLINE_POINT )) 
                    echo -n "${READLINE_LINE:$READLINE_POINT:$len}" | wl-copy
                else 
                    local len = $(( $READLINE_POINT - $READLINE_MARK )) 
                    echo -n "${READLINE_LINE:$READLINE_MARK:$len}" | wl-copy
                fi
            else
                echo -n "$READLINE_LINE" | wl-copy
            fi
        fi
        READLINE_MARK_SET=
    }

    function clip-paste() {
        if [[ -n $READLINE_MARK_SET ]]; then 
            if [[ $READLINE_MARK -gt $READLINE_POINT ]]; then 
                READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${READLINE_LINE:$READLINE_MARK}"
            else
                READLINE_LINE="${READLINE_LINE:0:$READLINE_MARK}${READLINE_LINE:$READLINE_POINT}"
            fi
        fi  

        if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then  
            local pasters="$(xclip -o -sel c)"
        elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]]; then
            local pasters="$(wl-paste)"
        fi
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$pasters${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$((READLINE_POINT + ${#pasters}))
        READLINE_MARK_SET=
    }
    
    # Ctrl-s: Proper copy
    bind -m emacs-standard -x '"\C-s": clip-copy'
    bind -m vi-command -x '"\C-s": clip-copy'
    bind -m vi-insert -x '"\C-s": clip-copy'

    # There is a thing called 'bracketed-paste' and a readline function called `bracketed-paste-begin`/`bracketed-paste-end` which are supposed to paste the content inside a highlighted region (to show a possible ^M/newline escape sequence that automatically enters the code you paste), but i've got no clue whatsoever how to make that work with this sort of paste 
    # Chatgpt announced that bracketed-paste, using my pasting function, prevents trailing newlines from immediately executing by inserting it into the line by using READLINE_LINE instead of pasteing by feeding the line keystrokes
    # - for what that's worth??
    
    #bind -m emacs-standard -x '"\e199": clip-paste'
    #bind -m emacs-standard '"\C-v": "\x1b[200~\e199\x1b[201~'
    
    # Ctrl-v: Proper paste
    bind -m emacs-standard -x '"\C-v": clip-paste'
    bind -m vi-command -x '"\C-v": clip-paste'
    bind -m vi-insert -x '"\C-v": clip-paste'

fi

if hash autojump &>/dev/null; then
    # Ctrl-x Ctrl-j for autojump
    bind -m emacs-standard '"\C-x\C-j": "j \C-i"'
    bind -m vi-command '"\C-x\C-j": "j \C-i"'
    bind -m vi-insert '"\C-x\C-j": "j \C-i"'
fi

if hash fzf &>/dev/null; then
    
    #if [[ "$TERM" == 'xterm-kitty' ]]; then
    #    # (Kitty only) Ctrl-tab for fzf autocompletion
    #    bind -m emacs-standard '"\e[9;5u": " **\t"'
    #    bind -m vi-command '"\e[9;5u": " **\t"'
    #    bind -m vi-insert '"\e[9;5u": " **\t"'
    #fi

    if type ripgrep-dir &>/dev/null; then
        # Alt-g: Ripgrep function overview
        bind -m emacs-standard -x '"\C-g": "ripgrep-dir"'
        bind -m vi-command -x '"\C-g": "ripgrep-dir"'
        bind -m vi-insert -x '"\C-g": "ripgrep-dir"'
    fi

    if type fzf_rifle &>/dev/null; then
        # CTRL-F - Paste the selected file path into the command line
        bind -m emacs-standard -x '"\C-f": fzf_rifle'
        bind -m vi-command -x '"\C-f": fzf_rifle'
        bind -m vi-insert -x '"\C-f": fzf_rifle'

        # F4 - Rifle search
        bind -m emacs-standard -x '"\eOS": "fzf_rifle"'
        bind -m vi-command -x '"\eOS": "fzf_rifle"'
        bind -m vi-insert -x '"\eOS": "fzf_rifle"'
    fi
fi

# F2 - ranger (file explorer)
if hash ranger &>/dev/null; then
    bind -x '"\201": ranger'
    bind -m emacs-standard '"\eOQ": "\201\n\C-l"'
    bind -m vi-command '"\eOQ": "\201\n\C-l"'
    bind -m vi-insert '"\eOQ": "\201\n\C-l"'
fi

# F3 - lazygit (Git helper)
if hash lazygit &>/dev/null; then
    bind -x '"\202": stty sane && lazygit'
    bind -m emacs-standard '"\eOR": "\202\n\C-l"'
    bind -m vi-command '"\eOR": "\202\n\C-l"'
    bind -m vi-insert '"\eOR": "\202\n\C-l"'
fi

# F5, Ctrl-r - Reload .bashrc
bind '"\205": re-read-init-file'
bind -x '"\206": source ~/.bashrc'
if [[ -z "$BLE_VERSION" ]]; then
    bind -m emacs-standard '"\e[15~": "\C-e\C-u\205\206\n"'
    bind -m vi-command '"\e[15~": "\C-e\C-u\205\206\n"'
    bind -m vi-insert '"\e[15~": "\C-e\C-u\205\206\n"'
else 
    bind -m emacs-standard '"\e[15~": "\C-e\C-u\206\n"'
    bind -m vi-command '"\e[15~": "\C-e\C-u\206\n"'
    bind -m vi-insert '"\e[15~": "\C-e\C-u\206\n"'
fi


# F6 - (neo/fast/screen)fetch (System overview)
if hash neofetch &>/dev/null || hash fastfetch &>/dev/null || hash screenfetch &>/dev/null || hash onefetch &>/dev/null; then

    # Last one loaded is the winner
    if hash neofetch &>/dev/null; then
        bind -x '"\207": stty sane && neofetch'
        fetch="neofetch"
    fi

    if hash screenfetch &>/dev/null; then
        bind -x '"\207": stty sane && screenfetch'
        fetch="screenfetch"
    fi

    if hash fastfetch &>/dev/null; then
        bind -x '"\207": stty sane && fastfetch'
        fetch="fastfetch"
    fi

    if hash onefetch &>/dev/null; then
        if hash neofetch &>/dev/null || hash fastfetch &>/dev/null || hash screenfetch &>/dev/null; then
            bind -x '"\207": stty sane; hash git &> /dev/null && git rev-parse --git-dir &> /dev/null && readyn -p "Use onefetch? (lists github stats): " gstats && [[ $gstats == "y" ]] && onefetch || '"$fetch"' '
        else
            bind -x '"\207": stty sane && '"$fetch"''
        fi
    fi

    bind -m emacs-standard '"\e[17~": "\207\n"'
    bind -m vi-command '"\e[17~": "\207\n"'
    bind -m vi-insert '"\e[17~": "\207\n"'
fi
unset fetch

# F7 - Htop and alternatives

bind -x '"\208": stty sane && readyn -p "Start htop as root?" ansr && [[ "$ansr" == "y" ]] && sudo htop || htop'

# Last one loaded is the winner

if hash bashtop &>/dev/null || hash btop &>/dev/null || hash bpytop &>/dev/null; then

    if hash bpytop &>/dev/null; then
        bind -x '"\208": stty sane && readyn -p "Start htop as root?" ansr && [[ "$ansr" == "y" ]] && sudo htop || readyn -p "Use bpytop instead of htop?" ansr && [[ "$ansr" == "y" ]] && bpytop || htop'
    fi

    if hash bashtop &>/dev/null; then
        bind -x '"\208": stty sane && readyn -p "Start htop as root?" ansr && [[ "$ansr" == "y" ]] && sudo htop || readyn -p "Use bashtop instead of htop?" ansr && [[ "$ansr" == "y" ]] && bashtop || htop'
    fi

    if hash btop &>/dev/null; then
        bind -x '"\208": stty sane && readyn -p "Start btop as root?" ansr && [[ "$ansr" == "y" ]] && sudo btop || btop'
    fi

fi

bind -m emacs-standard '"\e[18~": "\208\n\C-l"'
bind -m vi-command '"\e[18~": "\208\n\C-l"'
bind -m vi-insert '"\e[18~": "\208\n\C-l"'

# F8 - Lazydocker (Docker TUI)
if hash lazydocker &>/dev/null; then

    bind -x '"\209": stty sane && lazydocker'
    bind -m emacs-standard '"\e[19~": "\209\n"'
    bind -m vi-command '"\e[19~": "\209\n"'
    bind -m vi-insert '"\e[19~": "\209\n"'
fi
