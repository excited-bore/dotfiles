#!/bin/bash

# Bash_aliases at ~/.bash_aliases.d/ 
# global bashrc -> /etc/bash.bashrc
# root shell profiles -> /etc/profile

# https://stackoverflow.com/questions/8366450/complex-keybinding-in-bash

alias list-binds-stty="stty -a"
alias list-binds-readline="{ printf \"\nList commands bound to keys\n\n\n\" ; bind -X ; echo; echo \"List key sequences that invoke macros and their values\"; echo; bind -S ; echo ;  echo \"List readline functions (possibly) bound to keys\"; bind -P; } | $PAGER"
alias list-binds-xterm="xrdb -query -all"
alias list-binds-kitty='kitty +kitten show_key -m kitty' 

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

X11_WAY="$(loginctl show-session $(awk '/tty/ {print $1}' <(loginctl)) -p Type | awk -F= '{print $2}')"

if test "$X11_WAY" == 'x11'; then
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

# Up and down arrow will now intelligently complete partially completed
# commands by searching through the existing history.
bind -m emacs-standard  '"\e[A": history-search-backward'
bind -m vi-command      '"\e[A": history-search-backward'
bind -m vi-insert       '"\e[A": history-search-backward'

bind -m emacs-standard  '"\e[B": history-search-forward'
bind -m vi-command      '"\e[B": history-search-forward'
bind -m vi-insert       '"\e[B": history-search-forward'

# Control left/right to jump from bigwords (ignore spaces when jumping) instead of chars
bind -m emacs-standard  '"\e[1;5D": vi-backward-bigword'
bind -m vi-command      '"\e[1;5D": vi-backward-bigword'
bind -m vi-insert       '"\e[1;5D": vi-backward-bigword'

bind -m emacs-standard  '"\e[1;5C": vi-forward-bigword'
bind -m vi-command      '"\e[1;5C": vi-forward-bigword'
bind -m vi-insert       '"\e[1;5C": vi-forward-bigword'

# Full path dirs
alias dirs="dirs -l"
alias dirs-col="dirs -v | column -c $COLUMNS"
alias dirs-col-pretty="dirs -v | column -c $COLUMNS | sed -e 's/ 0 \\([^\t]*\\)/'\${GREEN}' 0 \\1'\${normal}'/'"

#'Silent' clear
if type starship &> /dev/null && grep -q 'starship' ~/.bashrc && (grep -q  '\\n' ~/.config/starship.toml || grep -q 'line_break' ~/.config/starship.toml || ! head -n 1 ~/.config/starship.toml | grep -q 'format' ); then
    alias _="tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null"
    alias _.="tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i < \$(dirs -v | column -c \${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && dirs-col-pretty && history -d -1 &>/dev/null"
elif type starship &> /dev/null && grep -q 'starship' ~/.bashrc; then
    alias _="tput cuu1 && tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null"
    alias _.="tput cuu1 && tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i <= \$(dirs -v | column -c \${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && tput cuu1 && dirs-col-pretty && tput rc && history -d -1 &>/dev/null"
else
    alias _="tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null"
    alias _.="tput cuu1 && tput sc; clear && tput rc && for ((i = 0 ; i <= \$(dirs -v | column -c \${COLUMNS} | wc -l) ; i++)); do tput cuu1; done && dirs-col-pretty && tput rc && history -d -1 &>/dev/null"
fi

# 'dirs' builtins shows all directories in stack
# Ctrl-Up arrow rotates over directory history
bind -x '"\e277": pushd +1 &>/dev/null'
bind -m emacs-standard '"\e[1;5A": "\C-e\C-u\e277 _.\C-m"'
bind -m vi-command     '"\e[1;5A": "ddi\e277 _.\C-m"'
bind -m vi-insert      '"\e[1;5A": "\eddi\e277 _.\C-m"'

# Ctrl-Down -> Dir Down
#bind -x '"\e266": pushd $(dirs -p | awk '\''END { print }'\'') &>/dev/null'
bind -x '"\e266": cd ..'
bind -m emacs-standard '"\e[1;5B": "\C-e\C-u\e266 _.\C-m"'
bind -m vi-command     '"\e[1;5B": "ddi\C-u\e266 _.\C-m"'
bind -m vi-insert      '"\e[1;5B": "\eddi\e266 _.\C-m"'


