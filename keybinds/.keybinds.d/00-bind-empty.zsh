#!/bin/zsh
# Shebang only there to trigger nvim's language server (if installed)

# Script binds certain keyboard combinations to nothing (and reset-mark because why not)
# Some keyboard combinations print out keycodes when pressed, this prevents that from happening 

keys=(
    "^[[1;2A"  # Shift+Up
    "^[[1;3A"  # Alt+Up
    "^[[1;5A"  # Ctrl+Up
    "^[[1;7A"  # Ctrl+Alt+Up
    "^[[1;2B"  # Shift+Down
    "^[[1;3B"  # Alt+Down
    "^[[1;5B"  # Ctrl+Down
    "^[[1;7B"  # Ctrl+Alt+Down
    "^[[1;2C"  # Shift+Right
    "^[[1;3C"  # Alt+Right
    "^[[1;5C"  # Ctrl+Right
    "^[[1;7C"  # Ctrl+Alt+Right
    "^[[1;2D"  # Shift+Left
    "^[[1;3D"  # Alt+Left
    "^[[1;5D"  # Ctrl+Left
    "^[[1;7D"  # Ctrl+Alt+Left
    
    "^[[OP"    # F1 
    "^[[1;3P"  # Alt+F1 
    "^[[1;4P"  # Shift+Alt+F1 
    "^[[OQ"    # F2 
    "^[[1;3Q"  # Alt+F2 
    "^[[1;4Q"  # Shift+Alt+F2 
    "^[[OR"    # F3 
    "^[[13;3~" # Alt+F3 
    "^[[13;4~" # Shift+Alt+F3 
    "^[[OS"    # F4 
    "^[[1;3S"  # Alt+F4 
    "^[[1;4S"  # Shift+Alt+F4 
    "^[[15~"   # F5 
    "^[[15;3~" # Alt+F5 
    "^[[15;4~" # Shift+Alt+F5 
    "^[[17~"   # F6 
    "^[[17;3~" # Alt+F6 
    "^[[17;4~" # Alt+F6 
    "^[[18~"   # F7 
    "^[[18;3~" # Alt+F7 
    "^[[18;4~" # Shift+Alt+F7 
    "^[[19~"   # F8 
    "^[[18;3~" # Alt+F8 
    "^[[20~"   # F9 
    "^[[19;3~" # Alt+F9 
    "^[[21~"   # F10 
    "^[[20;3~" # Alt+F10 
    "^[[23~"   # F11 
    "^[[21;3~" # Alt+F11 
    "^[[24~"   # F12 
    "^[[22;3~" # Alt+F12 
   
    "^[[2;4~"  # Shift+Alt+Insert
    "^[[2;5~"  # Ctrl+Insert
    "^[[2;6~"  # Ctrl+Shift+Insert
    "^[[2;7~"  # Ctrl+Alt+Insert
    "^[[3;2~"  # Shift+Delete
    "^[[3;4~"  # Shift+Alt+Delete
    "^[[1;4H"  # Shift+Alt+Home
    "^[[1;4F"  # Shift+Alt+End

    "^[[5~"    # PageUp 
    "^[[6~"    # PageDown 
    "^[[5;2~"  # Shift+PageUp
    "^[[5;3~"  # Alt+PageUp
    "^[[5;5~"  # Ctrl+PageUp
    "^[[5;7~"  # Ctrl+Alt+PageUp
    "^[[6;2~"  # Shift+PageDown
    "^[[6;3~"  # Alt+PageDown
    "^[[6;5~"  # Ctrl+PageDown
    "^[[6;7~"  # Ctrl+Alt+PageDown
)

function nothing(){}

zle -N nothing

for i in ${keys[@]}; do
    bindkey -M emacs $i nothing
    bindkey -M vicmd $i nothing
    bindkey -M viins $i nothing
done

unset keys
