#!/usr/bin/env bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi


if ! type tmux &> /dev/null; then
    if test "$distro_base" == "Arch"; then
        sudo pacman -S tmux
    elif test "$distro_base" == "Debian"; then
        sudo apt install tmux
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

if test -f tmux/.tmux.conf; then
    file=tmux/.tmux.conf
else
    dir1="$(mktemp -d -t tmux-XXXXXXXXXX)"
    curl -s -o $dir1/.tmux.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/tmux/.tmux.conf
    file=$dir1/.tmux.conf
fi

# Comment out potential ranger plugin
sed -i 's|^\(bind-key ` run-shell -b '\''/usr/bin/python3 -m ranger_tmux.drop\)|#\1|g' $file

# Comment out other plugins
sed -i 's|^set -g @plugin|#set -g @plugin|g' $file
sed -i 's|^run '\''~/.tmux/plugins/tpm/tpm'\''|#run '\''~/.tmux/plugins/tpm/tpm'\''|g' $file
sed -i 's|^set -g @continuum-restore '\''on'\''|#set -g @continuum-restore '\''on'\''|g' $file

reade -Q "GREEN" -i "y" -p "Install tmux.conf? (tmux conf at ~/.tmux.conf) [Y/n]: " "n" tmuxc
if [ "$tmuxc"  == "y" ] || [ -z "$tmuxc" ]; then
    cp -bfv $file ~/
    if test -f $file~ && type gio &> /dev/null; then
        gio trash $file~
    fi
fi
unset tmuxc


reade -Q "GREEN" -i "y" -p "Install tmux plugin manager? (tpm) [Y/n]: " "n"  tmuxx
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


reade -Q "GREEN" -i "y" -p "Install tmux clipboard plugin? (tmux-yank) [Y/n]: " "n"  tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    if ! type xclip &> /dev/null || ! type xsel &> /dev/null; then
        if test "$distro_base" == "Arch"; then
            sudo pacman -S xclip xsel
        elif test $distro_base == "Debian"; then
            sudo apt install xclip xsel
        fi
    fi
    sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-yank'\''|set -g @plugin '\''tmux-plugins/tmux-yank'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tmux-yank'" ~/.tmux.conf; then
         echo "# Clipboard " >> ~/.tmux.conf
         echo "set -g @plugin 'tmux-plugins/tmux-yank'" >> ~/.tmux.conf
    fi
fi
unset tmuxx

reade -Q "GREEN" -i "y" -p "Install tmux sensible settings plugin? (tmux-sensible) [Y/n]: " "n"  tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-sensible'\''|set -g @plugin '\''tmux-plugins/tmux-sensible'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tmux-sensible'" ~/.tmux.conf; then
         echo "# Like vim-sensible, just good settings to have overall" >> ~/.tmux.conf
         echo "set -g @plugin 'tmux-plugins/tmux-sensible'" >> ~/.tmux.conf
    fi
fi
unset tmuxx

reade -Q "GREEN" -i "y" -p "Install tmux savepoint plugin? (tmux-resurrect) [Y/n]: " "n"  tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-resurrect'\''|set -g @plugin '\''tmux-plugins/tmux-resurrect'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tmux-resurrect'" ~/.tmux.conf; then
         echo "# Restore tmux environment with savepoints" >> ~/.tmux.conf
         echo "set -g @plugin 'tmux-plugins/tmux-resurrect'" >> ~/.tmux.conf
    fi
    reade -Q "GREEN" -i "y" -p "Install automatic tmux savepoint plugin? (tmux-continuum) [Y/n]: " "n"  tmuxx
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
    reade -Q "GREEN" -i "y" -p "Install vim-tmux-kitty navigator plugin? (tmux-sensible) [Y/n]: " "n"  tmuxx
    if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
        sed -i 's|#set -g @plugin '\''excited-bore/vim-tmux-kitty-navigator'\''|set -g @plugin '\''excited-bore/vim-tmux-kitty-navigator'\''|g' ~/.tmux.conf
        if ! grep -q "set -g @plugin 'excited-bore/vim-tmux-kitty-navigator'" ~/.tmux.conf; then
             echo "set -g @plugin 'excited-bore/vim-tmux-kitty-navigator'" >> ~/.tmux.conf
        fi
    fi
fi
unset tmuxx


#if [ "$(which ranger)" != "" ]; then
#    reade -Q "GREEN" -i "y" -p "Install ranger tmux plugin? (ranger_tmux) [Y/n]:" "n"  tmuxx
#    if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
#        if [ ! -x "$(command -v pip)" ]; then
#            if test $distro == "Arch" || test $distro == "Manjaro"; then
#                sudo pacman -Syu python-pip
#            elif [ $distro_base == "Debian" ]; then
#                sudo apt install python3-pip
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
#        reade -Q "GREEN" -i "y" -p 'Set ranger-tmux shortcut from  Bspace  to  \\`  ?  [Y/n]:' "n"  tmuxx
#        if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
#            sed -i 's|Bspace run-shell -b|\` run-shell -b|g'  ~/.tmux.conf 
#        fi
#    fi
#fi
#unset tmuxx

reade -Q "GREEN" -i "y" -p "Install tmux completions? [Y/n]: " "n"  tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    
    if ! test -f checks/check_completions_dir.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
    else
        . ./checks/check_completions_dir.sh
    fi

    if [ ! -e ~/.bash_completion.d/tmux ]; then
        curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux > ~/.bash_completion.d/tmux 2> /dev/null
        . ~/.bashrc
    fi
fi

unset tmuxx

reade -Q "YELLOW" -i "y" -p "Install tmux completions at root? [Y/n]: " "n" tmuxx
if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
    if [ ! -e /root/.bash_completion.d/tmux ]; then
       curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux | sudo tee -a /root/.bash_completion.d/tmux &> /dev/null
    fi
fi
unset tmuxx

reade -Q "GREEN" -i "y" -p "Install tmux.sh at ~/.bash_aliases.d/? (tmux aliases) [Y/n]: " "n"  tmuxx
if [ -z "$tmuxx" ] || [ "$tmuxx"  == "y" ]; then 
    if test -f tmux/.bash_aliases.d/tmux.sh; then
        cp -bfv tmux/.bash_aliases.d/tmux.sh ~/.bash_aliases.d/
    else
        curl -o ~/.bash_aliases.d/tmux.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/tmux/.bash_aliases.d/tmux.sh
    fi
    if test -f ~/.bash_aliases.d/tmux.sh~ && type gio &> /dev/null; then 
        gio trash ~/.bash_aliases.d/tmux.sh~
    fi
fi
unset tmuxx 


reade -Q "YELLOW" -i "n" -p "Set tmux at shell login for SSH? (Conflicts with vim-tmux-kitty navigator) [N/y]: " "y"  tmuxx
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

echo "${green}Install plugins in tmux with 'C-b + I' / Update with 'C-b + U'${normal}"
