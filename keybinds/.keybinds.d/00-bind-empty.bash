#!/bin/bash
# Shebang only there to trigger nvim's language server (if installed)

# Script binds certain keyboard combinations to nothing (and reset-mark because why not)
# Some keyboard combinations print out keycodes when pressed, this prevents that from happening 

READLINE_MARK_SET=''

function reset-mark(){
   READLINE_MARK=$READLINE_POINT 
   unset READLINE_MARK_SET
   if [[ -n $CTRL_ALT_LEFTM ]]; then
       bind -m $CTRL_ALT_KM $CTRL_ALT_LEFTX "\"\e[1;3D\": \"$CTRL_ALT_LEFTM\""
       unset CTRL_ALT_LEFTM CTRL_ALT_LEFTX 
   fi
   if [[ -n $CTRL_ALT_RIGHTM ]]; then
       bind -m $CTRL_ALT_KM $CTRL_ALT_RIGHTX "\"\e[1;3C\": \"$CTRL_ALT_RIGHTM\""
       unset CTRL_ALT_RIGHTM CTRL_ALT_RIGHTX 
   fi
   if [[ -n $BACKSM ]]; then
       bind -m $CTRL_ALT_KM $BACKSX "\"\e[3~\": \"$BACKSM\""
       unset BACKSM BACKSX 
   fi
    
}

bind -m emacs-standard -x '"\e105": reset-mark'
bind -m vi-command -x '"\e105": reset-mark'
bind -m vi-insert -x '"\e105": reset-mark'

# Super = Windowskey/Command

