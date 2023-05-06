 # XRESOURCES

alias ls_xterm="xrdb -query -all"

# Resource bindings for Xterm
# xrdb -merge ~/.Xresources

# Set caps to Escape
setxkbmap -option caps:escape

# Set Shift delete to backspace
##xmodmap -e "keycode 119 = Delete BackSpace"
