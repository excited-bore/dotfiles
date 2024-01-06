 # !/bin/bash
. ./readline/rlwrap_scripts.sh
. ./checks/check_distro.sh
. ./checks/check_pathvar.sh

# Fzf (Fuzzy Finder)

#if [ ! -x "$(command -v fzf)" ]; then
    reade -Q "GREEN" -i "y" -p "Install fzf? (Fuzzy file/folder finder - keybinding yes for upgraded Ctrl-R/reverse-search, fzf filenames on Ctrl+T and fzf-version of 'cd' on Alt-C + Custom script: Ctrl-f becomes system-wide file opener) [Y/n]: " "y n" findr
    if [ -z $findr ] || [ "Y" == $findr ] || [ $findr == "y" ]; then
        
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
        
        reade -Q "GREEN" -i "y" -p "Install fd and use for fzf? (Faster find) [Y/n]: " "y n" fdr
        if [ -z $fdr ] || [ "Y" == $fdr ] || [ $fdr == "y" ]; then
            if [ ! -x "$(command -v fd)" ]; then
                if [ $distro_base == "Arch" ];then
                    yes | sudo pacman -Su fd
                elif [ $distro_base == "Debian" ]; then
                    yes | sudo apt update
                    yes | sudo apt install fd 
                fi
            fi
            if [ $PATHVAR == ~/.pathvariables.sh ] ; then
                sed -i 's|#export FZF_DEFAULT_COMMAND|export FZF_DEFAULT_COMMAND|g' $PATHVAR
                sed -i 's|#export FZF_CTRL_T_COMMAND|export FZF_CTRL_T_COMMAND|g' $PATHVAR
            elif ! grep -q "export FZF_DEFAULT_COMMAND" $PATHVAR; then
                printf "\n# FZF\nexport FZF_DEFAULT_COMMAND=\"fd --search-path / --type f --hidden --exclude '*.dll *.pak *.bat *.so *.go' \"\nexport FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'" >> $PATHVAR
            fi
            if [ $PATHVAR_R == /root/.pathvariables.sh ] ; then
                sudo sed -i 's|#export FZF_DEFAULT_COMMAND|export FZF_DEFAULT_COMMAND|g' $PATHVAR_R
                sudo sed -i 's|#export FZF_CTRL_T_COMMAND|export FZF_CTRL_T_COMMAND|g' $PATHVAR_R 
            elif ! sudo grep -q "export FZF_DEFAULT_COMMAND" $PATHVAR_R; then
                printf "\n# FZF\nexport FZF_DEFAULT_COMMAND=\"fd --search-path / --type f --hidden --exclude '*.dll *.pak *.bat *.so *.go' \"\nexport FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'" | sudo tee -a $PATHVAR_R
            fi
        fi
        
        reade -Q "GREEN" -i "y" -p "Install ripgrep? (Recursive grep, opens possibility for line by line fzf ) [Y/n]: " "y n" rpgrp
        if [ -z $rpgrp ] || [ "Y" == $rpgrp ] || [ $rpgrp == "y" ]; then
            if [ ! -x "$(command -v fd)" ]; then 
                if [ $distro_base == "Arch" ];then
                    yes | sudo pacman -Su ripgrep
                elif [ $distro_base == "Debian" ]; then
                    yes | sudo apt update
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
        fi

        if test -f ~/.fzf.bash ; then
            if [ -f ~/.bash_aliases/shell_keybindings.sh ] && grep -w '\C-z' ~/.bash_aliases/shell_keybindings.sh == "bind '\"\\C-z\": vi-undo'"; then
                sed -i 's|\\C-f||g'
                sed -i 's|\\C-z|\\C-f|g'
                #sed -i  's|bind -m emacs-standard '\''"\C-z"|#bind -m emacs-standard '\''"\C-z"|g' ~/.fzf/shell/key-bindings.bash
                #sed -i  's|bind -m vi-command '\''"\C-z"|#bind -m vi-command '\''"\C-z"|g' ~/.fzf/shell/key-bindings.bash
                #sed -i  's|bind -m vi-insert '\''"\C-z"|#bind -m vi-insert '\''"\C-z"|g' ~/.fzf/shell/key-bindings.bash
            fi
            
            reade -Q "GREEN" -i "y" -p "Use rifle (file opener from 'ranger') to open found files and dirs with default shortcut?:" "y n" fzf_t
            if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then
                if ! [ -x "$(command -v rifle)" ]; then
                    sudo wget "https://raw.githubusercontent.com/ranger/ranger/master/ranger/ext/rifle.py" /usr/bin/
                    sudo mv -v /usr/bin/rifle.py /usr/bin/rifle
                    sudo chmod +x /usr/bin/rifle
                    cp -fv ranger/rifle.conf ~/.config/ranger/rifle.conf 
                fi
                cp -fv fzf/keybinds_rifle.sh ~/.fzf/shell/
                if ! grep -q "keybinds_rifle.sh" ~/.fzf/shell/key-bindings.bash; then
                    sed -i "s|\(# Required to refresh the prompt after fzf\)|. ~\/.fzf\/shell\/keybinds_rifle.sh\n\1|" ~/.fzf/shell/key-bindings.bash;
                    sed -i "s|: fzf-file-widget|: fzf_rifle|g" ~/.fzf/shell/key-bindings.bash;
                fi
            fi

            
            reade -Q "GREEN" -i "y" -p "Change shortcut for riflesearch from Ctrl-T to Ctrl-S? (Fzf and paste in console) [Y/n]:" "y n" fzf_t
            if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then 
                sed -i 's|# CTRL-T|# CTRL-S|g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m emacs-standard '\''"\\C-t": |bind -m emacs-standard '\''"\\C-s": |g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-command '\''"\\C-t": |bind -m vi-command '\''"\\C-s": |g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-insert '\''"\\C-t": |bind -m vi-insert '\''"\\C-s": |g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m emacs-standard -x '\''"\\C-t": |bind -m emacs-standard -x '\''"\\C-s": |g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-command -x '\''"\\C-t": |bind -m vi-command -x '\''"\\C-s": |g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-insert -x '\''"\\C-t": |bind -m vi-insert -x '\''"\\C-s": |g' ~/.fzf/shell/key-bindings.bash
            fi

            reade -Q "GREEN" -i "y" -p "Add shortcut F3 for fzf rifle? [Y/n]:" "y n" fzf_t
            if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then
                if ! grep -q 'bind -x '\''"\\eOR": "fzf_rifle"'\''' ~/.fzf/shell/key-bindings.bash ;  then              
                    sed -i 's|\(# CTRL-S\)|# F3 - Rifle search\n  bind -x '\''"\\eOR\": "fzf_rifle"'\''\n  \1|g' ~/.fzf/shell/key-bindings.bash
                fi
            fi


            reade -Q "GREEN" -i "y" -p "Change Alt-C shortcut to Alt-S for fzf cd? [Y/n]:" "y n" fzf_t
            if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then 
                sed -i 's|# ALT-C - cd into the selected directory|# ALT-S - cd into the selected directory|g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m emacs-standard '\''"\\ec"|bind -m emacs-standard '\''"\\es"|g'  ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-command '\''"\\ec"|bind -m vi-command '\''"\\es"|g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-insert  '\''"\\ec"|bind -m vi-insert  '\''"\\es"|g' ~/.fzf/shell/key-bindings.bash
            fi
            
            unset fzf_t

        fi
    fi
#fi