# Ctrl-Down -> Rotate between 2 last directories
#bind -x '"\e266": pushd -1 &>/dev/null'
#bind -m emacs-standard '"\e[1;5B": "\C-e\C-u\e266 _.\C-m"'
#bind -m vi-command     '"\e[1;5B": "ddi\C-u\e266 _.\C-m"'
#bind -m vi-insert      '"\e[1;5B": "\eddi\e266 _.\C-m"'

# Shift left/right to jump from words instead of chars
bind -m emacs-standard  '"\e[1;2D": backward-word'
bind -m vi-command      '"\e[1;2D": backward-word'
bind -m vi-insert       '"\e[1;2D": backward-word'

bind -m emacs-standard  '"\e[1;2C": forward-word'
bind -m vi-command      '"\e[1;2C": forward-word'
bind -m vi-insert       '"\e[1;2C": forward-word'

alias __='clear && tput cup $(($LINE_TPUT+1)) $TPUT_COL && tput sc && tput cuu1 && echo "${PS1@P}" && tput cuu1'

# Shift up => Clean reset
#bind -x '"\e288": "cd \C-i"'
bind -x '"\e288": "__"'
bind -m emacs-standard  '"\e[1;2A": "\C-e\C-u\e288"'
bind -m vi-command      '"\e[1;2A": "ddi\e288"'
bind -m vi-insert       '"\e[1;2A": "\eddi\e288"'

# Shift down => cd shortcut
bind -m emacs-standard  '"\e[1;2B": "\C-e\C-u\e288cd \C-i"'
bind -m vi-insert       '"\e[1;2B": "\eddi\e288cd \C-i"'
bind -m vi-command      '"\e[1;2B": "\eddi\e288cd \C-i"'

# Shift left/right to jump from bigwords (ignore spaces when jumping) instead of chars
#bind -m emacs-standard -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bind -m vi-command     -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bind -m vi-insert      -x '"\e[1;2D": clear && let COL_TPUT=$COL_TPUT-1 && if [ $COL_TPUT -lt 0 ];then COL_TPUT=$COLUMNS;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#                                                                                 
#bind -m emacs-standard -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1' 
#bind -m vi-command     -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'
#bind -m vi-insert      -x '"\e[1;2C": clear && let COL_TPUT=$COL_TPUT+1 && if [ $COL_TPUT -gt $COLUMNS ];then COL_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && tput sc 1 && echo "${PS1@P}" && tput cuu1'

# Alt left/right to jump to beginning/end line instead of chars
bind -m emacs-standard  '"\e[1;3D": beginning-of-line'
bind -m vi-command      '"\e[1;3D": beginning-of-line'
bind -m vi-insert       '"\e[1;3D": beginning-of-line'

bind -m emacs-standard  '"\e[1;3C": end-of-line'
bind -m vi-command      '"\e[1;3C": end-of-line'
bind -m vi-insert       '"\e[1;3C": end-of-line'

# Alt up/down to change cursor line 
bind -m emacs-standard -x '"\e[1;3A": clear && let LINE_TPUT=$LINE_TPUT-1; if [ $LINE_TPUT -lt 0 ];then let LINE_TPUT=$LINES;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'
bind -m vi-command     -x '"\e[1;3A": clear && let LINE_TPUT=$LINE_TPUT-1; if [ $LINE_TPUT -lt 0 ];then let LINE_TPUT=$LINES;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'
bind -m vi-insert      -x '"\e[1;3A": clear && let LINE_TPUT=$LINE_TPUT-1; if [ $LINE_TPUT -lt 0 ];then let LINE_TPUT=$LINES;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'
                                  
