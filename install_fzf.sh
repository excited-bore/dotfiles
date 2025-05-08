#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh)
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi

# Fzf (Fuzzy Finder)

# Bash completion issue with fzf fix
# https://github.com/cykerway/complete-alias/issues/46

if ! test -d ~/.fzf || test -f ~/.fzf.bash; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    command rm -v ~/.fzf.bash
    sed -i '/\[ -f \~\/.fzf.bash \] \&\& source \~\/.fzf.bash/d' ~/.bashrc
    ! [ -f ~/.bash_completion.d/fzf-completion.bash ] &&
        ln -s ~/.fzf/shell/completion.bash ~/.bash_completion.d/fzf-completion.bash

    printf "${cyan}Fzf${normal} keybinds:\n\t - Fzf history on Ctrl-R (replaces reverse-search-history)\n\t - Filepath retriever on Ctrl-T\n\t - Directory navigator on Alt-C\n\t - **<TAB> for fzf completion on some commands\n"
    readyn -p "Use fzf keybinds?" -c "! test -f ~/.keybinds.d/fzf-bindings.bash" fzf_key
    if [[ "$fzf_key" == 'y' ]]; then
        test -f ~/.keybinds.d/fzf-bindings.bash && command rm ~/.keybinds.d/fzf-bindings.bash
        ln -s ~/.fzf/shell/key-bindings.bash ~/.keybinds.d/fzf-bindings.bash
    fi
fi

if [[ $ENV =~ '.environment' ]]; then
    sed -i 's|.export PATH=$PATH:$HOME/.fzf/bin|export PATH=$PATH:$HOME/.fzf/bin|g' $ENV
elif ! grep -q '.fzf/bin' $ENV; then
    if grep -q '~/.environment' $ENV; then
        sed -i 's|\(\[ -f ~/.environment\] \&\& source \~/.environment\)|\export PATH=$PATH:$HOME/.fzf/bin\n\n\1\n|g' ~/.bashrc
    elif grep -q '~/.bash_aliases' $ENV; then
        sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\export PATH=$PATH:$HOME/.fzf/bin\n\n\1\n|g' ~/.bashrc
        sed -i 's|\(if \[ -f ~/.bash_aliases \]; then\)|export PATH=$PATH:$HOME/.fzf/bin\n\n\1\n|g' ~/.bashrc
    else
        echo 'export PATH="$PATH:$HOME/.fzf/bin"' >>$ENV
    fi
fi


if test -f ~/.keybinds.d/keybinds.bash && grep -q '^bind -m emacs-standard  '\''"\\C-z": vi-undo'\''' ~/.keybinds.d/keybinds.bash; then
    sed -i 's|\\\C-z|\\\C-o|g' ~/.fzf/shell/key-bindings.bash
fi

unset fzf_key
export PATH="$PATH:$HOME/.fzf/bin"

if ! [ -f ~/.fzf_history ]; then
    touch ~/.fzf_history
fi

fnd="find"

# TODO: Make better check: https://github.com/sharkdp/fd
if ! hash fd-find &>/dev/null && ! hash fd &>/dev/null; then
    readyn -p "Install fd and use for fzf? (Faster find)" fdr
    if [[ "$fdr" == "y" ]]; then
        if ! test -f install_fd.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fd.sh)
        else
            . ./install_fd.sh
        fi
    fi
fi

if hash fd-find &>/dev/null || type hash &>/dev/null; then
    fnd="fd"
fi

# BAT
if ! type bat &>/dev/null; then
    readyn -p "Install bat? (File previews/thumbnails for riflesearch)" bat
    if [[ "$bat" == "y" ]]; then
        if ! test -f install_bat.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)
        else
            . ./install_bat.sh
        fi
    fi
    unset bat
fi

# TREE
if ! type tree &>/dev/null; then
    readyn -p "Install tree? (Builtin cd shortcut gets a nice directory tree preview )" tree
    if [[ "$tree" == "y" ]]; then
        if ! test -f install_tree.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_tree.sh)
        else
            . ./install_tree.sh
        fi
    fi
    unset tree
fi

#TODO: fzf-rifle.sh still has ffmpegthumbnailer part (could use sed check)
if ! type ffmpegthumbnailer &>/dev/null; then
    readyn -p "Install ffmpegthumbnailer? (Video thumbnails for riflesearch)" ffmpg
    if [[ "$ffmpg" == "y" ]]; then
        if ! test -f install_ffmpegthumbnailer.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ffmpegthumbnailer.sh)
        else
            . ./install_ffmpegthumbnailer.sh
        fi
    fi
    unset ffmpg
