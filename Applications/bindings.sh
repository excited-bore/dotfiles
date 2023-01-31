# Bash_aliases
# global bashrc -> /etc/bash.bashrc
# global shell profiles -> /etc/profile

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

# unbinds ctrl-c and bind the function to ctrl-x
stty intr '^x'

# Turn off flow control
stty -ixon
stty -ixoff
stty start 'undef' 
stty stop 'undef'

#Free up Ctrl-z
stty susp 'undef'
#stty 'eol' 'home'

# python virtual env
#python3 -m venv python3
#source venv/bin/activate
