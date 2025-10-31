# https://github.com/tmux/tmux/wiki

hash tmux &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


if ! hash tmux &> /dev/null; then
    if [[ "$distro_base" == "Arch" || "$distro_base" == "Debian" ]]; then
        eval "${pac_ins_y}" tmux
    fi
fi

tmux --help

#if [ ! -d ~/.aliases.d/ ]; then
#   mkdir ~/.aliases.d/
#fi
#
#if ! grep -q "~/.aliases.d" ~/.bashrc; then
#    echo "if [[ -d ~/.aliases.d/ ]]; then" >> ~/.bashrc
#    echo "  for alias in ~/.aliases.d/*.sh; do" >> ~/.bashrc
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

if test -f $TOP/cli-tools/tmux/.tmux.conf; then
    file=$TOP/cli-tools/tmux/.tmux.conf
else
    dir1="$(mktemp -d -t tmux-XXXXXXXXXX)"
    wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/tmux/.tmux.conf > $dir1/.tmux.conf
    file=$dir1/.tmux.conf
fi

# Comment out potential ranger plugin
sed -i 's|^\(bind-key ` run-shell -b '\''/usr/bin/python3 -m ranger_tmux.drop\)|#\1|g' $file

# Comment out other plugins
sed -i 's|^set -g @plugin|#set -g @plugin|g' $file
sed -i 's|^run '\''~/.tmux/plugins/tpm/tpm'\''|#run '\''~/.tmux/plugins/tpm/tpm'\''|g' $file
sed -i 's|^set -g @continuum-restore '\''on'\''|#set -g @continuum-restore '\''on'\''|g' $file

yes-edit-no -p "Install tmux.conf? (tmux conf at ~/.tmux.conf)" -g "$file" tmuxc
if [[ "$tmuxc" == "y" ]]; then
    cp $file ~/
    if test -f $file~ && hash gio &> /dev/null; then
        gio trash $file~
    fi
fi
unset tmuxc

