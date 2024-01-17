# Bash_aliases at ~/.bash_aliases.d/ 
# global bashrc -> /etc/bash.bashrc
# root shell profiles -> /etc/profile
# Other bindings at .inputrc

# https://stackoverflow.com/questions/8366450/complex-keybinding-in-bash

alias ls_binds="bind -p"

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
#stty lnext '^V'

# Unset suspend signal shortcut (Ctrl+z)
stty susp 'undef'

# Unset backward word erase shortcut (Ctrl+w)
stty werase 'undef'

# unbinds ctrl-c and bind the function to ctrl-q
#stty intr '^q'

#alias tty_size_half="tput cup $(stty size | awk '{print int($1/2);}') 0"

# READLINE

# \e : escape
# \M : Meta (alt)
# \t : tab
# \C : Ctrl
# \b : backspace
# nop => no operation, but 'redraw-current-line' might work better
# https://unix.stackexchange.com/questions/556703/how-to-bind-a-key-combination-to-null-in-inputrc
# 'bind -l' for all options
# 'bind -p' for all bindings
# You can also run 'read' (or 'cat' + Ctrl+v)
# That way you can read the characters escape sequences
# The ^[ indicates an escape character in your shell, so this means that your f.ex. Home key has an escape code of [1~ and you End key has an escape code of [4~. Since these escape codes are not listed in the default Readline configuration, you will need to add them: \e[1~ or \e[4~
# Also
# https://unix.stackexchange.com/questions/548726/bash-readline-inputrc-bind-key-to-a-sequence-of-multiple-commands 

# Up and down arrow will now intelligently complete partially completed
# commands by searching through the existing history.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Control left/right to jump from words instead of chars
bind '"\e[1;5D": backward-word'
bind '"\e[1;5C": forward-word'

#https://unix.stackexchange.com/questions/278884/save-cursor-position-and-restore-it-in-terminal
# Control up/down to change cursor line 
bind -x '"\e[1;5B": "clear && let LINE_TPUT=$LINE_TPUT+1 && if [ $LINE_TPUT -gt $LINES ];then LINE_TPUT=0;fi && tput cup $LINE_TPUT 0 && tput sc"'
bind -x '"\e[1;5A": "clear && let LINE_TPUT=$LINE_TPUT-1 && if [ $LINE_TPUT -lt 0 ];then LINE_TPUT=$LINES;fi && tput cup $LINE_TPUT 0 && tput sc"'
 

# Expand by looping through options
# Shift+tab for reverse
bind 'Tab: menu-complete'
bind '"\e[Z": menu-complete-backward'

# Ctrl-w expands aliases
bind '"\C-w": alias-expand-line'

# (Kitty) Ctrl-tab for fzf autocompletion
#bind '"\e[9;5u": " **\t"'

# Recall position
#bind -x '"\C-r": tput rc'

#Backup enter
bind '"\C-p": accept-line' 

#Silence output
alias _="stty -echo && tput cuu1 && history -d -1"

#Enter kills line, then clears screen, then yanks line to prompt and enters it
#bind '"\C-m": "\C-e\C-u\C-l _\C-p tput rc && stty echo && history -d -1 \C-p\C-y\C-p\C-r\e[A\e[B"'
#bind '"\C-m": "\C-e\C-u\C-l\C-y\C-p"'

#Store line position
#"\C-o": "tput sc && history -d -1 \C-m"

# Ctrl-l clears
bind -x '"\C-l": clear && tput cup $LINE_TPUT 0 && tput sc'

# Ctrl-q quits terminal
bind -x '"\C-q": exit'

# Undo to Ctrl+Z (unbound in tty) instead of only on Ctrl+_
bind '"\C-z": vi-undo'

# !Ctrl-g adds a piped grep for convenience
bind -x '"\C-g": " | grep "'

# Ctrl-Enter gives you a paged output
bind '"\e[13": " | $PAGER\C-p"' 

# Ctrl-backspace deletes (kills) line backward
bind '"\C-h": backward-kill-word'

# Ctrl-b Insert as comment (also on alt+#)
bind '"\C-b": insert-comment 1'

# Ctrl-n removes first character from command line (uncomment)
bind '"\C-n": "\C-a\e[3~"'

# Ctrl-o searches for a manual for the typed command 
bind '"\C-o": "\C-u man \C-y\C-m"'

# F2 - ranger (file explorer)
bind -x '"\201": ranger'
bind '"\eOQ": "\201\n\C-l"'
#bind -x '"\eOQ": ranger'

# F5, Ctrl-r - Reload .bashrc
#bind '"\e[15~": re-read-init-file'
bind -x '"\e[15~": . ~/.bashrc && tput cup 0 0 && tput rc'

# Alt-Left arrow to go up one directory
bind '"\e[1;3D": "cd .. \C-m"'

# Alt-Right arrow to go to last visited directory
bind '"\e[1;3C": "cd - \C-m"'

# Alt-Down arrow to go to home directory
bind '"\e[1;3B": "cd \C-m"'

# Alt-Up arrow to go to home directory
bind '"\e[1;3A": "j \C-i"'

# Proper copy
# https://askubuntu.com/questions/302263/selecting-text-in-the-terminal-without-using-the-mouse
#"\e-c": copy to clipboard
#bind '"\e-c": "\C-u\C-e echo \C-y | xclip -i -sel c && tput cuu1 && tput el && history -d -1 \C-m\C-y"'

#"\e-v": paste from clipboard
#bind '"\e-v": "\C-u\C-e tput cuu1 && tput el && xdotool type --clearmodifiers --delay 25 $(xclip -o -sel clip) && history -d -1 \C-m"'
#bind -x '"\e-v": "xclip -o -sel clip"'
