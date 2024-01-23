# !/bin/bash
 KEYBIND=~/.bashrc
 if [ -f ~/.keybinds.sh ]; then
    KEYBIND=~/.keybinds.sh
 fi
 KEYBIND_R=/root/.bashrc
 if sudo test -f /root/.keybinds.sh; then
     KEYBIND_R=/root/.keybinds.sh
 fi