readyn -p "Install tmux plugin manager? (tpm)" -c "! test -d $HOME/.tmux/plugins/tpm || ! grep -q \"set -g @plugin 'tmux-plugins/tpm'\" ~/.tmux.conf" tmuxx
if [[ "$tmuxx" == "y" ]]; then
    if ! [ -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    sed -i 's|#set -g @plugin '\''tmux-plugins/tpm'\''|set -g @plugin '\''tmux-plugins/tpm'\''|g' ~/.tmux.conf
    sed -i 's|#run '\''~/.tmux/plugins/tpm/tpm'\''|run '\''~/.tmux/plugins/tpm/tpm'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tpm'" ~/.tmux.conf; then
        echo "# Plugin Manager" >>~/.tmux.conf
        echo "set -g @plugin 'tmux-plugins/tpm'" >>~/.tmux.conf
        echo "run '~/.tmux/plugins/tpm/tpm'" >>~/.tmux.conf
    fi
fi
unset tmuxx

readyn -p "Install tmux clipboard plugin? (tmux-yank)" tmuxx
if [[ "$tmuxx" == "y" ]]; then
    if ([[ "$XDG_SESSION_TYPE" == 'x11' ]] && (! hash xclip &> /dev/null || ! hash xsel &> /dev/null)) || ([[ "$XDG_SESSION_TYPE" == 'wayland' ]] && (! hash wl-copy &> /dev/null || ! hash wl-paste &> /dev/null)); then
        if ! [[ -f $TOP/install_linux_clipboard.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_linux_clipboard.sh)
        else
            . $TOP/install_linux_clipboard.sh
        fi
    fi
    sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-yank'\''|set -g @plugin '\''tmux-plugins/tmux-yank'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tmux-yank'" ~/.tmux.conf; then
        echo "# Clipboard " >>~/.tmux.conf
        echo "set -g @plugin 'tmux-plugins/tmux-yank'" >>~/.tmux.conf
    fi
fi
unset tmuxx

readyn -p "Install tmux sensible settings plugin? (tmux-sensible)" tmuxx
if [[ "$tmuxx" == "y" ]]; then
    sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-sensible'\''|set -g @plugin '\''tmux-plugins/tmux-sensible'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tmux-sensible'" ~/.tmux.conf; then
        echo "# Like vim-sensible, just good settings to have overall" >>~/.tmux.conf
        echo "set -g @plugin 'tmux-plugins/tmux-sensible'" >>~/.tmux.conf
    fi
fi
unset tmuxx

readyn -p "Install tmux savepoint plugin? (tmux-resurrect)" tmuxx
if [[ "$tmuxx" == "y" ]]; then
    sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-resurrect'\''|set -g @plugin '\''tmux-plugins/tmux-resurrect'\''|g' ~/.tmux.conf
    if ! grep -q "set -g @plugin 'tmux-plugins/tmux-resurrect'" ~/.tmux.conf; then
        echo "# Restore tmux environment with savepoints" >>~/.tmux.conf
        echo "set -g @plugin 'tmux-plugins/tmux-resurrect'" >>~/.tmux.conf
    fi
    readyn -p "Install automatic tmux savepoint plugin? (tmux-continuum)" tmuxx
    if [[ "$tmuxx" == "y" ]] || [ -z "$tmuxx" ]; then
        sed -i 's|#set -g @plugin '\''tmux-plugins/tmux-continuum'\''|set -g @plugin '\''tmux-plugins/tmux-continuum'\''|g' ~/.tmux.conf
        sed -i 's|#set -g @continuum-restore '\''on'\''|set -g @continuum-restore '\''on'\''|g' ~/.tmux.conf
        if ! grep -q "set -g @plugin 'tmux-plugins/tmux-continuum'" ~/.tmux.conf; then
            echo "# Restore tmux environment on restart" >>~/.tmux.conf
            echo "set -g @plugin 'tmux-plugins/tmux-continuum'" >>~/.tmux.conf
            echo "set -g @continuum-restore '\''on'\''" >>~/.tmux.conf
        fi
    fi
    unset tmuxx
fi
unset tmuxx

if hash nvim &> /dev/null && hash kitty &> /dev/null; then
    readyn -p "Install vim-tmux-kitty navigator plugin? (tmux-sensible)" tmuxx
    if [[ "$tmuxx" == "y" ]]; then
        sed -i 's|#set -g @plugin '\''excited-bore/vim-tmux-kitty-navigator'\''|set -g @plugin '\''excited-bore/vim-tmux-kitty-navigator'\''|g' ~/.tmux.conf
        if ! grep -q "set -g @plugin 'excited-bore/vim-tmux-kitty-navigator'" ~/.tmux.conf; then
            echo "set -g @plugin 'excited-bore/vim-tmux-kitty-navigator'" >>~/.tmux.conf
        fi
    fi
fi
unset tmuxx

#if [ "$(which ranger)" != "" ]; then
#    readyn -p "Install ranger tmux plugin? (ranger_tmux)"  tmuxx
#    if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
#        if [ ! -x "$(command -v pip)" ]; then
#            if test $distro == "Arch" || test $distro == "Manjaro"; then
#                eval "$pac_insyu python-pip"
#            elif [ $distro_base == "Debian" ]; then
#                eval "$pac_ins python3-pip"
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
#        readyn -p 'Set ranger-tmux shortcut from  Bspace  to  \\`  ?'  tmuxx
#        if [ "$tmuxx"  == "y" ] || [ -z "$tmuxx" ]; then
#            sed -i 's|Bspace run-shell -b|\` run-shell -b|g'  ~/.tmux.conf
#        fi
#    fi
#fi
#unset tmuxx

if test -d ~/.bash_completion.d && ! [ -e ~/.bash_completion.d/tmux.bash ]; then
    readyn -p "Install tmux bash completions?" tmuxx
    if [[ "$tmuxx" == "y" ]]; then
        wget-curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux >~/.bash_completion.d/tmux.bash 2>/dev/null
        test -n "$BASH_VERSION" && source ~/.bashrc
    fi
fi

unset tmuxx

#if ! [ -e /root/.bash_completion.d/tmux.bash ]; then
#    readyn -Y 'YELLOW' -p "Install tmux bash completions at root?" tmuux
#    if [[ "$tmuux" == "y" ]]; then
#        if ! [ -e /root/.bash_completion.d/tmux.bash ]; then
#            wget-curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux.bash | sudo tee -a /root/.bash_completion.d/tmux.bash &>/dev/null
#        fi
#    fi
#    unset tmuux
#fi

if test -d ~/.aliases.d/; then
    readyn -p "Install tmux.sh at ~/.aliases.d/? (tmux aliases)" tmuxx
    if [[ "$tmuxx" == "y" ]]; then
         
        if test -f $TOP/cli-tools/tmux/.aliases.d/tmux.sh; then
            cp $TOP/cli-tools/tmux/.aliases.d/tmux.sh ~/.aliases.d/
        else
            wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/tmux/.aliases.d/tmux.sh > ~/.aliases.d/tmux.sh
        fi
        if hash gio &>/dev/null && test -f ~/.aliases.d/tmux.sh~; then
            gio trash ~/.aliases.d/tmux.sh~
        fi
    fi
    unset tmuxx
    
    readyn -n -p "Set tmux at shell login for SSH? (Conflicts with vim-tmux-kitty navigator)" tmuxxx
    if [[ "$tmuxxx" == "y" ]]; then
         
        touch ~/.aliases.d/tmux_startup.sh
        echo 'if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then' >>~/.aliases.d/tmux_startup.sh
        echo '  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux;' >>~/.aliases.d/tmux_startup.sh
        echo 'fi' >>~/.aliases.d/tmux_startup.sh
    fi
    unset tmuxxx
fi


tmux source-file ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all

echo "${green}Install plugins in tmux with 'C-b + I' / Update with 'C-b + U'${normal}"
