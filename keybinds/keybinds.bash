# Bash_aliases at ~/.bash_aliases.d/ 
# global bashrc -> /etc/bash.bashrc
# root shell profiles -> /etc/profile

# https://stackoverflow.com/questions/8366450/complex-keybinding-in-bash

alias ls-binds-tty="stty -a"
alias ls-binds-readline="bind -p | $PAGER"
alias ls-binds-xterm="xrdb -query -all"
alias ls-binds-kitty='kitty +kitten show_key -m kitty' 

# TTY

# To see the complete character string sent by a key, you can use this command, and type the key within 2 seconds:
# stty raw; sleep 2; echo; stty cooked
# But Ctrl-v, then keycombination still works best

# Turn off flow control and free up Ctrl-s and Ctrl-q
stty -ixon
stty -ixoff
stty start 'undef' 
stty stop 'undef'
stty rprnt 'undef'
stty lnext '^b'

# Unset suspend signal shortcut (Ctrl+z)
stty susp 'undef'

# Unset backward word erase shortcut (Ctrl+w)
stty werase 'undef'

# unbinds ctrl-c and bind the function to ctrl-s
stty intr '^c'


# XRESOURCES

# Install bindings from xterm
# xrdb -merge ~/.Xresources
# .Inputrc (readline conf) however has to be compiled, so restart shell

# Set caps to Escape
setxkbmap -option caps:escape

# Set Shift delete to backspace
# xmodmap -e "keycode 119 = Delete BackSpace"     

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

# Up and down arrow will now intelligently complete partially completed
# commands by searching through the existing history.
bind -m emacs-standard  '"\e[A": history-search-backward'
bind -m vi-command      '"\e[A": history-search-backward'
bind -m vi-insert       '"\e[A": history-search-backward'

bind -m emacs-standard  '"\e[B": history-search-forward'
bind -m vi-command      '"\e[B": history-search-forward'
bind -m vi-insert       '"\e[B": history-search-forward'

# Control left/right to jump from words instead of chars
bind -m emacs-standard  '"\e[1;5D": backward-word'
bind -m vi-command      '"\e[1;5D": backward-word'
bind -m vi-insert       '"\e[1;5D": backward-word'

bind -m emacs-standard  '"\e[1;5C": forward-word'
bind -m vi-command      '"\e[1;5C": forward-word'
bind -m vi-insert       '"\e[1;5C": forward-word'

# Control up/down to change cursor line 
bind -m emacs-standard -x '"\e[1;5A": clear && let LINE_TPUT=$LINE_TPUT-1 && if [ $LINE_TPUT -lt 0 ];then LINE_TPUT=$LINES;fi && tput cup $LINE_TPUT 0 && tput sc && echo "${PS1@P}" && tput cuu1'
bind -m vi-command     -x '"\e[1;5A": clear && let LINE_TPUT=$LINE_TPUT-1 && if [ $LINE_TPUT -lt 0 ];then LINE_TPUT=$LINES;fi && tput cup $LINE_TPUT 0 && tput sc && echo "${PS1@P}" && tput cuu1'
bind -m vi-insert      -x '"\e[1;5A": clear && let LINE_TPUT=$LINE_TPUT-1 && if [ $LINE_TPUT -lt 0 ];then LINE_TPUT=$LINES;fi && tput cup $LINE_TPUT 0 && tput sc && echo "${PS1@P}" && tput cuu1'

bind -m emacs-standard -x '"\e[1;5B": clear && let LINE_TPUT=$LINE_TPUT+1 && if [ $LINE_TPUT -gt $LINES ];then LINE_TPUT=0;fi && tput cup $LINE_TPUT 0 && tput sc && echo "${PS1@P}" && tput cuu1' 
bind -m vi-command     -x '"\e[1;5B": clear && let LINE_TPUT=$LINE_TPUT+1 && if [ $LINE_TPUT -gt $LINES ];then LINE_TPUT=0;fi && tput cup $LINE_TPUT 0 && tput sc && echo "${PS1@P}" && tput cuu1'
bind -m vi-insert      -x '"\e[1;5B": clear && let LINE_TPUT=$LINE_TPUT+1 && if [ $LINE_TPUT -gt $LINES ];then LINE_TPUT=0;fi && tput cup $LINE_TPUT 0 && tput sc && echo "${PS1@P}" && tput cuu1'

