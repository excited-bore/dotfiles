 # !/bin/bash
. ./readline/rlwrap_scripts.sh
. ./checks/check_distro.sh
. ./checks/check_pathvar.sh

# Fzf (Fuzzy Finder)

        
 git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
 ~/.fzf/install

 # Bash completion issue with fzf fix
 # https://github.com/cykerway/complete-alias/issues/46
 if grep -q "if \[\[ -d ~/.bash_completion.d/" ~/.bashrc; then
    sed -i 's|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash||g' ~/.bashrc
    sed -i 's|\(.*if \[\[ -d ~/.bash_completion.d/.*\)|\[ -f \~/.fzf.bash \] \&\& source \~/.fzf.bash\n\n\1|g' ~/.bashrc
 fi
 . ~/.bashrc

reade -Q "GREEN" -i "y" -p "Install fd and use for fzf? (Faster find, required for file-extensions file similar to gitignore) [Y/n]: " "y n" fdr
 if [ -z $fdr ] || [ "Y" == $fdr ] || [ $fdr == "y" ]; then
    if [ "$(which fd)" == "" ]; then
        if [ $distro_base == "Arch" ];then
            yes | sudo pacman -Su fd
        elif [ $distro_base == "Debian" ]; then
            yes | sudo apt install fd-find
            ln -s $(which fdfind) ~/.local/bin/fd
        fi
    fi
    if [ ! -f ~/.fzf_history ]; then
        touch ~/.fzf_history 
    fi
    if [ $PATHVAR == ~/.pathvariables.sh ] ; then
        sed -i 's|#export FZF_DEFAULT_COMMAND|export FZF_DEFAULT_COMMAND|g' $PATHVAR
        sed -i 's|#export FZF_CTRL_T_COMMAND|export FZF_CTRL_T_COMMAND|g' $PATHVAR
        sed -i 's|#export FZF_CTRL_R_OPTS|export FZF_CTRL_R_OPTS|g' $PATHVAR
        sed -i 's|#export FZF_BIND_TYPES|export FZF_BIND_TYPES|g' $PATHVAR
    elif ! grep -q "export FZF_DEFAULT_COMMAND" $PATHVAR; then
        printf "\n# FZF\nexport FZF_DEFAULT_COMMAND=\"fd --search-path / --type f --hidden --exclude '*.dll *.pak *.bat *.so *.go' \"\nexport FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'" >> $PATHVAR
    fi
    if [ $PATHVAR_R == /root/.pathvariables.sh ] ; then
        sudo sed -i 's|#export FZF_DEFAULT_COMMAND|export FZF_DEFAULT_COMMAND|g' $PATHVAR_R
        sudo sed -i 's|#export FZF_CTRL_T_COMMAND|export FZF_CTRL_T_COMMAND|g' $PATHVAR_R
        sudo sed -i 's|#export FZF_CTRL_R_OPTS|export FZF_CTRL_R_OPTS|g' $PATHVAR_R
        sudo sed -i 's|#export FZF_BIND_TYPES|export FZF_BIND_TYPES|g' $PATHVAR_R
    elif ! sudo grep -q "export FZF_DEFAULT_COMMAND" $PATHVAR_R; then
        printf "\n# FZF\nexport FZF_DEFAULT_COMMAND=\"fd --search-path / --type f --hidden --exclude '*.dll *.pak *.bat *.so *.go' \"\nexport FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'" | sudo tee -a $PATHVAR_R
    fi
 fi
 
 # TODO: Check export for ripgrep
 # TODO: Do more with ripgrep
 reade -Q "GREEN" -i "y" -p "Install ripgrep? (Recursive grep, opens possibility for line by line fzf ) [Y/n]: " "y n" rpgrp
 if [ -z $rpgrp ] || [ "Y" == $rpgrp ] || [ $rpgrp == "y" ]; then
    if [ "$(which rg)" == "" ]; then 
        if [ $distro_base == "Arch" ];then
            yes | sudo pacman -Su ripgrep
        elif [ $distro_base == "Debian" ]; then
            yes | sudo apt install ripgrep 
        fi
    fi
    if [ $PATHVAR == ~/.pathvariables.sh ] ; then
        sed -i 's|#export RG_PREFIX|export RG_PREFIX|g' $PATHVAR
    elif ! grep -q "export RG_PREFIX" $PATHVAR; then
        printf "\n# RIPGREP\nexport RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case \"" >> $PATHVAR
    fi
    if [ $PATHVAR_R == /root/.pathvariables.sh ] ; then
        sudo sed -i 's|#export RG_PREFIX|export RG_PREFIX|g' $PATHVAR_R
    elif ! sudo grep -q "export RG_PREFIX" $PATHVAR_R; then
         printf "\n# RIPGREP\nexport RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case \"" | sudo tee -a $PATHVAR_R
    fi
    
    reade -Q "GREEN" -i "y" -p "Add shortcut for ripgrep files in dir? (Ctrl-g) [Y/n]:" "y n" rpgrpdir
    if [ -z $rpgrp ] || [ "Y" == $rpgrp ] || [ $rpgrp == "y" ]; then
        
        cp -bfv ./fzf/ripgrep-directory.sh ~/.bash_aliases.d/
        gio trash ~/.bash_aliases.d/ripgrep-directory.sh~
        if ! grep -q "ripgrep-dir" ~/.fzf/shell/key-bindings.bash; then 
            echo "#  Ctrl-g gives a ripgrep function overview" >> ~/.fzf/shell/key-bindings.bash
            echo 'bind -x '\''"\C-g": "ripgrep-dir"'\''' >> ~/.fzf/shell/key-bindings.bash
        fi
    fi
 fi
 unset rpgrp rpgrpdir
 
 if [ "$(which kitty)" == "" ] && ! grep -q "(Kitty)" ~/.fzf/shell/key-bindings.bash; then
    reade -Q "GREEN" -i "y" -p "Add shortcut for fzf-autocompletion? (CTRL-Tab) [Y/n]:" "y n" comp_key
    if [ "$comp_key" == "y" ]; then
       printf "\n# (Kitty) Ctrl-tab for fzf autocompletion" >> ~/.fzf/shell/key-bindings.bash
       printf "\nbind '\"\\\e[9;5u\": \" **\\\t\"'" >> ~/.fzf/shell/key-bindings.bash
    
    fi
 fi
 unset comp_key

 if test -f ~/.fzf.bash ; then
    if [ -f ~/.keybinds.sh ] && grep -q -w "bind '\"\\\C-z\": vi-undo'" ~/.keybinds.sh; then
        sed -i 's|\(\\C-y\\ey\\C-x\\C-x\)\\C-f|\1|g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|\\C-z|\\ep|g' ~/.fzf/shell/key-bindings.bash
        #sed -i  's|bind -m emacs-standard '\''"\C-z"|#bind -m emacs-standard '\''"\C-z"|g' ~/.fzf/shell/key-bindings.bash
        #sed -i  's|bind -m vi-command '\''"\C-z"|#bind -m vi-command '\''"\C-z"|g' ~/.fzf/shell/key-bindings.bash
        #sed -i  's|bind -m vi-insert '\''"\C-z"|#bind -m vi-insert '\''"\C-z"|g' ~/.fzf/shell/key-bindings.bash
    fi
    
    reade -Q "GREEN" -i "y" -p "Use rifle (file opener from 'ranger') to open found files and dirs with Ctrl-T filesearch shortcut? [Y/n]:" "y n" fzf_t
    if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then
        if [ "$(which rifle)" == "" ]; then
            sudo wget "https://raw.githubusercontent.com/ranger/ranger/master/ranger/ext/rifle.py" /usr/bin/
            sudo mv -v /usr/bin/rifle.py /usr/bin/rifle
            sudo chmod +x /usr/bin/rifle
            cp -bfv ranger/rifle.conf ~/.config/ranger/rifle.conf
            gio trash ~/.config/ranger/rifle.conf~
        fi
        cp -bfv fzf/keybinds_rifle.sh ~/.fzf/shell/
        gio trash ~/.fzf/shell/keybinds_rifle.sh~ 
        if ! grep -q "keybinds_rifle.sh" ~/.fzf/shell/key-bindings.bash; then
            sed -i "s|\(# Required to refresh the prompt after fzf\)|. ~\/.fzf\/shell\/keybinds_rifle.sh\n\1|" ~/.fzf/shell/key-bindings.bash;
            sed -i "s|: fzf-file-widget|: fzf_rifle|g" ~/.fzf/shell/key-bindings.bash;
        fi
    fi
    unset fzf_t

    reade -Q "GREEN" -i "y" -p "Install bat? (File previews/thumbnails for riflesearch) [Y/n]: " "y n" bat
    if [ "$bat" == "y" ]; then
        ./install_bat.sh
    fi
    unset bat 

    #TODO: keybinds-rifle sh still has ffmpegthumbnailer part (could use sed check)
    reade -Q "GREEN" -i "y" -p "Install ffmpegthumbnailer? (Video thumbnails for riflesearch) [Y/n]: " "y n" ffmpg
    if [ "$ffmpg" == "y" ]; then
        if [ "$(which ffmpegthumbnailer)" == "" ]; then 
            if [ $distro_base == "Arch" ];then
                yes | sudo pacman -Su ffmpegthumbnailer
            elif [ $distro_base == "Debian" ]; then
                yes | sudo apt update
                yes | sudo apt install ffmpegthumbnailer 
            fi
        fi 
    fi
    unset ffmpg

    reade -Q "GREEN" -i "y" -p "Change shortcut for riflesearch from Ctrl-T to Ctrl-F? (Fzf and paste in console) [Y/n]:" "y n" fzf_t
    if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then 
        sed -i 's|# CTRL-T|# CTRL-F|g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m emacs-standard '\''"\\C-t": |bind -m emacs-standard '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m vi-command '\''"\\C-t": |bind -m vi-command '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m vi-insert '\''"\\C-t": |bind -m vi-insert '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m emacs-standard -x '\''"\\C-t": |bind -m emacs-standard -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m vi-command -x '\''"\\C-t": |bind -m vi-command -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
        sed -i 's|bind -m vi-insert -x '\''"\\C-t": |bind -m vi-insert -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
    fi

    reade -Q "GREEN" -i "y" -p "Add shortcut F3 for fzf rifle? [Y/n]:" "y n" fzf_t
    if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then
        if ! grep -q 'bind -x '\''"\\eOR": "fzf_rifle"'\''' ~/.fzf/shell/key-bindings.bash ;  then              
            sed -i 's|\(# CTRL-S\)|# F3 - Rifle search\n  bind -x '\''"\\eOR\": "fzf_rifle"'\''\n\n  \1|g' ~/.fzf/shell/key-bindings.bash
        fi
    fi

    if [ "$(which xclip)" == "" ]; then 
        reade -Q "GREEN" -i "y" -p "Install xclip? (Clipboard tool for Ctrl-R/Reverse history shortcut) [Y/n]: " "y n" xclip
        if [ "$tree" == "y" ]; then
            if [ $distro_base == "Arch" ];then
                yes | sudo pacman -Su xclip
            elif [ $distro_base == "Debian" ]; then
                yes | sudo apt update
                yes | sudo apt install xclip 
            fi
        fi
        if [ $PATHVAR == ~/.pathvariables.sh ] ; then
            sed -i 's|#export FZF_CTRL_R_OPTS=|export FZF_CTRL_R_OPTS=|g' $PATHVAR
        elif ! grep -q "export FZF_CTRL_R_OPTS=" $PATHVAR; then
            printf "\nexport FZF_CTRL_R_OPTS=\" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-t:toggle-preview' --bind 'alt-c:execute-silent(echo -n {2..} | xclip -i -sel c)+abort' --color header:italic --header 'Press ALT-C to copy command into clipboard'\"" >> $PATHVAR
        fi
        if [ $PATHVAR_R == /root/.pathvariables.sh ] ; then
            sudo sed -i 's|#export FZF_CTRL_R_OPTS==|export FZF_CTRL_R_OPTS=|g' $PATHVAR_R
        elif ! sudo grep -q "export FZF_CTRL_R_OPTS" $PATHVAR_R; then
            printf "\nexport FZF_CTRL_R_OPTS=\" --preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-t:toggle-preview' --bind 'alt-c:execute-silent(echo -n {2..} | xclip -i -sel c)+abort' --color header:italic --header 'Press ALT-C to copy command into clipboard'\"" | sudo tee -a $PATHVAR_R
        fi 
    fi
    unset xclip

    reade -Q "GREEN" -i "y" -p "Install tree? (Builtin cd shortcut gets a nice directory tree preview ) [Y/n]: " "y n" tree
    if [ "$tree" == "y" ]; then
        if [ "$(which tree)" == "" ]; then 
            if [ $distro_base == "Arch" ];then
                yes | sudo pacman -Su tree
            elif [ $distro_base == "Debian" ]; then
                yes | sudo apt update
                yes | sudo apt install tree 
            fi
        fi
        if [ $PATHVAR == ~/.pathvariables.sh ] ; then
            sed -i 's|#export FZF_ALT_C_OPTS=|export FZF_ALT_C_OPTS=|g' $PATHVAR
        elif ! grep -q "export FZF_ALT_C_OPTS" $PATHVAR; then
            printf "\nexport FZF_ALT_C_OPTS=\"--preview 'tree -C {}\"" >> $PATHVAR
        fi
        if [ $PATHVAR_R == /root/.pathvariables.sh ] ; then
            sudo sed -i 's|#export FZF_ALT_C_OPTS=|export FZF_ALT_C_OPTS=|g' $PATHVAR_R
        elif ! sudo grep -q "export FZF_ALT_C_OPTS" $PATHVAR_R; then
            printf "\nexport FZF_ALT_C_OPTS=\"--preview 'tree -C {}\"" | sudo tee -a $PATHVAR_R
        fi 
    fi
    unset tree

   # reade -Q "GREEN" -i "y" -p "Change Alt-C shortcut to Ctrl-S for fzf cd? [Y/n]:" "y n" fzf_t
   # if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ]; then 
   #     sed -i 's|# ALT-C - cd into the selected directory|# CTRL-S - cd into the selected directory|g' ~/.fzf/shell/key-bindings.bash
   #     sed -i 's|\\ec|\\C-s|g'  ~/.fzf/shell/key-bindings.bash
   #     #sed -i 's|bind -m emacs-standard '\''"\\ec"|bind -m emacs-standard '\''"\\es"|g'  ~/.fzf/shell/key-bindings.bash
   #     #sed -i 's|bind -m vi-command '\''"\\ec"|bind -m vi-command '\''"\\es"|g' ~/.fzf/shell/key-bindings.bash
   #     #sed -i 's|bind -m vi-insert  '\''"\\ec"|bind -m vi-insert  '\''"\\es"|g' ~/.fzf/shell/key-bindings.bash
   # fi
    
    unset fzf_t;

 fi
