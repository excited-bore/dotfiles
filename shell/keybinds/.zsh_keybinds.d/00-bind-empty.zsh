#!/bin/zsh
# Shebang only there to trigger nvim's language server (if installed)

# Script binds certain keyboard combinations to nothing (and reset-mark because why not)
# Some keyboard combinations print out keycodes when pressed, this prevents that from happening 

keys=(
    "^[[1;2A"  # Shift+Up
    "^[[1;2B"  # Shift+Down
    "^[[1;2C"  # Shift+Right
    "^[[1;2D"  # Shift+Left
    "^[[1;3A"  # Alt+Up
    "^[[1;3B"  # Alt+Down
    "^[[1;3C"  # Alt+Right
    "^[[1;3D"  # Alt+Left
    "^[[1;4A"  # Shift+Alt+Up
    "^[[1;4B"  # Shift+Alt+Down
    "^[[1;4C"  # Shift+Alt+Right
    "^[[1;4D"  # Shift+Alt+Left
    "^[[1;5A"  # Ctrl+Up
    "^[[1;5B"  # Ctrl+Down
    "^[[1;5C"  # Ctrl+Right
    "^[[1;5D"  # Ctrl+Left
    "^[[1;7A"  # Ctrl+Alt+Up
    "^[[1;7B"  # Ctrl+Alt+Down
    "^[[1;7C"  # Ctrl+Alt+Right
    "^[[1;7D"  # Ctrl+Alt+Left
    "^[[1;8A"  # Ctrl+Shift+Alt+Up
    "^[[1;8B"  # Ctrl+Shift+Alt+Down
    "^[[1;8C"  # Ctrl+Shift+Alt+Right
    "^[[1;8D"  # Ctrl+Shift+Alt+Left
    "^[[1;9A"  # Super+Up 
    "^[[1;9B"  # Super+Down 
    "^[[1;9C"  # Super+Right 
    "^[[1;9D"  # Super+Left 
    "^[[1;10A" # Shift+Super+Up 
    "^[[1;10B" # Shift+Super+Down 
    "^[[1;10C" # Shift+Super+Right 
    "^[[1;10D" # Shift+Super+Left 
    "^[[1;11A" # Alt+Super+Up 
    "^[[1;11B" # Alt+Super+Down 
    "^[[1;11C" # Alt+Super+Right 
    "^[[1;11D" # Alt+Super+Left 
    "^[[1;12A" # Shift+Alt+Super+Up 
    "^[[1;12B" # Shift+Alt+Super+Down 
    "^[[1;12C" # Shift+Alt+Super+Right 
    "^[[1;12D" # Shift+Alt+Super+Left 
    "^[[1;13A" # Ctrl+Super+Up 
    "^[[1;13B" # Ctrl+Super+Down 
    "^[[1;13C" # Ctrl+Super+Right 
    "^[[1;13D" # Ctrl+Super+Left 
    "^[[1;14A" # Ctrl+Shift+Super+Up 
    "^[[1;14B" # Ctrl+Shift+Super+Down 
    "^[[1;14C" # Ctrl+Shift+Super+Right 
    "^[[1;14D" # Ctrl+Shift+Super+Left 
    "^[[1;15A" # Ctrl+Alt+Super+Up 
    "^[[1;15B" # Ctrl+Alt+Super+Down 
    "^[[1;15C" # Ctrl+Alt+Super+Right 
    "^[[1;15D" # Ctrl+Alt+Super+Left 
    "^[[1;16A" # Ctrl+Shift+Alt+Super+Up 
    "^[[1;16B" # Ctrl+Shift+Alt+Super+Down 
    "^[[1;16C" # Ctrl+Shift+Alt+Super+Right 
    "^[[1;16D" # Ctrl+Shift+Alt+Super+Left 


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
    "^[[6;2~"  # Shift+PageDown
    "^[[5;3~"  # Alt+PageUp
    "^[[6;3~"  # Alt+PageDown
    "^[[5;4~"  # Shift+Alt+PageUp
    "^[[6;4~"  # Shift+Alt+PageDown
    "^[[5;5~"  # Ctrl+PageUp
    "^[[6;5~"  # Ctrl+PageDown
    "^[[5;6~"  # Ctrl+Shift+PageUp
    "^[[6;6~"  # Ctrl+Shift+PageDown
    "^[[5;7~"  # Ctrl+Alt+PageUp
    "^[[6;7~"  # Ctrl+Alt+PageDown
    "^[[5;8~"  # Ctrl+Shift+Alt+PageUp
    "^[[6;8~"  # Ctrl+Shift+Alt+PageDown
    "^[[5;9~"  # Super+PageUp
    "^[[6;9~"  # Super+PageDown
    "^[[5;10~" # Shift+Super+PageUp
    "^[[6;10~" # Shift+Super+PageDown
    "^[[5;11~" # Alt+Super+PageUp
    "^[[6;11~" # Alt+Super+PageDown
    "^[[5;12~" # Shift+Alt+Super+PageUp
    "^[[6;12~" # Shift+Alt+Super+PageDown
    "^[[5;13~" # Ctrl+Super+PageUp
    "^[[6;13~" # Ctrl+Super+PageDown
    "^[[5;14~" # Ctrl+Shift+Super+PageUp
    "^[[6;14~" # Ctrl+Shift+Super+PageDown
    "^[[5;15~" # Ctrl+Alt+Super+PageUp
    "^[[6;15~" # Ctrl+Alt+Super+PageDown
    "^[[5;16~" # Ctrl+Shift+Alt+Super+PageUp
    "^[[6;16~" # Ctrl+Shift+Alt+Super+PageDown
)

function nothing(){}

zle -N nothing

for i in ${keys[@]}; do
    bindkey -M emacs $i nothing
    bindkey -M vicmd $i nothing
    bindkey -M viins $i nothing
done

unset keys