keys=(
    "\e[1;2A"  # Shift+Up
    "\e[1;2B"  # Shift+Down
    "\e[1;2C"  # Shift+Right
    "\e[1;2D"  # Shift+Left
    "\e[1;3A"  # Alt+Up
    "\e[1;3B"  # Alt+Down
    "\e[1;3C"  # Alt+Right
    "\e[1;3D"  # Alt+Left
    "\e[1;4A"  # Shift+Alt+Up
    "\e[1;4B"  # Shift+Alt+Down
    "\e[1;4C"  # Shift+Alt+Right
    "\e[1;4D"  # Shift+Alt+Left
    "\e[1;5A"  # Ctrl+Up
    "\e[1;5B"  # Ctrl+Down
    "\e[1;5C"  # Ctrl+Right
    "\e[1;5D"  # Ctrl+Left
    "\e[1;7A"  # Ctrl+Alt+Up
    "\e[1;7B"  # Ctrl+Alt+Down
    "\e[1;7C"  # Ctrl+Alt+Right
    "\e[1;7D"  # Ctrl+Alt+Left
    "\e[1;8A"  # Ctrl+Shift+Alt+Up
    "\e[1;8B"  # Ctrl+Shift+Alt+Down
    "\e[1;8C"  # Ctrl+Shift+Alt+Right
    "\e[1;8D"  # Ctrl+Shift+Alt+Left
    "\e[1;9A"  # Super+Up 
    "\e[1;9B"  # Super+Down 
    "\e[1;9C"  # Super+Right 
    "\e[1;9D"  # Super+Left 
    "\e[1;10A" # Shift+Super+Up 
    "\e[1;10B" # Shift+Super+Down 
    "\e[1;10C" # Shift+Super+Right 
    "\e[1;10D" # Shift+Super+Left 
    "\e[1;11A" # Alt+Super+Up 
    "\e[1;11B" # Alt+Super+Down 
    "\e[1;11C" # Alt+Super+Right 
    "\e[1;11D" # Alt+Super+Left 
    "\e[1;12A" # Shift+Alt+Super+Up 
    "\e[1;12B" # Shift+Alt+Super+Down 
    "\e[1;12C" # Shift+Alt+Super+Right 
    "\e[1;12D" # Shift+Alt+Super+Left 
    "\e[1;13A" # Ctrl+Super+Up 
    "\e[1;13B" # Ctrl+Super+Down 
    "\e[1;13C" # Ctrl+Super+Right 
    "\e[1;13D" # Ctrl+Super+Left 
    "\e[1;14A" # Ctrl+Shift+Super+Up 
    "\e[1;14B" # Ctrl+Shift+Super+Down 
    "\e[1;14C" # Ctrl+Shift+Super+Right 
    "\e[1;14D" # Ctrl+Shift+Super+Left 
    "\e[1;15A" # Ctrl+Alt+Super+Up 
    "\e[1;15B" # Ctrl+Alt+Super+Down 
    "\e[1;15C" # Ctrl+Alt+Super+Right 
    "\e[1;15D" # Ctrl+Alt+Super+Left 
    "\e[1;16A" # Ctrl+Shift+Alt+Super+Up 
    "\e[1;16B" # Ctrl+Shift+Alt+Super+Down 
    "\e[1;16C" # Ctrl+Shift+Alt+Super+Right 
    "\e[1;16D" # Ctrl+Shift+Alt+Super+Left 


    "\e[OP"    # F1 
    "\e[1;3P"  # Alt+F1 
    "\e[1;4P"  # Shift+Alt+F1 
    "\e[OQ"    # F2 
    "\e[1;3Q"  # Alt+F2 
    "\e[1;4Q"  # Shift+Alt+F2 
    "\e[OR"    # F3 
    "\e[13;3~" # Alt+F3 
    "\e[13;4~" # Shift+Alt+F3 
    "\e[OS"    # F4 
    "\e[1;3S"  # Alt+F4 
    "\e[1;4S"  # Shift+Alt+F4 
    "\e[15~"   # F5 
    "\e[15;3~" # Alt+F5 
    "\e[15;4~" # Shift+Alt+F5 
    "\e[17~"   # F6 
    "\e[17;3~" # Alt+F6 
    "\e[17;4~" # Alt+F6 
    "\e[18~"   # F7 
    "\e[18;3~" # Alt+F7 
    "\e[18;4~" # Shift+Alt+F7 
    "\e[19~"   # F8 
    "\e[18;3~" # Alt+F8 
    "\e[20~"   # F9 
    "\e[19;3~" # Alt+F9 
    "\e[21~"   # F10 
    "\e[20;3~" # Alt+F10 
    "\e[23~"   # F11 
    "\e[21;3~" # Alt+F11 
    "\e[24~"   # F12 
    "\e[22;3~" # Alt+F12 
   
    "\e[2;4~"  # Shift+Alt+Insert
    "\e[2;5~"  # Ctrl+Insert
    "\e[2;6~"  # Ctrl+Shift+Insert
    "\e[2;7~"  # Ctrl+Alt+Insert
    "\e[3;2~"  # Shift+Delete
    "\e[3;4~"  # Shift+Alt+Delete
    "\e[1;4H"  # Shift+Alt+Home
    "\e[1;4F"  # Shift+Alt+End

    "\e[5~"    # PageUp 
    "\e[6~"    # PageDown 
    "\e[5;2~"  # Shift+PageUp
    "\e[6;2~"  # Shift+PageDown
    "\e[5;3~"  # Alt+PageUp
    "\e[6;3~"  # Alt+PageDown
    "\e[5;4~"  # Shift+Alt+PageUp
    "\e[6;4~"  # Shift+Alt+PageDown
    "\e[5;5~"  # Ctrl+PageUp
    "\e[6;5~"  # Ctrl+PageDown
    "\e[5;6~"  # Ctrl+Shift+PageUp
    "\e[6;6~"  # Ctrl+Shift+PageDown
    "\e[5;7~"  # Ctrl+Alt+PageUp
    "\e[6;7~"  # Ctrl+Alt+PageDown
    "\e[5;8~"  # Ctrl+Shift+Alt+PageUp
    "\e[6;8~"  # Ctrl+Shift+Alt+PageDown
    "\e[5;9~"  # Super+PageUp
    "\e[6;9~"  # Super+PageDown
    "\e[5;10~" # Shift+Super+PageUp
    "\e[6;10~" # Shift+Super+PageDown
    "\e[5;11~" # Alt+Super+PageUp
    "\e[6;11~" # Alt+Super+PageDown
    "\e[5;12~" # Shift+Alt+Super+PageUp
    "\e[6;12~" # Shift+Alt+Super+PageDown
    "\e[5;13~" # Ctrl+Super+PageUp
    "\e[6;13~" # Ctrl+Super+PageDown
    "\e[5;14~" # Ctrl+Shift+Super+PageUp
    "\e[6;14~" # Ctrl+Shift+Super+PageDown
    "\e[5;15~" # Ctrl+Alt+Super+PageUp
    "\e[6;15~" # Ctrl+Alt+Super+PageDown
    "\e[5;16~" # Ctrl+Shift+Alt+Super+PageUp
    "\e[6;16~" # Ctrl+Shift+Alt+Super+PageDown
)

for i in ${keys[@]}; do
    bind -m emacs-standard '"'$i'": "\e105"'
    bind -m vi-command '"'$i'": "i\e105\e"'
    bind -m vi-insert '"'$i'": "\e105"'
done

unset keys