bind -m emacs-standard -x '"\e[1;3B": clear && let LINE_TPUT=$LINE_TPUT+1; if [ $LINE_TPUT -gt $LINES ];then let LINE_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc' 
bind -m vi-command     -x '"\e[1;3B": clear && let LINE_TPUT=$LINE_TPUT+1; if [ $LINE_TPUT -gt $LINES ];then let LINE_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'
bind -m vi-insert      -x '"\e[1;3B": clear && let LINE_TPUT=$LINE_TPUT+1; if [ $LINE_TPUT -gt $LINES ];then let LINE_TPUT=0;fi && tput cup $LINE_TPUT $COL_TPUT && echo "${PS1@P}" && tput cuu1 && tput sc'
#
# Ctrl-w expands aliases
bind -m emacs-standard  '"\C-w": history-and-alias-expand-line'
bind -m vi-command      '"\C-w": history-and-alias-expand-line'
bind -m vi-insert       '"\C-w": history-and-alias-expand-line'

# Expand by looping through options
bind -m emacs-standard  'Tab: menu-complete'
bind -m vi-command      'Tab: menu-complete'
bind -m vi-insert       'Tab: menu-complete'

# Shift+Tab for reverse
bind -m emacs-standard  '"\e[Z": menu-complete-backward'
bind -m vi-command      '"\e[Z": menu-complete-backward'
bind -m vi-insert       '"\e[Z": menu-complete-backward'

# Ctrl-q quits terminal
bind -m emacs-standard -x '"\C-q": exit'
bind -m vi-command     -x '"\C-q": exit'
bind -m vi-insert      -x '"\C-q": exit'

# Ctrl+z is vi-undo (after being unbound in stty) instead of only on Ctrl+_
bind -m emacs-standard  '"\C-z": vi-undo'
bind -m vi-command      '"\C-z": vi-undo'
bind -m vi-insert       '"\C-z": vi-undo'

# Ctrl-backspace deletes (kills) line backward
bind -m emacs-standard  '"\C-h": backward-kill-word'
bind -m vi-command      '"\C-h": backward-kill-word'
bind -m vi-insert       '"\C-h": backward-kill-word'

# Ctrl-l clears
bind -m emacs-standard -x '"\C-l": __'
bind -m vi-command     -x '"\C-l": __'
bind -m vi-insert      -x '"\C-l": __'

# Ctrl-d: Delete first character on line
bind -m emacs-standard   '"\C-d": "\C-a\e[3~"'
bind -m vi-command       '"\C-d": "\e[1;3D\e[3~"'
bind -m vi-insert        '"\C-d": "\e[1;3D\e[3~"'

# Ctrl+b: (Ctrl+x Ctrl+b emacs mode) is quoted insert - Default Ctrl+v - Gives (f.ex. 'Ctrl-a') back as '^A'
bind -m emacs-standard  '"\C-x\C-b": quoted-insert'
bind -m vi-command      '"\C-b": quoted-insert'
bind -m vi-insert       '"\C-b": quoted-insert'

# Ctrl+o: Change from vi-mode to emacs mode and back
# This is also configured in ~/.fzf/shell/key-bindings-bash.sh if you have fzf keybinds installed
bind -m vi-command '"\C-o": emacs-editing-mode'
bind -m vi-insert '"\C-o": emacs-editing-mode'
bind -m emacs-standard '"\C-o": vi-editing-mode'

# vi-command ' / emacs C-x ' helps with adding quotes to bash strings
_quote_all() { READLINE_LINE="${READLINE_LINE@Q}"; }
bind -m emacs-standard -x '"\C-x'\''":_quote_all'
bind -m vi-command     -x '"'\''":_quote_all'
#bind -m vi-insert      -x '"\C-x'\''":_quote_all'

# https://unix.stackexchange.com/questions/85391/where-is-the-bash-feature-to-open-a-command-in-editor-documented
_edit_wo_executing() {
    local editor="${EDITOR:-nano}"
    tmpf="$(mktemp).sh"
    printf "#!$SHELL"'\n%s\n' "$READLINE_LINE" > "$tmpf"
    $EDITOR "$tmpf"
    # https://stackoverflow.com/questions/6675492/how-can-i-remove-all-newlines-n-using-sed
    #[ "$(sed -n '/^#!\/bin\/bash/p;q' "$tmpf")" ] && sed -i 1d "$tmpf"
    READLINE_LINE="$(<"$tmpf")"
    READLINE_POINT="${#READLINE_LINE}"
    command rm "$tmpf" &> /dev/null
}

