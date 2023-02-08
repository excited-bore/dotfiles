# Bash_aliases
# global bashrc -> /etc/bash.bashrc
# global shell profiles -> /etc/profile
# Other bindings at .inputrc

alias binds_xterm="xrdb -query -all"
alias binds_stty="stty -a"
alias binds_readline="bind -p | less"

exec /usr/bin/urxvt $@

alias r=". ~/.bashrc"

# Install bindings from xterm
# xrdb -merge ~/.Xresources
# .Inputrc (readline conf) however has to be compiled, so restart shell

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

alias tty_size_half="tput cup $(stty size | awk '{print int($1/2);}') 0"

#bind -x '"\C-o": accept-line' 
#bind -x '"\C-l": "\C-u \C-e clear && tty_size_half && tput cuu1 && tput ed && ls && history -d -1 \C-m\C-y"'
#bind -x 

# python virtual env
#python3 -m venv python3
#source venv/bin/activate