# Alt left/right to jump from words instead of chars
bind -m emacs-standard  '"\e[1;3D": beginning-of-line'
bind -m vi-command      '"\e[1;3D": beginning-of-line'
bind -m vi-insert       '"\e[1;3D": beginning-of-line'

bind -m emacs-standard  '"\e[1;3C": end-of-line'
bind -m vi-command      '"\e[1;3C": end-of-line'
bind -m vi-insert       '"\e[1;3C": end-of-line'

# Cd wrapper
function cd() {
    local push=1
    local j=0
    for i in $(dirs -l 2>/dev/null); do
        if test "$(realpath ${@: -1:1})" == "$i"; then
            push=0
            pushd -n +$j &>/dev/null
        fi
        j=$(($j+1));
    done
    if [ $push == 1 ]; then
        pushd "$PWD" &>/dev/null;  
    fi
    builtin cd -- "$@"; 
}
complete -F _cd cd


#'Silent' clear
if command -v 'starship' &> /dev/null && (grep -q  '\\n' ~/.config/starship.toml || grep -q 'line_break' ~/.config/starship.toml || ! head -n 1 ~/.config/starship.toml | grep -q 'format' ); then
    alias _="tput cuu1 && tput cuu1 && tput cuu1 && tput sc; clear && tput rc && history -d -1 &>/dev/null"
elif command -v 'starship' &> /dev/null; then
    alias _="tput cuu1 && tput cuu1 && tput sc && clear && tput rc && history -d -1 &>/dev/null"
else
    alias _="tput cuu1 && tput sc && clear && tput rc && history -d -1 &>/dev/null"
fi

# Alt-Up arrow rotates over directory history
bind -x '"\277": pushd +1 &>/dev/null'
bind -m emacs-standard '"\e[1;3A": "\C-e\C-u\277 _\C-m"'
bind -m vi-command     '"\e[1;3A": "\C-e\C-u\277 _\C-m"'
bind -m vi-insert      '"\e[1;3A": "\C-e\C-u\277 _\C-m"'

# Alt-Down -> Go up one directory
bind -x '"\266": cd .. &>/dev/null'
bind -m emacs-standard '"\e[1;3B": "\C-e\C-u\266 _\C-m"'
bind -m vi-command     '"\e[1;3B": "\C-e\C-u\266 _\C-m"'
bind -m vi-insert      '"\e[1;3B": "\C-e\C-u\266 _\C-m"'
                                         

# Ctrl-w expands aliases
bind -m emacs-standard  '"\C-w": alias-expand-line'
bind -m vi-command      '"\C-w": alias-expand-line'
bind -m vi-insert       '"\C-w": alias-expand-line'

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

# Undo to Ctrl+Z (unbound in tty) instead of only on Ctrl+_
bind -m emacs-standard  '"\C-z": vi-undo'
bind -m vi-command      '"\C-z": vi-undo'
bind -m vi-insert       '"\C-z": vi-undo'

# Ctrl-backspace deletes (kills) line backward
bind -m emacs-standard  '"\C-h": backward-kill-word'
bind -m vi-command      '"\C-h": backward-kill-word'
bind -m vi-insert       '"\C-h": backward-kill-word'

# Ctrl-l clears
bind -m emacs-standard -x '"\C-l": clear && tput cup $(($LINE_TPUT+1)) 0 && tput sc && tput cuu1 && echo "${PS1@P}" && tput cuu1'
bind -m vi-command     -x '"\C-l": clear && tput cup $(($LINE_TPUT+1)) 0 && tput sc && tput cuu1 && echo "${PS1@P}" && tput cuu1'
bind -m vi-insert      -x '"\C-l": clear && tput cup $(($LINE_TPUT+1)) 0 && tput sc && tput cuu1 && echo "${PS1@P}" && tput cuu1'

# Ctrl-d: Delete first character on line
bind -m emacs-standard   '"\C-d": "\C-a\e[3~"'
bind -m vi-command       '"\C-d": "\C-a\e[3~"'
bind -m vi-insert        '"\C-d": "\C-a\e[3~"'

