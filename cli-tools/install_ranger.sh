# https://github.com/ranger/ranger

hash ranger &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

RIFLE_INS=""
if hash rifle &>/dev/null && ! hash ranger &>/dev/null; then
    RIFLE_INS=$(mktemp -d -t ranger-XXXXXXXXXX)
    sudo mv /usr/local/bin/rifle $RIFLE_INS
fi

# Ranger (File explorer)
if ! hash ranger &>/dev/null; then
    if [[ $distro_base == "Arch" ]] || [[ $distro_base == "Debian" ]]; then
        eval "${pac_ins_y}" ranger
    fi
fi

ranger --help | $PAGER

if test -e "$RIFLE_INS"; then
    sudo mv $RIFLE_INS/rifle /usr/local/bin/rifle
fi

# Remove message ('Removed /tmp/ranger_cd54qzd') after quitting ranger
if [ -f /usr/bin/ranger ] && ! grep -q 'rm -f -- "$temp_file" 2>/dev/null' /usr/bin/ranger; then
    sudo sed -i 's|rm -f -- "$temp_file"|rm -f -- "$temp_file" 2>/dev/null|g' /usr/bin/ranger
fi

# Remove message ('Removed /tmp/ranger_cd54qzd') after quitting ranger
if [ -f $HOME/.local/bin/ranger ] && ! grep -q 'rm -f -- "$temp_file" 2>/dev/null' $HOME/.local/bin/ranger; then
    sudo sed -i 's|rm -f -- "$temp_file"|rm -f -- "$temp_file" 2>/dev/null|g' $HOME/.local/bin/ranger
fi

#ranger --copy-config=all
ranger --confdir=$XDG_CONFIG_HOME/ranger --copy-config=all
if [[ $ENV == ~/.environment.env ]]; then
    sed -i 's|#export RANGER_LOAD_DEFAULT_RC=|export RANGER_LOAD_DEFAULT_RC=|g' $ENV
    sudo sed -i 's|#export RANGER_LOAD_DEFAULT_RC=|export RANGER_LOAD_DEFAULT_RC=|g' $ENV_R
else
    echo "export RANGER_LOAD_DEFAULT_RC=FALSE" >>$ENV
    printf "export RANGER_LOAD_DEFAULT_RC=FALSE\n" | sudo tee -a $ENV_R
fi

if [ -d ~/.aliases.d/ ]; then
    if test -f $TOP/cli-tools/ranger/.aliases.d/ranger.sh; then
        cp $TOP/cli-tools/ranger/.aliases.d/ranger.sh ~/.aliases.d/ranger.sh
    else
        wget -O ~/.aliases.d/ranger.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/ranger/.aliases.d/ranger.sh
    fi

    if hash gio &>/dev/null && test -f ~/.aliases.d/ranger.sh~; then
        gio trash ~/.aliases.d/ranger.sh~
    fi
fi

if [ -d $TOP/cli-tools/ranger/.config/ranger/ ]; then
    dir=$TOP/cli-tools/ranger/.config/ranger
else
    tmpdir=$(mktemp -d -t ranger-XXXXXXXXXX)
    wget -O $tmpdir/rc.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/ranger/.config/ranger/rc.conf
    wget -O $tmpdir/scope.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/ranger/.config/ranger/scope.sh
    wget -O $tmpdir/rifle.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/ranger/.config/ranger/rifle.conf
    dir=$tmpdir
fi

rangr_cnf() {
    if ! [ -d $XDG_CONFIG_HOME/ranger/ ]; then
        mkdir -p $XDG_CONFIG_HOME/ranger/
    fi

    cp -t $XDG_CONFIG_HOME/ranger $dir/rc.conf $dir/rifle.conf $dir/scope.sh
    
    if hash gio &>/dev/null; then
        if test -f $XDG_CONFIG_HOME/ranger/rc.conf~; then
            gio trash $XDG_CONFIG_HOME/ranger/rc.conf~
        fi
        if test -f $XDG_CONFIG_HOME/ranger/rifle.conf~; then
            gio trash $XDG_CONFIG_HOME/ranger/rifle.conf~
        fi
        if test -f $XDG_CONFIG_HOME/ranger/scope.sh~; then
            gio trash $XDG_CONFIG_HOME/ranger/scope.sh~
        fi
    fi
}
yes-edit-no -f rangr_cnf -g "$dir/rc.conf $dir/rifle.conf $dir/scope.sh" -p "Install predefined configuration (rc.conf,rifle.conf and scope.sh at $XDG_CONFIG_HOME/ranger/)? " -e

