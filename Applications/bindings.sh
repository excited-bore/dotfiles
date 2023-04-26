# Bash_aliases
# global bashrc -> /etc/bash.bashrc
# global shell profiles -> /etc/profile
# Other bindings at .inputrc

alias sttyBinds="stty -a"
alias readlineBinds="bind -p | less"

# Install bindings from xterm
 xrdb merge ~/.Xresources

# Set caps as Escape
#setxkbmap -option "escape:caps_switch" 

# Set caps to Escape
setxkbmap -option caps:escape

# Set Shift delete to backspace
xmodmap -e "keycode 119 = Delete BackSpace"

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
stty lnext '^'

#Free up Ctrl-z
stty susp 'undef'

#bind -x '"\C-o": accept-line' 
#bind -x '"\C-m": "\C-o tput cup $(stty size|awk '{print int($1/2);}') 0 && tput cuu1 && tput el && history -d -1 \C-o"'
#bind -x 

# python virtual env
#python3 -m venv python3
#source venv/bin/activate
