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

#if [ ! -d ~/.bash_aliases.d/ ]; then
#   mkdir ~/.bash_aliases.d/    
#fi
#
#if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then
#    echo "if [[ -d ~/.bash_aliases.d/ ]]; then" >> ~/.bashrc
#    echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
#    echo "      . \"\$alias\" " >> ~/.bashrc
#    echo "  done" >> ~/.bashrc
#    echo "fi" >> ~/.bashrc
#fi

# Fix tmux not sourcing .bashrc
# https://unix.stackexchange.com/questions/320465/new-tmux-sessions-do-not-source-bashrc-filehttps://unix.stackexchange.com/questions/320465/new-tmux-sessions-do-not-source-bashrc-filehttps://unix.stackexchange.com/questions/320465/new-tmux-sessions-do-not-source-bashrc-filehttps://unix.stackexchange.com/questions/320465/new-tmux-sessions-do-not-source-bashrc-file

#if [ ! -f ~/.profile ]; then
#   touch ~/.profile    
#fi
#
#if ! grep -q ".bashrc" ~/.profile; then
#   echo "if [ -n \"\$BASH_VERSION\" -a -n \"\$PS1\" ]; then" >> ~/.profile
#   echo "   # include .bashrc if it exists" >> ~/.profile
#   echo "   if [ -f \"\$HOME/.bashrc\" ]; then" >> ~/.profile
#   echo "       . \"\$HOME/.bashrc\"" >> ~/.profile
#   echo "   fi" >> ~/.profile
#   echo "fi" >> ~/.profile 
#fi

sed -i 's|^set -g @plugin|#set -g @plugin|g' tmux/.tmux.conf
sed -i 's|^run '\''~/.tmux/plugins/tpm/tpm'\''|#run '\''~/.tmux/plugins/tpm/tpm'\''|g' tmux/.tmux.conf
sed -i 's|set -g @continuum-restore '\''on'\''|#set -g @continuum-restore '\''on'\''|g' tmux/.tmux.conf

reade -Q "GREEN" -i "y" -p "Install tmux.conf? (tmux conf at ~/.tmux.conf) [Y/n]:" "y n" tmuxc
if [ "$tmuxc"  == "y" ] || [ -z "$tmuxc" ]; then
    cp -bfv tmux/.tmux.conf ~/
    gio trash ~/.tmux.conf~
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

if [ -x $(command -v nvim) ] && [ -x $(command -v kitty) ]; then
    reade -Q "GREEN" -i "y" -p "Install vim-tmux-kitty navigator plugin? (tmux-sensible) [Y/n]:" "y n"  tmuxx
    if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
        sed -i 's|#set -g @plugin '\''excited-bore/vim-tmux-kitty-navigator'\''|set -g @plugin '\''excited-bore/vim-tmux-kitty-navigator'\''|g' ~/.tmux.conf
        if ! grep -q "set -g @plugin 'excited-bore/vim-tmux-kitty-navigator'" ~/.tmux.conf; then
             echo "set -g @plugin 'excited-bore/vim-tmux-kitty-navigator'" >> ~/.tmux.conf
        fi
    fi
fi
unset tmuxx


#if [ "$(which ranger)" != "" ]; then
#    reade -Q "GREEN" -i "y" -p "Install ranger tmux plugin? (ranger_tmux) [Y/n]:" "y n"  tmuxx
#    if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
#        if [ ! -x "$(command -v pip)" ]; then
#            if [ $distro_base == "Arch" ]; then
#                yes | sudo pacman -Syu python-pip
#            elif [ $distro_base == "Debian" ]; then
#                yes | sudo apt update
#                yes | sudo apt install python3-pip
#            fi
#        fi
#        pip install --break-system-packages ranger_tmux
#        python3 -m ranger_tmux --tmux install
#        
#        # Silent tracking
#        if ! grep -q "history" ~/.local/lib/python3.11/site-packages/ranger_tmux/util.py; then
#            sed -i 's|"'\''.format(path)|" \&\& history -d -1 \&\& clear'\''.format(path)|g' ~/.local/lib/python3.11/site-packages/ranger_tmux/util.py
#        fi    
#
#        sed -i 's|#set tmux_cwd_sync .*|set tmux_cwd_sync true|g' ~/.config/ranger/rc.conf
#        sed -i 's|#set tmux_cwd_track .*|set tmux_cwd_track true|g' ~/.config/ranger/rc.conf
#        if ! grep -q "set tmux_cwd_sync" ~/.config/ranger/rc.conf; then
#            echo "# When True, ranger's current directory is synced to the other pane" >> ~/.config/ranger/rc.conf
#            echo "set tmux_cwd_sync true" >> ~/.config/ranger/rc.conf
#            echo "# When True, ranger's current directory tracks the other pane" >> ~/.config/ranger/rc.conf
#            echo "set tmux_cwd_track true" >> ~/.config/ranger/rc.conf
#        fi
#        
#        reade -Q "GREEN" -i "y" -p 'Set ranger-tmux shortcut from  Bspace  to  \\`  ?  [Y/n]:' "y n"  tmuxx
#        if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
#            sed -i 's|Bspace run-shell -b|\` run-shell -b|g'  ~/.tmux.conf 
#        fi
#    fi
#fi
#unset tmuxx

reade -Q "GREEN" -i "y" -p "Install tmux completions? [Y/n]:" "y n"  tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    ./checks/check_completions_dir.sh
    if [ ! -e ~/.bash_completion.d/tmux ]; then
        curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux > ~/.bash_completion.d/tmux 2> /dev/null
        . ~/.bashrc
    fi
fi

unset tmuxx

reade -Q "YELLOW" -i "y" -p "Install tmux completions at root? [Y/n]:" "y n"  tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    if [ ! -e /root/.bash_completion.d/tmux ]; then
       curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux | sudo tee -a /root/.bash_completion.d/tmux > /dev/null
    fi
fi
unset tmuxx

reade -Q "GREEN" -i "y" -p "Install tmux.sh at ~/.bash_aliases.d/? (tmux aliases) [Y/n]:" "y n"  tmuxx
if [ -z "$tmuxx" ] || [ "$tmuxx"  == "y" ]; then 
    cp -bfv tmux/tmux.sh ~/.bash_aliases.d/
    gio trash ~/.bash_aliases.d/tmux.sh~
fi
unset tmuxx 

reade -Q "YELLOW" -i "n" -p "Set tmux at shell login for SSH? (Conflicts with vim-tmux-kitty navigator) [Y/n]:" "y n"  tmuxx
if [ -z "$tmuxx" ] || [ "$tmuxx"  == "y" ]; then 
    touch ~/.bash_aliases.d/tmux_startup.sh
    echo 'if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then' >> ~/.bash_aliases.d/tmux_startup.sh
    echo '  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux;' >> ~/.bash_aliases.d/tmux_startup.sh  
    echo 'fi' >> ~/.bash_aliases.d/tmux_startup.sh
fi
unset tmuxx

tmux source-file ~/.tmux.conf
. ~/.tmux/plugins/tpm/bin/install_plugins
. ~/.tmux/plugins/tpm/bin/update_plugins all

echo "${green}Install plugins in tmux with 'C-b + I' / Update with 'C-b + U'"