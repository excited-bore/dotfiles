# Bash_aliases
# global bashrc -> /etc/bash.bashrc
# global shell profiles -> /etc/profile

# Set caps as AltGr
setxkbmap -option "lv3:caps_switch" 
# Set Shift delete to backspace
xmodmap -e "keycode 119 = Delete BackSpace"

## stty settings
# see with 'stty -a'
# unbinds ctrl-c and bind the function to ctrl-x
stty intr '^x'
stty start 'undef' 
stty stop 'undef'
stty susp 'undef'
#stty 'eol' 'home'

# python virtual env
#python3 -m venv python3
#source venv/bin/activate