readyn -p "F2 for Ranger?" rf2
if [[ "y" == "$rf2" ]]; then
    binds=~/.bashrc
    if [ -f ~/.keybinds.d/keybinds.bash ]; then
        binds=~/.keybinds.d/keybinds.bash
    fi
    if [ -f ~/.keybinds.d/keybinds.bash ]; then
        if grep -q '#bind -x '\''"\\201": ranger'\''' ~/.keybinds.d/keybinds.bash; then
            sed -i 's|#bind -x '\''"\\201": ranger'\''|bind -x '\''"\\201": ranger'\''|g' ~/.keybinds.d/keybinds.bash
            sed -i 's|#bind '\''"\\eOQ": "\\201\\n\\C-l"'\''|bind '\''"\\eOQ": "\\201\\n\\C-l"'\''|g' ~/.keybinds.d/keybinds.bash
        fi
    elif ! grep -q 'bind -x '\''"\\201": ranger'\''' ~/.bashrc; then
        echo 'bind -x '\''"\\201": ranger'\''' >>~/.bashrc
        echo 'bind '\''"\\eOQ": \\201\\n\\C-l'\''' >>~/.bashrc
    fi
fi

if ! test -d $XDG_CONFIG_HOME/ranger/plugins/devicons2; then
    readyn -p "Install ranger (dev)icons? (ranger plugin at ~/.conf/ranger/plugins)" rplg
    if [[ "y" == $rplg ]]; then
        if ! [ -d $XDG_CONFIG_HOME/ranger/plugins ]; then
            mkdir -p $XDG_CONFIG_HOME/ranger/plugins
        fi
        
        git clone https://github.com/cdump/ranger-devicons2 $XDG_CONFIG_HOME/ranger/plugins/devicons2
        
        if [[ "$distro" == "Arch" ]]; then
            eval "${pac_ins_y}" ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
        elif [[ "$distro_base" == "Debian" ]]; then
            readyn -p "Install Nerdfonts from binary - no apt? (Special FontIcons)" nrdfnts
            if [[ $nrdfnts == "y" ]]; then
                if ! test -f $TOP/install_nerdfonts.sh; then
                    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nerdfonts.sh)
                else
                    . $TOP/install_nerdfonts.sh
                fi
            fi
            unset nrdfnts
        fi
    fi
    unset rplg
fi

#readyn -p "Install and enable ranger image previews? (Installs terminology)" rplg
#sed -i 's|set preview_images false|set preview_images true|g' $XDG_CONFIG_HOME/ranger/rc.conf
#if [ -z $rplg ] || [ "y" == $rplg ]; then
#    if test $distro == "Arch" || test $distro == "Manjaro";then
#       eval "$pac_ins terminology"
#    elif test $distro_base == "Debian"; then
#       eval "$pac_ins terminology"
#    fi
#fi

if hash nvim &>/dev/null; then
    readyn -p "Integrate ranger with nvim? (Install nvim ranger plugins)" rangrvim
    if [[ -z $rangrvim ]] || [[ "y" == $rangrvim ]]; then
        if test -f $XDG_CONFIG_HOME/nvim/init.vim && ! grep -q "Ranger integration" $XDG_CONFIG_HOME/nvim/init.vim; then
            sed -i 's|"Plugin '\''francoiscabrol/ranger.vim'\''|Plugin '\''francoiscabrol/ranger.vim'\''|g' $XDG_CONFIG_HOME/nvim/init.vim
            sed -i 's|"Plugin '\''rbgrouleff/bclose.vim'\''|Plugin '\''rbgrouleff/bclose.vim'\''|g' $XDG_CONFIG_HOME/nvim/init.vim
            sed -i 's|"let g:ranger_replace_netrw = 1|let g:ranger_replace_netrw = 1|g' $XDG_CONFIG_HOME/nvim/init.vim
            sed -i 's|"let g:ranger_map_keys = 0|let g:ranger_map_keys = 0|g' $XDG_CONFIG_HOME/nvim/init.vim
            nvim +PlugInstall
        fi
    fi
    unset rangrvim
fi