_quote_all() { READLINE_LINE="${READLINE_LINE@Q}"; }
bind -m emacs-standard -x '"\C-x'\''":_quote_all'
bind -m vi-command     -x '"\C-x'\''":_quote_all'
bind -m vi-insert      -x '"\C-x'\''":_quote_all'

if test -x "$(command -v osc)"; then
    bind -m emacs-standard -x '"\C-s" : echo "$READLINE_LINE" | osc copy' 
    bind -m vi-command     -x '"\C-s" : echo "$READLINE_LINE" | osc copy' 
    bind -m vi-insert      -x '"\C-s" : echo "$READLINE_LINE" | osc copy'

    # Ctrl-v: Proper paste
    Q="'"
    bind -x $'"\237": echo bind $Q\\"\\\\225\\": \\"$(osc paste)\\"$Q > /tmp/paste.sh && source /tmp/paste.sh'
    bind -m emacs-standard '"\C-v": "\237\225"'
    bind -m vi-command     '"\C-v": "\237\225"'
    bind -m vi-insert      '"\C-v": "\237\225"'
elif test -x "$(command -v xclip)"; then
    # Ctrl-s: Proper copy
    bind -m emacs-standard -x '"\C-s" : echo "$READLINE_LINE" | xclip -i -sel c' 
    bind -m vi-command     -x '"\C-s" : echo "$READLINE_LINE" | xclip -i -sel c' 
    bind -m vi-insert      -x '"\C-s" : echo "$READLINE_LINE" | xclip -i -sel c'

    # Ctrl-v: Proper paste
    Q="'"
    bind -x $'"\237": echo bind $Q\\"\\\\225\\": \\"$(xclip -o -sel c)\\"$Q > /tmp/paste.sh && source /tmp/paste.sh'
    bind -m emacs-standard '"\C-v": "\237\225"'
    bind -m vi-command     '"\C-v": "\237\225"'
    bind -m vi-insert      '"\C-v": "\237\225"'
fi

if test -x "$(command -v autojump)"; then
    # Ctrl-x Ctrl-j for autojump
    bind -m emacs-standard '"\C-x\C-j": "j \C-i"'
    bind -m vi-command     '"\C-x\C-j": "j \C-i"'
    bind -m vi-insert      '"\C-x\C-j": "j \C-i"'
fi

if test -x "$(command -v fzf)"; then
    # (Kitty only) Ctrl-tab for fzf autocompletion
    bind -m emacs-standard '"\e[9;5u": " **\t"'
    bind -m vi-command     '"\e[9;5u": " **\t"'
    bind -m vi-insert      '"\e[9;5u": " **\t"'


    
    if [[ "$(type -t ripgrep-dir)" == function ]]; then
        # Alt-g: Ripgrep function overview
        bind -m emacs-standard -x '"\eg": "ripgrep-dir"'
        bind -m vi-command     -x '"\eg": "ripgrep-dir"' 
        bind -m vi-insert      -x '"\eg": "ripgrep-dir"'
    fi

    if [[ "$(type -t fzf_rifle)" == function ]]; then
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
if [ -x "$(command -v ranger)" ]; then
    bind -x '"\201": ranger'
    bind -m emacs-standard '"\eOQ": "\201\n\C-l"'
    bind -m vi-command     '"\eOQ": "\201\n\C-l"'
    bind -m vi-insert      '"\eOQ": "\201\n\C-l"'
fi

# F3 - lazygit (Git helper)
if [ -x "$(command -v lazygit)" ]; then
    bind -x '"\202": stty sane && lazygit'
    bind -m emacs-standard '"\eOR": "\202\n\C-l"'
    bind -m vi-command     '"\eOR": "\202\n\C-l"'
    bind -m vi-insert      '"\eOR": "\202\n\C-l"'
fi

# F3 - FuzzyFinderls -l | fzf --preview="echo user={3} when={-4..-2}; cat {-1}" --header-lines=1 (file explorer)
#bind -x '"\eOR": ctrl-s'

# F5, Ctrl-r - Reload .bashrc
bind '"\205": re-read-init-file'
bind -x '"\206": source ~/.bashrc'
bind -m emacs-standard '"\e[15~": "\205\206"'
bind -m vi-command     '"\e[15~": "\205\206"'
bind -m vi-insert      '"\e[15~": "\205\206"'
