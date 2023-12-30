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
            if [ $PATHVAR == "~/.pathvariables.sh" ] ; then
                sed -i 's|#export FZF_DEFAULT_COMMAND|export FZF_DEFAULT_COMMAND|g' $PATHVAR
                sed -i 's|#export FZF_CTRL_T_COMMAND|export FZF_CTRL_T_COMMAND|g' $PATHVAR
            elif ! grep -q "export FZF_DEFAULT_COMMAND" $PATHVAR; then
                printf "\n# FZF\nexport FZF_DEFAULT_COMMAND='fd --search-path / --type f --hidden --follow --exclude \".dll .so .go\"'\nexport FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'" >> $PATHVAR
            fi
            if [ $PATHVAR_R == "/root/.pathvariables.sh" ] ; then
                sudo sed -i 's|#export FZF_DEFAULT_COMMAND|export FZF_DEFAULT_COMMAND|g' $PATHVAR_R
                sudo sed -i 's|#export FZF_CTRL_T_COMMAND|export FZF_CTRL_T_COMMAND|g' $PATHVAR_R 
            elif ! grep -q "export FZF_DEFAULT_COMMAND" $PATHVAR_R; then
                printf "\n# FZF\nexport FZF_DEFAULT_COMMAND='fd --search-path / --type f --hidden --follow --exclude \".dll .so .go\"'\nexport FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'" | sudo tee -a $PATHVAR_R
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
        fi

        if test -f ~/.fzf.bash ; then
            
            reade -Q "GREEN" -i "y" -p "Replace fzf bind Ctrl-Z to Ctrl-j to keep vi-undo? (other then emacs and vi editing mode)?" "y n" fzf_z
            if [ $fzf_z == "y" ] || [ -z $fzf_z ]; then
                sed -i  's|\\C-z|\\C-z|g' ~/.fzf/shell/key-bindings.bash
                sed -i  's|ctrl-z|ctrl-j|g' ~/.fzf/shell/key-bindings.bash
            fi
            
            reade -Q "GREEN" -i "y" -p "Add shortcut Ctrl-S and F3 for fzf search? (uses xdg-open) [Y/n]:" "y n" fzf_s
            if [ "$fzf_s" == "y" ] || [ -z "$fzf_s" ] ; then
                if ! grep -q '#bind -x '\''"\\C-s": ctrl-s'\''' ./aliases/shell_keybindings.sh ;  then
                    sed -i 's|bind -x '\''"\\C-s\": ctrl-s'\''|#bind -x '\''"\\C-s\": ctrl-s'\''|g' ./aliases/shell_keybindings.sh
                    sed -i 's|bind -x '\''"\\eOR\": ctrl-s'\''|#bind -x '\''"\\eOR\": ctrl-s'\''|g' ./aliases/shell_keybindings.sh
                fi
            fi
            
            reade -Q "GREEN" -i "y" -p "Change shortcut Ctrl-T to Ctrl-F? (Fzf and paste in console) [Y/n]:" "y n" fzf_t
            if [ "$fzf_t" == "y" ] || [ -z "$fzf_t" ] ; then 
                sed -i 's|bind -m emacs-standard '\''"\\C-t": |bind -m emacs-standard '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-command '\''"\\C-t": |bind -m vi-command '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-insert '\''"\\C-t": |bind -m vi-insert '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
                
                sed -i 's|bind -m emacs-standard -x '\''"\\C-t": |bind -m emacs-standard -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-command -x '\''"\\C-t": |bind -m vi-command -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-insert -x '\''"\\C-t": |bind -m vi-insert -x '\''"\\C-f": |g' ~/.fzf/shell/key-bindings.bash
            fi

            reade -Q "GREEN" -i "y" -p "Change Alt-C shortcut to Alt-F for fzf cd? [Y/n]:" "y n" fzf_f
            if [ "$fzf_f" == "y" ] || [ -z "$fzf_f" ] ; then 
                sed -i 's|# ALT-C - cd into the selected directory|# ALT-F - cd into the selected directory|g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m emacs-standard '\''"\ec": |bind -m emacs-standard '\''"\ef": |g'  ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-command '\''"\ec": |bind -m vi-command '\''"\ef": |g' ~/.fzf/shell/key-bindings.bash
                sed -i 's|bind -m vi-insert  '\''"\ec": |bind -m vi-insert  '\''"\ef": |g' ~/.fzf/shell/key-bindings.bash
            fi
            
        fi
    fi
#fi
