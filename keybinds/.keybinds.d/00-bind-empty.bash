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

keys=(
    "\e[1;2A"  # Shift+Up
    "\e[1;3A"  # Alt+Up
    "\e[1;5A"  # Ctrl+Up
    "\e[1;7A"  # Ctrl+Alt+Up
    "\e[1;2B"  # Shift+Down
    "\e[1;3B"  # Alt+Down
    "\e[1;5B"  # Ctrl+Down
    "\e[1;7B"  # Ctrl+Alt+Down
    "\e[1;2C"  # Shift+Right
    "\e[1;3C"  # Alt+Right
    "\e[1;5C"  # Ctrl+Right
    "\e[1;7C"  # Ctrl+Alt+Right
    "\e[1;2D"  # Shift+Left
    "\e[1;3D"  # Alt+Left
    "\e[1;5D"  # Ctrl+Left
    "\e[1;7D"  # Ctrl+Alt+Left
    
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
    "\e[5;3~"  # Alt+PageUp
    "\e[5;5~"  # Ctrl+PageUp
    "\e[5;7~"  # Ctrl+Alt+PageUp
    "\e[6;2~"  # Shift+PageDown
    "\e[6;3~"  # Alt+PageDown
    "\e[6;5~"  # Ctrl+PageDown
    "\e[6;7~"  # Ctrl+Alt+PageDown
)

for i in ${keys[@]}; do
    bind -m emacs-standard '"'$i'": "\e105"'
    bind -m vi-command '"'$i'": "i\e105\e"'
    bind -m vi-insert '"'$i'": "\e105"'
done

unset keys
