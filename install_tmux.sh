#!/bin/bash
. ./checks/check_distro.sh
. ./readline/rlwrap_scripts.sh


if [ ! -x "$(command -v tmux)" ]; then
    if [ $distro_base == "Arch" ]; then
        yes | sudo pacman -Syu tmux
    elif [ $distro_base == "Debian" ]; then
        yes | sudo apt update
        yes | sudo apt install tmux
    fi
fi

if [ ! -d ~/.bash_aliases.d/ ]; then
   mkdir ~/.bash_aliases.d/    
fi

if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then
    echo "if [[ -d ~/.bash_aliases.d/ ]]; then" >> ~/.bashrc
    echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
    echo "      . \"\$alias\" " >> ~/.bashrc
    echo "  done" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

# Fix tmux not sourcing .bashrc
# https://unix.stackexchange.com/questions/320465/new-tmux-sessions-do-not-source-bashrc-filehttps://unix.stackexchange.com/questions/320465/new-tmux-sessions-do-not-source-bashrc-filehttps://unix.stackexchange.com/questions/320465/new-tmux-sessions-do-not-source-bashrc-filehttps://unix.stackexchange.com/questions/320465/new-tmux-sessions-do-not-source-bashrc-file

if [ ! -f ~/.profile ]; then
   touch ~/.profile    
fi

if ! grep -q ".bashrc" ~/.profile; then
   echo "if [ -n \"\$BASH_VERSION\" -a -n \"\$PS1\" ]; then" >> ~/.profile
   echo "   # include .bashrc if it exists" >> ~/.profile
   echo "   if [ -f \"\$HOME/.bashrc\" ]; then" >> ~/.profile
   echo "       . \"\$HOME/.bashrc\"" >> ~/.profile
   echo "   fi" >> ~/.profile
   echo "fi" >> ~/.profile 
fi


reade -Q "GREEN" -i "y" -p "Install tmux.sh at ~/.bash_aliases.d/? (tmux aliases) [Y/n]:" "y n"  tmuxx
if [ -z "$tmuxx" ] || [ "$tmuxx"  == "y" ]; then 
    cp -f tmux/tmux.sh ~/.bash_aliases.d/
    if ! grep -q tmux.sh ~/.bashrc; then
        echo "if [[ -f ~/Applications/tmux.sh ]]; then" >> ~/.bashrc
        echo "  . ~/Applications/tmux.sh" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
fi
unset tmuxx

sed -i 's|^set -g @plugin|#set -g @plugin|g' tmux/.tmux.conf
sed -i 's|^run '\''~/.tmux/plugins/tpm/tpm'\''|#run '\''~/.tmux/plugins/tpm/tpm'\''|g' tmux/.tmux.conf
sed -i 's|set -g @continuum-restore '\''on'\''|#set -g @continuum-restore '\''on'\''|g' tmux/.tmux.conf

reade -Q "GREEN" -i "y" -p "Install tmux.conf? (tmux conf at ~/.tmux.conf) [Y/n]:" "y n" tmuxc
if [ "$tmuxc"  == "y" ] || [ -z "$tmuxc" ]; then
    cp -f tmux/.tmux.conf ~/
    tmux source-file ~/.tmux.conf
fi
unset tmuxc


reade -Q "GREEN" -i "y" -p "Install tmux plugin manager? (tpm) [Y/n]:" "y n"  tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    sed -i 's|#set -g @plugin '\''tmux-plugins/tpm'\''|set -g @plugin '\''tmux-plugins/tpm'\''|g' ~/.tmux.conf
    sed -i 's|#run '\''~/.tmux/plugins/tpm/tpm'\''|run '\''~/.tmux/plugins/tpm/tpm'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tpm'" ~/.tmux.conf; then
         echo "# Plugin Manager" >> ~/.tmux.conf
         echo "set -g @plugin 'tmux-plugins/tpm'" >> ~/.tmux.conf
         echo "run '~/.tmux/plugins/tpm/tpm'" >> ~/.tmux.conf
    fi
fi
unset tmuxx