fi

# RIPGREP
# TODO: Check export for ripgrep
# TODO: Do more with ripgrep
if ! type rg &>/dev/null; then
    readyn -y -p "Install ripgrep? (Recursive grep, opens possibility for line by line fzf )" rpgrp
    if [[ "$rpgrp" == "y" ]]; then
        if ! test -f install_ripgrep.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ripgrep.sh)
        else
            . ./install_ripgrep.sh
        fi
        if [[ $ENV == ~/.environment ]]; then
            sed -i 's|#export RG_PREFIX|export RG_PREFIX|g' $ENV
        elif ! grep -q "export RG_PREFIX" $ENV; then
            printf "\n# RIPGREP\nexport RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case \"" >>$ENV &>/dev/null
        fi
        if [[ $ENV_R == /root/.environment ]]; then
            sudo sed -i 's|#export RG_PREFIX|export RG_PREFIX|g' $ENV_R
        elif ! sudo grep -q "export RG_PREFIX" $ENV_R; then
            printf "\n# RIPGREP\nexport RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case \"" | sudo tee -a $ENV_R
        fi

        readyn -p "Add shortcut for ripgrep files in dir? (Ctrl-g)" rpgrpdir
        if [[ "$rpgrpdir" == "y" ]]; then
            if test -f fzf/.bash_aliases.d/ripgrep-directory.sh; then
                cp -fv fzf/.bash_aliases.d/ripgrep-directory.sh ~/.bash_aliases.d/
            else
                curl -o ~/.bash_aliases.d/ripgrep-directory.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/fzf/.bash_aliases.d/ripgrep-directory.sh
            fi
        fi
    fi
    unset rpgrp rpgrpdir
fi

# XCLIP
if [[ $machine == 'Linux' ]]; then
    if [[ "$X11_WAY" == 'x11' ]] && (! type xclip &>/dev/null || ! type xsel &>/dev/null); then
        readyn -p "Install xclip? (Clipboard tool for Ctrl-R/Reverse history shortcut)" xclipp
        if [[ "$xclipp" == "y" ]]; then
            eval "${pac_ins} xclip xsel"
        fi
        if [[ $ENV == ~/.environment ]]; then
            sed -i 's|#export FZF_CTRL_R_OPTS=|export FZF_CTRL_R_OPTS=|g' $ENV
        elif ! grep -q "export FZF_CTRL_R_OPTS=" $ENV; then
            printf "\nexport FZF_CTRL_R_OPTS=\" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-t:toggle-preview' --bind 'alt-c:execute-silent(echo -n {2..} | xclip -i -sel c)+abort' --color header:italic --header 'Press ALT-C to copy command into clipboard'\"" >>$ENV &>/dev/null
        fi
        if [[ $ENV_R == /root/.environment ]]; then
            sudo sed -i 's|#export FZF_CTRL_R_OPTS==|export FZF_CTRL_R_OPTS=|g' $ENV_R
        elif ! sudo grep -q "export FZF_CTRL_R_OPTS" $ENV_R; then
            printf "\nexport FZF_CTRL_R_OPTS=\" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-t:toggle-preview' --bind 'alt-c:execute-silent(echo -n {2..} | xclip -i -sel c)+abort' --color header:italic --header 'Press ALT-C to copy command into clipboard'\"" | sudo tee -a $ENV_R
        fi
    fi
fi
unset xclip

#echo "${green}Fzf will use '${CYAN}$fnd${normal}${green}'. Set default options that are fzf related to:${normal}"
#readyn -p "    Search globally instead of in current folder?" fndgbl
#readyn -p "    Search only files?" fndfle
#readyn -p "    Include hidden files?" fndhiddn
#if [ $fnd == "find" ]; then
#   test "$fndgbl" == "y" && fnd="find /"
#   test "$fndfle" == "y" && fnd="$fnd -type f"
#   test "$fndhiddn" == "y" && fnd="$fnd -iname \".*\""
#else
#   test "$fndgbl" == "y" && fnd="fd --search-path /"
#   test "$fndfle" == "y" && fnd="$fnd --type f"
#   test "$fndhiddn" == "y" && fnd="$fnd --hidden"
#fi
#unset fndgbl fndfle fndhiddn

