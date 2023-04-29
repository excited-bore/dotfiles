# Bash_aliases at ~/.bash_aliases.d/ 
# global bashrc -> /etc/bash.bashrc
# root shell profiles -> /etc/profile
# Other bindings at .inputrc

alias ls_xterm="xrdb -query -all"
alias ls_stty="stty -a"
alias ls_readline="bind -p | $PAGER"

alias ls_kitty='kitty +kitten show_key -m kitty'

alias r=". ~/.bashrc"

# Install bindings from xterm
# xrdb -merge ~/.Xresources
# .Inputrc (readline conf) however has to be compiled, so restart shell

# Set caps to Escape
#setxkbmap -option caps:escape

# Set Shift delete to backspace
##xmodmap -e "keycode 119 = Delete BackSpace"

## stty settings
# see with 'stty -a' 
# ^ control
#stty werase '[3;2~'

# unbinds ctrl-c and bind the function to ctrl-q
stty intr '^q'

# Turn off flow control and free up Ctr-s 
stty -ixon
stty -ixoff
stty start 'undef' 
stty stop 'undef'
stty rprnt 'undef'
stty lnext '^V'

#Free up Ctrl-z
stty susp 'undef'

alias tty_size_half="tput cup $(stty size | awk '{print int($1/2);}') 0"

#bind '"\C-o": "echo -ne \"\033[s\" \C-m"'

#bind -x '"\C-o": accept-line' 
#bind -x '"\C-l": "\C-u \C-e clear && tty_size_half && tput cuu1 && tput ed && ls && history -d -1 \C-m\C-y"'
#bind -x 

# python virtual env
#python3 -m venv python3
#source venv/bin/activate