bind -m vi-insert      -x '"\C-e":_edit_wo_executing'
bind -m vi-command     -x '"v":_edit_wo_executing'
bind -m vi-command     -x '"\C-e":_edit_wo_executing'
bind -m emacs-standard -x '"\C-e\C-e":_edit_wo_executing'

# RLWRAP 

#if type rlwrap &> /dev/null; then
#    bind -m emacs-standard '"\C-x\C-e" : rlwrap-call-editor' 
#    bind -m vi-command '"\C-e" : rlwrap-call-editor' 
#    bind -m vi-insert '"\C-e" : rlwrap-call-editor' 
#fi

if type osc &> /dev/null; then
    bind -m emacs-standard -x '"\C-s" : printf "$READLINE_LINE" | osc copy' 
    bind -m vi-command     -x '"\C-s" : printf "$READLINE_LINE" | osc copy' 
    bind -m vi-insert      -x '"\C-s" : printf "$READLINE_LINE" | osc copy'
   
    function osc-print-to-prompt(){
        pasters="$(osc paste)"
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$pasters${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + ${#pasters} ))
    }
     
    # Ctrl-v: Proper paste
    #Q="'"
    #bind -x $'"\237": echo bind $Q\\"\\\\225\\": \\"$(osc paste)\\"$Q > /tmp/paste.sh && source /tmp/paste.sh'
    bind -m emacs-standard -x '"\C-v": osc-print-to-prompt'
    bind -m vi-command     -x '"\C-v": osc-print-to-prompt'
    bind -m vi-insert      -x '"\C-v": osc-print-to-prompt'

elif type xclip &> /dev/null; then
    # Ctrl-s: Proper copy
    bind -m emacs-standard -x '"\C-s" : printf "$READLINE_LINE" | xclip -i -sel c' 
    bind -m vi-command     -x '"\C-s" : printf "$READLINE_LINE" | xclip -i -sel c' 
    bind -m vi-insert      -x '"\C-s" : printf "$READLINE_LINE" | xclip -i -sel c'
   
    function xclip-print-to-prompt(){
        pasters="$(xclip -o -sel c)"
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$pasters${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + ${#pasters} ))
    }
    
    # Ctrl-v: Proper paste
    bind -m emacs-standard -x '"\C-v": xclip-print-to-prompt'
    bind -m vi-command     -x '"\C-v": xclip-print-to-prompt'
    bind -m vi-insert      -x '"\C-v": xclip-print-to-prompt'
     
    #Q="'"
    #bind -x $'"\237": echo bind $Q\\"\\\\225\\": \\"$(xclip -o -sel c)\\"$Q > /tmp/paste.sh && source /tmp/paste.sh'
    #bind -m emacs-standard '"\C-v": "\237\225"'
    #bind -m vi-command     '"\C-v": "\237\225"'
    #bind -m vi-insert      '"\C-v": "\237\225"'
fi

if type autojump &> /dev/null; then
    # Ctrl-x Ctrl-j for autojump
    bind -m emacs-standard '"\C-x\C-j": "j \C-i"'
    bind -m vi-command     '"\C-x\C-j": "j \C-i"'
    bind -m vi-insert      '"\C-x\C-j": "j \C-i"'
fi

if type fzf &> /dev/null; then
    # (Kitty only) Ctrl-tab for fzf autocompletion
    bind -m emacs-standard '"\e[9;5u": " **\t"'
    bind -m vi-command     '"\e[9;5u": " **\t"'    
    bind -m vi-insert      '"\e[9;5u": " **\t"'

    if type ripgrep-dir &> /dev/null; then
        # Alt-g: Ripgrep function overview
        bind -m emacs-standard -x '"\C-g": "ripgrep-dir"'
        bind -m vi-command     -x '"\C-g": "ripgrep-dir"' 
        bind -m vi-insert      -x '"\C-g": "ripgrep-dir"'
    fi

    if type fzf_rifle &> /dev/null; then
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
if type ranger &> /dev/null; then
    bind -x '"\201": ranger'
    bind -m emacs-standard '"\eOQ": "\201\n\C-l"'
    bind -m vi-command     '"\eOQ": "\201\n\C-l"'
    bind -m vi-insert      '"\eOQ": "\201\n\C-l"'
fi

# F3 - lazygit (Git helper)
if type lazygit &> /dev/null; then
    bind -x '"\202": stty sane && lazygit'
    bind -m emacs-standard '"\eOR": "\202\n\C-l"'
    bind -m vi-command     '"\eOR": "\202\n\C-l"'
    bind -m vi-insert      '"\eOR": "\202\n\C-l"'
fi

# F5, Ctrl-r - Reload .bashrc
bind '"\205": re-read-init-file'
bind -x '"\206": source ~/.profile && source ~/.bashrc'
bind -m emacs-standard '"\e[15~": "\205\206"'
bind -m vi-command     '"\e[15~": "\205\206"'
bind -m vi-insert      '"\e[15~": "\205\206"'

# F6 - (neo/fast/screen)fetch (System overview)
if type neofetch &> /dev/null || type fastfetch &> /dev/null || type screenfetch &> /dev/null || type onefetch &> /dev/null; then
    
    # Last one loaded is the winner
    if type neofetch &> /dev/null; then
        bind -x '"\207": stty sane && neofetch'
        fetch="neofetch" 
    fi
    
    if type screenfetch &> /dev/null; then
        bind -x '"\207": stty sane && screenfetch'
        fetch="screenfetch" 
    fi
    
    if type fastfetch &> /dev/null; then
        bind -x '"\207": stty sane && fastfetch'
        fetch="fastfetch" 
    fi
 
    if type onefetch &> /dev/null; then
        if type neofetch &> /dev/null || type fastfetch &> /dev/null || type screenfetch &> /dev/null; then  
            bind -x '"\207": stty sane; type git &> /dev/null && git rev-parse --git-dir &> /dev/null && reade -Q "GREEN" -i "y" -p "Use onefetch? (lists github stats): " "n" gstats && test $gstats == "y" && onefetch || '"$fetch"' '
        else 
            bind -x '"\207": stty sane && '"$fetch"''
        fi
    fi

    bind -m emacs-standard '"\e[17~": "\207\n"'
    bind -m vi-command     '"\e[17~": "\207\n"'
    bind -m vi-insert      '"\e[17~": "\207\n"'
fi
unset fetch

# F7 - Htop and alternatives

bind -x '"\208": stty sane && readyn -p "Start htop as root?" ansr && test "$ansr" == "y" && sudo htop || htop'

# Last one loaded is the winner

if type bashtop &> /dev/null || type btop &> /dev/null || type bpytop &> /dev/null; then
    
    if type bpytop &> /dev/null; then
        bind -x '"\208": stty sane && readyn -p "Start htop as root?" ansr && test "$ansr" == "y" && sudo htop || readyn -p "Use bpytop instead of htop?" ansr && test "$ansr" == "y" && bpytop || htop'
    fi
    
    if type bashtop &> /dev/null; then
        bind -x '"\208": stty sane && readyn -p "Start htop as root?" ansr && test "$ansr" == "y" && sudo htop || readyn -p "Use bashtop instead of htop?" ansr && test "$ansr" == "y" && bashtop || htop'
    fi
    
    if type btop &> /dev/null; then
        bind -x '"\208": stty sane && readyn -p "Start btop as root?" ansr && test "$ansr" == "y" && sudo btop || btop'
    fi
    
fi

bind -m emacs-standard '"\e[18~": "\208\n\C-l"'
bind -m vi-command     '"\e[18~": "\208\n\C-l"'
bind -m vi-insert      '"\e[18~": "\208\n\C-l"'


# F8 - Lazydocker (Docker TUI)
if type lazydocker &> /dev/null; then
    
    bind -x '"\209": stty sane && lazydocker'
    bind -m emacs-standard '"\e[19~": "\209\n"'
    bind -m vi-command     '"\e[19~": "\209\n"'
    bind -m vi-insert      '"\e[19~": "\209\n"'
fi
