if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

RIFLE_INS=""
if type rifle &>/dev/null && ! type ranger &>/dev/null; then
    RIFLE_INS=$(mktemp -d -t ranger-XXXXXXXXXX)
    sudo mv /usr/bin/rifle $RIFLE_INS
fi

# Ranger (File explorer)
if ! hash ranger &>/dev/null; then
    if [[ $distro_base == "Arch" ]] || [[ $distro_base == "Debian" ]]; then
        eval "${pac_ins_y}" ranger
    fi
fi

ranger --help | $PAGER

if ! test -z $RIFLE_INS; then
    sudo mv -f $RIFLE_INS/rifle /usr/bin/rifle
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
ranger --confdir=$HOME/.config/ranger --copy-config=all
if [[ $ENV == ~/.environment.env ]]; then
    sed -i 's|#export RANGER_LOAD_DEFAULT_RC=|export RANGER_LOAD_DEFAULT_RC=|g' $ENV
    sudo sed -i 's|#export RANGER_LOAD_DEFAULT_RC=|export RANGER_LOAD_DEFAULT_RC=|g' $ENV_R
else
    echo "export RANGER_LOAD_DEFAULT_RC=FALSE" >>$ENV
    printf "export RANGER_LOAD_DEFAULT_RC=FALSE\n" | sudo tee -a $ENV_R
fi

if [ -d ~/.bash_aliases.d/ ]; then
    if test -f ranger/.bash_aliases.d/ranger.sh; then
        cp ranger/.bash_aliases.d/ranger.sh ~/.bash_aliases.d/ranger.sh
    else
        wget -O ~/.bash_aliases.d/ranger.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/.bash_aliases.d/ranger.sh
    fi

    if hash gio &>/dev/null && test -f ~/.bash_aliases.d/ranger.sh~; then
        gio trash ~/.bash_aliases.d/ranger.sh~
    fi
fi

if ! [ -d ranger/.config/ranger/ ]; then
    tmpdir=$(mktemp -d -t ranger-XXXXXXXXXX)
    wget -O $tmpdir/rc.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/.config/ranger/rc.conf
    wget -O $tmpdir/scope.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/.config/ranger/scope.sh
    wget -O $tmpdir/rifle.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/.config/ranger/rifle.conf
    dir=$tmpdir
else
    dir=ranger/.config/ranger
fi

rangr_cnf() {
    if ! [ -d ~/.config/ranger/ ]; then
        mkdir -p ~/.config/ranger/
    fi

    cp -t ~/.config/ranger $dir/rc.conf $dir/rifle.conf $dir/scope.sh
    if hash gio &>/dev/null; then
        if test -f ~/.config/ranger/rc.conf~; then
            gio trash ~/.config/ranger/rc.conf~
        fi
        if test -f ~/.config/ranger/rifle.conf~; then
            gio trash ~/.config/ranger/rifle.conf~
        fi
        if test -f ~/.config/ranger/scope.sh~; then
            gio trash ~/.config/ranger/scope.sh~
        fi
    fi
}
yes-edit-no -f rangr_cnf -g "$dir/rc.conf $dir/rifle.conf $dir/scope.sh" -p "Install predefined configuration (rc.conf,rifle.conf and scope.sh at ~/.config/ranger/)? " -e

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

if ! test -d ~/.config/ranger/plugins/devicons2; then
    readyn -p "Install ranger (dev)icons? (ranger plugin at ~/.conf/ranger/plugins)" rplg
    if [[ "y" == $rplg ]]; then
        mkdir -p ~/.config/ranger/plugins
        git clone https://github.com/cdump/ranger-devicons2 ~/.config/ranger/plugins/devicons2
        if [[ "$distro" == "Arch" ]]; then
            eval "${pac_ins_y}" ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
        elif [[ "$distro_base" == "Debian" ]]; then
            readyn -p "Install Nerdfonts from binary - no apt? (Special FontIcons)" nrdfnts
            if [[ $nrdfnts == "y" ]]; then
                if ! test -f ./install_nerdfonts.sh; then
                    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nerdfonts.sh)
                else
                    . ./install_nerdfonts.sh
                fi
            fi
        fi
    fi
fi

#readyn -p "Install and enable ranger image previews? (Installs terminology)" rplg
#sed -i 's|set preview_images false|set preview_images true|g' ~/.config/ranger/rc.conf
#if [ -z $rplg ] || [ "y" == $rplg ]; then
#    if test $distro == "Arch" || test $distro == "Manjaro";then
#       eval "$pac_ins terminology"
#    elif test $distro_base == "Debian"; then
#       eval "$pac_ins terminology"
#    fi
#fi

if type nvim &>/dev/null; then
    readyn -p "Integrate ranger with nvim? (Install nvim ranger plugins)" rangrvim
    if [[ -z $rangrvim ]] || [[ "y" == $rangrvim ]]; then
        if test -f ~/.config/nvim/init.vim && ! grep -q "Ranger integration" ~/.config/nvim/init.vim; then
            sed -i 's|"Plugin '\''francoiscabrol/ranger.vim'\''|Plugin '\''francoiscabrol/ranger.vim'\''|g' ~/.config/nvim/init.vim
            sed -i 's|"Plugin '\''rbgrouleff/bclose.vim'\''|Plugin '\''rbgrouleff/bclose.vim'\''|g' ~/.config/nvim/init.vim
            sed -i 's|"let g:ranger_replace_netrw = 1|let g:ranger_replace_netrw = 1|g' ~/.config/nvim/init.vim
            sed -i 's|"let g:ranger_map_keys = 0|let g:ranger_map_keys = 0|g' ~/.config/nvim/init.vim
            nvim +PlugInstall
        fi
    fi
fi
#fi
