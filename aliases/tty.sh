 # TTY

# To see the complete character string sent by a key, you can use this command, and type the key within 2 seconds:
# stty raw; sleep 2; echo; stty cooked
# But Ctrl-v, then keycombination still works best

# Turn off flow control and free up Ctrl-s and Ctrl-q
stty -ixon
stty -ixoff
stty start 'undef' 
stty stop 'undef'
stty rprnt 'undef'
#stty lnext '^V'

# Unset suspend signal shortcut (Ctrl+z)
stty susp 'undef'

# unbinds ctrl-c and bind the function to ctrl-q
#stty intr '^q'    
