# https://github.com/junegunn/fzf

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

# Doesn't matter the argument, will just asume were doing a simple installation

if test -z "$1"; then
    if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh)
    else
        . ./checks/check_envvar_aliases_completions_keybinds.sh
    fi
fi


# Fzf (Fuzzy Finder)

# Remove older versions
if hash fzf &> /dev/null && version-higher '0.6' "$(fzf --version | awk '{print $1}')"; then
   eval "${pac_rm_y} fzf" 
fi

if ! hash fzf &> /dev/null; then
    if [[ $distro_base == 'Debian' ]]; then
        FZF_VERSION=$(wget-curl "https://api.github.com/repos/junegunn/fzf/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+') 
        dir=$(mktemp -d)
        if [[ "$arch" == '386' || "$arch" == 'amd64' || "$arch" == 'amd32' ]]; then
            archf='amd64' 
        elif [[ "$arch" =~ arm ]]; then
            archf=$arch 
        fi
        wget-aria-name $dir/fzf.tar.gz "https://github.com/junegunn/fzf/releases/latest/download/fzf-$FZF_VERSION-linux_$archf.tar.gz"
        sudo tar xf $dir/fzf.tar.gz -C /usr/local/bin
        unset dir archf 
    else 
        eval "$pac_ins_y fzf" 
    fi
fi

fzf --help | $PAGER

if test -z "$1"; then

    # Bash completion issue with fzf fix
    # https://github.com/cykerway/complete-alias/issues/46
    ! [ -f ~/.bash_completion.d/fzf-completion.bash ] &&
        wget-aria-name ~/.bash_completion.d/fzf-completion.bash https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/completion.bash

    #if ! test -d ~/.fzf || test -f ~/.fzf.bash; then
        #git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        #~/.fzf/install
        #command rm -v ~/.fzf.bash
        #sed -i '/\[ -f \~\/.fzf.bash \] \&\& source \~\/.fzf.bash/d' ~/.bashrc

    #fi

    printf "${cyan}Fzf${normal} keybinds:\n\t - Fzf history on Ctrl-R (replaces reverse-search-history)\n\t - Filepath retriever on Ctrl-T\n\t - Directory navigator on Alt-C\n\t - **<TAB> for fzf completion on some commands\n"
    readyn -p "Use fzf keybinds?" -c "! test -f ~/.keybinds.d/fzf-bindings.bash" fzf_key
    if [[ "$fzf_key" == 'y' ]]; then
        test -f $BASH_KEYBIND_FILEDIR/fzf-bindings.bash && 
            rm $BASH_KEYBIND_FILEDIR/fzf-bindings.bash
        wget-aria-name ~/.keybinds.d/fzf-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/key-bindings.bash
    fi

    sed -i 's|\\\C-z|\\\C-o|g; s|) \&\& printf '\''builtin cd -- %q'\'' "$(builtin unset CDPATH \&\& builtin cd -- "$dir" \&\& builtin pwd)"|); [[ -n $dir ]] \&\& cd -- "$dir"|g; s|\(if \[\[ "${FZF_ALT_C_COMMAND-x}" != "" \]\]; then\)|\1\n  bind -x '\''"\\e987": "__fzf_cd__"'\''|g; s|\(bind -m emacs-standard '\''"\).*|\1\\\e[1;3B": "\\e987_\\C-m"'\''|g; s|\(bind -m vi-command '\''"\).*|\1\\\e[1;3B": "\\e987_\\C-m"'\''|g; s|\(bind -m vi-insert '\''"\).*|\1\\\e[1;3B": "\\e987_\\C-m"'\''|g' $BASH_KEYBIND_FILEDIR/fzf-bindings.bash

    unset fzf_key

    #if [[ $ENV =~ '.environment.env' ]]; then
    #    sed -i 's|.export PATH=$PATH:$HOME/.fzf/bin|export PATH=$PATH:$HOME/.fzf/bin|g' $ENV
    #elif ! grep -q '.fzf/bin' $ENV; then
    #    if grep -q '~/.environment.env' $ENV; then
    #        sed -i 's|\(\[ -f ~/.environment.env\] \&\& source \~/.environment.env\)|\export PATH=$PATH:$HOME/.fzf/bin\n\n\1\n|g' $ENV
    #    elif grep -q '~/.bash_aliases' $ENV; then
    #        sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\export PATH=$PATH:$HOME/.fzf/bin/\n\n\1\n|g' $ENV
    #        sed -i 's|\(if \[ -f ~/.bash_aliases \]; then\)|export PATH=$PATH:$HOME/.fzf/bin\n\n\1\n|g' $ENV
    #    else
    #        echo 'export PATH="$PATH:$HOME/.fzf/bin"' >>$ENV
    #    fi
    #fi

    #export PATH="$PATH:$HOME/.fzf/bin"

    if ! [ -f ~/.fzf_history ]; then
        touch ~/.fzf_history
    fi

    # TODO: Make better check: https://github.com/sharkdp/fd
    if ! hash fd-find &>/dev/null && ! hash fd &>/dev/null; then
        readyn -p "Install fd and use for fzf? (A faster variant of 'find')" fdr
        if [[ "$fdr" == "y" ]]; then
            if ! test -f install_fd.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fd.sh)
            else
                . ./install_fd.sh
            fi
        fi
    fi

    # BFS: Mostly usefull for Alt-C / Alt-Down keybind but still very usefull in that regard 
    if ! hash bfs &>/dev/null; then
        readyn -p "Install bfs (A breadth-first find variant rather then depth-first - first results are closer to current directory)?" bfsnstll
        if [[ "$bfsnstll" == "y" ]]; then
            if ! test -f install_bfs.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bfs.sh)
            else
                . ./install_bfs.sh
            fi
        fi
    fi

    opts="find"
    printf "${GREEN}The options for Fzf's internal command at default are:\n" 
    printf "${green}\t- ${CYAN}find${green}: The default UNIX command finding files and folders. It is depth-first so it will show the longest pathnames before shorter ones\n${normal}" 
    (hash fd-find &> /dev/null || hash fd &> /dev/null) && 
        printf "${green}\t- ${CYAN}fd${green}: A faster variant of 'find' written in rust and although it has not all of find's features, it's results come with way more distinct colors out of the box. It is also depth-first.\n${normal}" &&
        opts="$opts fd" 
    hash bfs &> /dev/null && 
        printf "${green}\t- ${CYAN}bfs${green}: A 'breadth-first' find variant that unlike find or fd will show short pathnames relative to the current path faster then longer pathnames. It also is written in C.\n${normal}" &&
        opts="$opts bfs" 
    
    reade -Q 'GREEN' -i "$opts" -p "Which command should be default for fzf?" fnd

    # BAT
    if ! hash bat &>/dev/null; then
        readyn -p "Install bat? (File previews/thumbnails for riflesearch)" bat
        if [[ "$bat" == "y" ]]; then
            if ! test -f install_bat.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)
            else
                . ./install_bat.sh
            fi
        fi
        unset bat
    fi

    # TREE
    if ! hash tree &>/dev/null; then
        readyn -p "Install tree? (Builtin cd shortcut gets a nice directory tree preview )" tree
        if [[ "$tree" == "y" ]]; then
            if ! test -f install_tree.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_tree.sh)
            else
                . ./install_tree.sh
            fi
        fi
        unset tree
    fi

    #TODO: fzf-rifle.sh still has ffmpegthumbnailer part (could use sed check)
    if ! hash ffmpegthumbnailer &>/dev/null; then
        readyn -p "Install ffmpegthumbnailer? (Video thumbnails for riflesearch)" ffmpg
        if [[ "$ffmpg" == "y" ]]; then
            if ! test -f install_ffmpegthumbnailer.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ffmpegthumbnailer.sh)
            else
                . ./install_ffmpegthumbnailer.sh
            fi
        fi
        unset ffmpg
    fi

    # RIPGREP
    # TODO: Check export for ripgrep
    # TODO: Do more with ripgrep
    if ! hash rg &>/dev/null; then
        readyn -y -p "Install ripgrep? (Recursive grep, opens possibility for line by line fzf )" rpgrp
        if [[ "$rpgrp" == "y" ]]; then
            if ! test -f install_ripgrep.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ripgrep.sh)
            else
                . ./install_ripgrep.sh
            fi
            if [[ $ENV == ~/.environment.env ]]; then
                sed -i 's|#export RG_PREFIX|export RG_PREFIX|g' $ENV
            elif ! grep -q "export RG_PREFIX" $ENV; then
                printf "\n# RIPGREP\nexport RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case \"" >>$ENV &>/dev/null
            fi
            if [[ $ENV_R == /root/.environment.env ]]; then
                sudo sed -i 's|#export RG_PREFIX|export RG_PREFIX|g' $ENV_R
            elif ! sudo grep -q "export RG_PREFIX" $ENV_R; then
                printf "\n# RIPGREP\nexport RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case \"" | sudo tee -a $ENV_R &> /dev/null
            fi

            readyn -p "Add shortcut for ripgrep files in dir? (Ctrl-g)" rpgrpdir
            if [[ "$rpgrpdir" == "y" ]]; then
                if test -f aliases/.bash_aliases.d/ripgrep-directory.sh; then
                    cp aliases/.bash_aliases.d/ripgrep-directory.sh ~/.bash_aliases.d/
                else
                    wget-aria-dir ~/.bash_aliases.d/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ripgrep-directory.sh
                fi
            fi
        fi
        unset rpgrp rpgrpdir
    fi

    # XCLIP / WL-CLIPBOARD
    if [[ $machine == 'Linux' ]]; then
        if ([[ "$XDG_SESSION_TYPE" == 'x11' ]] && (! hash xclip &> /dev/null || ! hash xsel &> /dev/null)) || ([[ "$XDG_SESSION_TYPE" == 'wayland' ]] && (! hash wl-copy &> /dev/null || ! hash wl-paste &> /dev/null)); then
            if ! test -f install_linux_clipboard.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_linux_clipboard.sh)
            else
                . ./install_linux_clipboard.sh
            fi
        fi
        if ([[ "$XDG_SESSION_TYPE" == 'x11' ]] && (hash xclip &> /dev/null)) || ([[ "$XDG_SESSION_TYPE" == 'wayland' ]] && (hash wl-copy &> /dev/null)); then
            if [[ "$XDG_SESSION_TYPE" == 'x11' ]] && hash xclip &> /dev/null; then
                clip="xclip -i -sel c" 
            elif [[ "$XDG_SESSION_TYPE" == 'wayland' ]] && hash wl-copy &> /dev/null; then
                clip="wl-copy" 
            fi
            if [[ "$ENV" == ~/.environment.env ]]; then
                sed -i 's|#export FZF_CTRL_R_OPTS=|export FZF_CTRL_R_OPTS=|g' $ENV
            elif ! grep -q "export FZF_CTRL_R_OPTS=" $ENV; then
                printf "\nexport FZF_CTRL_R_OPTS=\" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-t:toggle-preview' --bind 'alt-c:execute-silent(echo -n {2..} | $clip)+abort' --color header:italic --header 'Press ALT-C to copy command into clipboard'\"\n" >> $ENV &>/dev/null
            fi
            if [[ "$ENV_R" == /root/.environment.env ]]; then
                sudo sed -i 's|#export FZF_CTRL_R_OPTS==|export FZF_CTRL_R_OPTS=|g' $ENV_R
            elif ! sudo grep -q "export FZF_CTRL_R_OPTS" $ENV_R; then
                printf "\nexport FZF_CTRL_R_OPTS=\" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-t:toggle-preview' --bind 'alt-c:execute-silent(echo -n {2..} | $clip)+abort' --color header:italic --header 'Press ALT-C to copy command into clipboard'\"\n" | sudo tee -a $ENV_R &>/dev/null
            fi
            unset clip 
        fi
    fi

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

    if [[ $ENV == ~/.environment.env ]]; then
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
    if [[ $ENV_R == /root/.environment.env ]]; then
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
    #        if ! test -f .keybinds.d/keybinds.bash && ! grep -q "(Kitty)" ~/.keybinds.d/fzf-bindings.bash; then
    #            printf "\n# (Kitty) Ctrl-tab for fzf autocompletion" >> ~/.keybinds.d/fzf-bindings.bash
    #            printf "\nbind '\"\\\e[9;5u\": \" **\\\t\"'" >> ~/.keybinds.d/fzf-bindings.bash
    #       fi
    #     fi
    #fi
    #unset comp_key

    if ! test -f /usr/bin/rifle || ! test -f $HOME/.bash_aliases.d/fzf-rifle.sh; then
        readyn -p "Use rifle (file opener from 'ranger') to open found files and dirs with a custom Ctrl-F filesearch shortcut?" fzf_f
        if [[ "$fzf_f" == "y" ]]; then
            if ! hash rifle &>/dev/null; then
                if ! hash python &>/dev/null; then
                    if [[ "$distro_base" == 'Debian' ]]; then
                        eval "${pac_ins_y}" python3 python-is-python3
                    elif [[ "$distro_base" == 'Arch' ]]; then
                        eval "${pac_ins_y}" python
                    fi
                fi
                sudo wget-aria-dir /usr/bin/ https://raw.githubusercontent.com/ranger/ranger/master/ranger/ext/rifle.py
                sudo mv -v /usr/bin/rifle.py /usr/local/bin/rifle
                sudo chmod 755 /usr/bin/rifle
            fi
            if ! test -f ranger/.config/ranger/rifle.conf; then
                wget-aria-dir ~/.config/ranger/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/ranger/.config/ranger/rifle.conf
                wget-aria-dir ~/.bash_aliases.d/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/fzf/.bash_aliases.d/fzf-rifle.sh
            else
                mkdir -p ~/.config/ranger
                cp ranger/.config/ranger/rifle.conf ~/.config/ranger/
                cp fzf/.bash_aliases.d/fzf-rifle.sh ~/.bash_aliases.d/
            fi
            sed -i 's/\\\C-f//g' ~/.keybinds.d/fzf-bindings.bash
            sed -i "s|\(bind -m vi-insert '\"\\\C-t\":.*\)|\1\n\n    # CTRL-F - Search with previews and other handy additions\n    bind -m emacs-standard '\"\\\C-f\": \"\\\C-t\"'\n    bind -m vi-command '\"\\\C-f\": \"\\\C-o\\\C-f\\\C-o\"'\n    bind -m vi-insert '\"\\\C-f\": \"\\\C-o\\\C-f\\\C-o\"'|g" ~/.keybinds.d/fzf-bindings.bash
            sed -i "s|\(bind -m vi-insert -x '\"\\\C-t\":.*\)|\1\n\n    # CTRL-F - Search with previews and other handy additions\n    bind -m emacs-standard -x '\"\\\C-f\": fzf_rifle'\n    bind -m vi-command -x '\"\\\C-f\": fzf_rifle'\n    bind -m vi-insert -x '\"\\\C-f\":  fzf_rifle'|g" ~/.keybinds.d/fzf-bindings.bash
        fi
    fi
    unset fzf_f

    #readyn -p "Add shortcut for riflesearch on Ctrl-F? (Fzf and paste in console)" fzf_t
    #if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then
    #    #sed -i 's|# CTRL-T|# CTRL-F|g' ~/.keybinds.d/fzf-bindings.bash
    #
    #    #sed -i 's|bind -m vi-command '\''"\\C-t": |bind -m vi-command '\''"\\C-f": |g' ~/.keybinds.d/fzf-bindings.bash
    #    #sed -i 's|bind -m vi-insert '\''"\\C-t": |bind -m vi-insert '\''"\\C-f": |g' ~/.keybinds.d/fzf-bindings.bash
    #    #sed -i 's|bind -m emacs-standard -x '\''"\\C-t": |bind -m emacs-standard -x '\''"\\C-f": |g' ~/.keybinds.d/fzf-bindings.bash
    #    #sed -i 's|bind -m vi-command -x '\''"\\C-t": |bind -m vi-command -x '\''"\\C-f": |g' ~/.keybinds.d/fzf-bindings.bash
    #    #sed -i 's|bind -m vi-insert -x '\''"\\C-t": |bind -m vi-insert -x '\''"\\C-f": |g' ~/.keybinds.d/fzf-bindings.bash
    #fi

    # readyn -p "Change Alt-C shortcut to Ctrl-S for fzf cd?" fzf_t
    # if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ]; then
    #     sed -i 's|# ALT-C - cd into the selected directory|# CTRL-S - cd into the selected directory|g' ~/.keybinds.d/fzf-bindings.bash
    #     sed -i 's|\\ec|\\C-s|g'  ~/.keybinds.d/fzf-bindings.bash
    #     #sed -i 's|bind -m emacs-standard '\''"\\ec"|bind -m emacs-standard '\''"\\es"|g'  ~/.keybinds.d/fzf-bindings.bash
    #     #sed -i 's|bind -m vi-command '\''"\\ec"|bind -m vi-command '\''"\\es"|g' ~/.keybinds.d/fzf-bindings.bash
    #     #sed -i 's|bind -m vi-insert  '\''"\\ec"|bind -m vi-insert  '\''"\\es"|g' ~/.keybinds.d/fzf-bindings.bash
    # fi
    #unset fzf_t;

    if ! test -f ~/.bash_aliases.d/docker-fzf.sh; then
        readyn -p "Install fzf-docker (fzf aliases for docker)?" -c "! test -f $HOME/.bash_aliases.d/docker-fzf.sh" fzf_d
        if [[ "$fzf_d" == "y" ]]; then
            if ! test -f checks/check_aliases_dir.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)
            else
                . ./checks/check_aliases_dir.sh
            fi
            wget-aria-name ~/.bash_aliases.d/docker-fzf.sh https://raw.githubusercontent.com/MartinRamm/fzf-docker/master/docker-fzf
        fi
    fi
    unset fzf_t
fi