if [[ $ENV == ~/.environment ]]; then
    sed -i 's|#export FZF_DEFAULT_COMMAND|export FZF_DEFAULT_COMMAND|g' $ENV
    sed -i 's|#export FZF_CTRL_T_COMMAND|export FZF_CTRL_T_COMMAND|g' $ENV
    sed -i 's|#export FZF_CTRL_R_OPTS|export FZF_CTRL_R_OPTS|g' $ENV
    sed -i 's|#export FZF_BIND_TYPES|export FZF_BIND_TYPES|g' $ENV
    sed -i 's|#type fd &> /dev/null|type fd &> /dev/null|g' $ENV
    sed -i 's/#--bind/--bind/' $ENV
    sed -i 's/#--preview-window/--preview-window/' $ENV
    sed -i 's/#--color/--color/' $ENV
    if type tree &>/dev/null; then
        sed -i 's|#export FZF_ALT_C_OPTS=|export FZF_ALT_C_OPTS=|g' $ENV
    fi
elif ! grep -q "export FZF_DEFAULT_COMMAND" $ENV; then
    printf "\n# FZF\nexport FZF_DEFAULT_COMMAND=\"$fnd\"\nexport FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'\n" >>$ENV &>/dev/null
    if type tree &>/dev/null; then
        printf "export FZF_ALT_C_OPTS=\"--preview 'tree -C {}\"\n" >>$ENV &>/dev/null
    fi
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will update FZF environment variables in $ENV_R'"
if [[ $ENV_R == /root/.environment ]]; then
    sudo sed -i 's|#export FZF_DEFAULT_COMMAND|export FZF_DEFAULT_COMMAND |g' $ENV_R
    sudo sed -i 's|#export FZF_CTRL_T_COMMAND|export FZF_CTRL_T_COMMAND|g' $ENV_R
    sudo sed -i 's|#export FZF_CTRL_R_OPTS|export FZF_CTRL_R_OPTS|g' $ENV_R
    sudo sed -i 's|#export FZF_BIND_TYPES|export FZF_BIND_TYPES|g' $ENV_R
    sudo sed -i 's|#type fd &> /dev/null|type fd &> /dev/null|g' $ENV_R
    sudo sed -i 's/--bind/#--bind/' $ENV_R
    sudo sed -i 's/--preview-window/#--preview-window/' $ENV_R
    sudo sed -i 's/--color/#--color/' $ENV_R
    if hash tree &>/dev/null; then
        sudo sed -i 's|#export FZF_ALT_C_OPTS=|export FZF_ALT_C_OPTS=|g' $ENV_R
    fi
elif ! sudo grep -q "export FZF_DEFAULT_COMMAND" $ENV_R; then
    printf "\n# FZF\nexport FZF_DEFAULT_COMMAND=\"$fnd\"\nexport FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'" | sudo tee -a $ENV_R &>/dev/null
    if hash tree &>/dev/null; then
        printf "\nexport FZF_ALT_C_OPTS=\"--preview 'tree -C {}\"\n" | sudo tee -a $ENV_R &>/dev/null
    fi
fi

#if type kitty &> /dev/null; then
#    readyn -p "Add shortcut for fzf-autocompletion? (Ctrl-Tab) "" comp_key
#    if [ "$comp_key" == "y" ]; then
#        if ! test -f .keybinds.d/keybinds.bash && ! grep -q "(Kitty)" ~/.fzf/shell/key-bindings.bash; then
#            printf "\n# (Kitty) Ctrl-tab for fzf autocompletion" >> ~/.fzf/shell/key-bindings.bash
#            printf "\nbind '\"\\\e[9;5u\": \" **\\\t\"'" >> ~/.fzf/shell/key-bindings.bash
#       fi
#     fi
#fi
#unset comp_key