reade -Q "GREEN" -i "y" -p "Install tmux clipboard plugin? (tmux-yank) [Y/n]:" "y n"  tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    if [ ! -x "$(command -v xclip)" ] && [ ! -x "$(command -v xsel)" ]; then
        if [ $distro_base == "Arch" ]; then
            yes | sudo pacman -Syu xclip xsel
        elif [ $distro_base == "Debian" ]; then
            yes | sudo apt update
            yes | sudo apt install xclip xsel
        fi
    fi
    sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-yank'\''|set -g @plugin '\''tmux-plugins/tmux-yank'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tmux-yank'" ~/.tmux.conf; then
         echo "# Clipboard " >> ~/.tmux.conf
         echo "set -g @plugin 'tmux-plugins/tmux-yank'" >> ~/.tmux.conf
    fi
fi
unset tmuxx

reade -Q "GREEN" -i "y" -p "Install tmux sensible settings plugin? (tmux-sensible) [Y/n]:" "y n"  tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-sensible'\''|set -g @plugin '\''tmux-plugins/tmux-sensible'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tmux-sensible'" ~/.tmux.conf; then
         echo "# Like vim-sensible, just good settings to have overall" >> ~/.tmux.conf
         echo "set -g @plugin 'tmux-plugins/tmux-sensible'" >> ~/.tmux.conf
    fi
fi
unset tmuxx

reade -Q "GREEN" -i "y" -p "Install tmux savepoint plugin? (tmux-resurrect) [Y/n]:" "y n"  tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-resurrect'\''|set -g @plugin '\''tmux-plugins/tmux-resurrect'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tmux-resurrect'" ~/.tmux.conf; then
         echo "# Restore tmux environment with savepoints" >> ~/.tmux.conf
         echo "set -g @plugin 'tmux-plugins/tmux-resurrect'" >> ~/.tmux.conf
    fi
    reade -Q "GREEN" -i "y" -p "Install automatic tmux savepoint plugin? (tmux-continuum) [Y/n]:" "y n"  tmuxx
    if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
        sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-continuum'\''|set -g @plugin '\''tmux-plugins/tmux-continuum'\''|g' ~/.tmux.conf
        sed -i 's|#set -g @continuum-restore '\''on'\''|set -g @continuum-restore '\''on'\''|g' ~/.tmux.conf
        if ! grep -q "set -g @plugin 'tmux-plugins/tmux-continuum'" ~/.tmux.conf; then
            echo "# Restore tmux environment on restart" >> ~/.tmux.conf
            echo "set -g @plugin 'tmux-plugins/tmux-continuum'" >> ~/.tmux.conf
            echo "set -g @continuum-restore '\''on'\''" >> ~/.tmux.conf
        fi
    fi
    unset tmuxx
fi
unset tmuxx


#awk '$0=="#run '\''~/.tmux/plugins/tpm/tpm'\''"{lastline=$0;next}{print $0}END{print lastline}' ~/.tmux.conf > ~/.tmux.conf
#awk '$0=="run '\''~/.tmux/plugins/tpm/tpm'\''"{lastline=$0;next}{print $0}END{print lastline}' ~/.tmux.conf > ~/.tmux.conf


if [ -x "$(command -v ranger)" ]; then
    reade -Q "GREEN" -i "y" -p "Install ranger tmux plugin? (ranger_tmux) [Y/n]:" "y n"  tmuxx
    if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
        if [ ! -x "$(command -v pip)" ]; then
            if [ $distro_base == "Arch" ]; then
                yes | sudo pacman -Syu python-pip
            elif [ $distro_base == "Debian" ]; then
                yes | sudo apt update
                yes | sudo apt install python3-pip
            fi
        fi
        pip install --break-system-packages ranger_tmux
        python3 -m ranger_tmux --tmux install
        
        sed -i 's|#set tmux_cwd_sync .*|set tmux_cwd_sync true|g' ~/.config/ranger/rc.conf
        sed -i 's|#set tmux_cwd_track .*|set tmux_cwd_track true|g' ~/.config/ranger/rc.conf
        if ! grep -q "set tmux_cwd_sync" ~/.config/ranger/rc.conf; then
            echo "# When True, ranger's current directory is synced to the other pane" >> ~/.config/ranger/rc.conf
            echo "set tmux_cwd_sync true" >> ~/.config/ranger/rc.conf
            echo "# When True, ranger's current directory tracks the other pane" >> ~/.config/ranger/rc.conf
            echo "set tmux_cwd_track true" >> ~/.config/ranger/rc.conf
        fi
    fi
fi
unset tmuxx

tmux source ~/.tmux.conf
echo "Install plugins in tmux with '@-I'"