if ! test -f /usr/bin/rifle || ! test -f ~/.bash_aliases.d/fzf-rifle.sh && grep -q "fzf_rifle" $KEYBIND; then
    readyn -p "Use rifle (file opener from 'ranger') to open found files and dirs with a custom Ctrl-F filesearch shortcut?" fzf_f
    if [[ "$fzf_f" == "y" ]]; then
        if ! type rifle &>/dev/null; then
            if ! type python &>/dev/null; then
                if [[ "$distro_base" == 'Debian' ]]; then
                    eval "${pac_ins}" python3 python-is-python3
                elif [[ "$distro_base" == 'Arch' ]]; then
                    eval "${pac_ins}" python
                fi
            fi
            sudo wget-dir /usr/bin/ https://raw.githubusercontent.com/ranger/ranger/master/ranger/ext/rifle.py
            sudo mv -v /usr/bin/rifle.py /usr/bin/rifle
            sudo chmod +x /usr/bin/rifle
        fi
        if ! test -f ranger/.config/ranger/rifle.conf; then
            curl -o ~/.config/ranger/rifle.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/.config/ranger/rifle.conf
            curl -o ~/.bash_aliases.d/fzf-rifle.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/fzf/.bash_aliases.d/fzf-rifle.sh
        else
            mkdir -p ~/.config/ranger
            cp -fv ranger/.config/ranger/rifle.conf ~/.config/ranger/
            cp -fv fzf/.bash_aliases.d/fzf-rifle.sh ~/.bash_aliases.d/
        fi
        sed -i 's/\\\C-f//g' ~/.fzf/shell/key-bindings.bash
        sed -i "s|\(bind -m vi-insert '\"\\\C-t\":.*\)|\1\n\n    # CTRL-F - Search with previews and other handy additions\n    bind -m emacs-standard '\"\\\C-f\": \"\\\C-t\"'\n    bind -m vi-command '\"\\\C-f\": \"\\\C-o\\\C-f\\\C-o\"'\n    bind -m vi-insert '\"\\\C-f\": \"\\\C-o\\\C-f\\\C-o\"'|g" ~/.fzf/shell/key-bindings.bash
        sed -i "s|\(bind -m vi-insert -x '\"\\\C-t\":.*\)|\1\n\n    # CTRL-F - Search with previews and other handy additions\n    bind -m emacs-standard -x '\"\\\C-f\": fzf_rifle'\n    bind -m vi-command -x '\"\\\C-f\": fzf_rifle'\n    bind -m vi-insert -x '\"\\\C-f\":  fzf_rifle'|g" ~/.fzf/shell/key-bindings.bash
    fi
fi
unset fzf_f

#readyn -p "Add shortcut for riflesearch on Ctrl-F? (Fzf and paste in console)" fzf_t
#if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then
#    #sed -i 's|# CTRL-T|# CTRL-F|g' ~/.fzf/shell/key-bindings.bash
#
#    #sed -i 's|bind -m vi-command '\''"\\C-t": |bind -m vi-command '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
#    #sed -i 's|bind -m vi-insert '\''"\\C-t": |bind -m vi-insert '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
#    #sed -i 's|bind -m emacs-standard -x '\''"\\C-t": |bind -m emacs-standard -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
#    #sed -i 's|bind -m vi-command -x '\''"\\C-t": |bind -m vi-command -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
#    #sed -i 's|bind -m vi-insert -x '\''"\\C-t": |bind -m vi-insert -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
#fi

# readyn -p "Change Alt-C shortcut to Ctrl-S for fzf cd?" fzf_t
# if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ]; then
#     sed -i 's|# ALT-C - cd into the selected directory|# CTRL-S - cd into the selected directory|g' ~/.fzf/shell/key-bindings.bash
#     sed -i 's|\\ec|\\C-s|g'  ~/.fzf/shell/key-bindings.bash
#     #sed -i 's|bind -m emacs-standard '\''"\\ec"|bind -m emacs-standard '\''"\\es"|g'  ~/.fzf/shell/key-bindings.bash
#     #sed -i 's|bind -m vi-command '\''"\\ec"|bind -m vi-command '\''"\\es"|g' ~/.fzf/shell/key-bindings.bash
#     #sed -i 's|bind -m vi-insert  '\''"\\ec"|bind -m vi-insert  '\''"\\es"|g' ~/.fzf/shell/key-bindings.bash
# fi
#unset fzf_t;

if ! test -f ~/.bash_aliases.d/docker-fzf.sh; then
    readyn -p "Install fzf-docker (fzf aliases for docker)?" fzf_d
    if [[ "$fzf_d" == "y" ]]; then
        if ! test -f checks/check_aliases_dir.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)
        else
            . ./checks/check_aliases_dir.sh
        fi
        curl -o ~/.bash_aliases.d/docker-fzf.sh https://raw.githubusercontent.com/MartinRamm/fzf-docker/master/docker-fzf
    fi
fi
unset fzf_t
