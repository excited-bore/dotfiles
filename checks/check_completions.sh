! hash bash &> /dev/null && SYSTEM_UPDATED='TRUE' ||
    [ -f /usr/share/bash-completion/bash_completion ] && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! [[ -f $TOP/checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if (test -z "$BASH_C" && hash bash &> /dev/null && (! test -f ~/.bashrc || ! test -d ~/.bash_completion.d || ! test -f ~/.bash_completion || ! test -f /etc/bash.bashrc || ! test -d /usr/share/bash-completion/completions/ || ! test -f /usr/share/bash-completion/bash_completion)) && (test -z "$ZSH_C" && hash zsh &> /dev/null && (! test -f ~/.zshrc || ! test -d ~/.zsh_completion.d/site-functions || ! test -f ~/.zsh_completion || ! test -f /etc/zshrc || ! test -d /usr/share/zsh/site-functions/ || ! test -f /etc/zsh_completion)); then
   reade -Q 'GREEN' -i 'both bash zsh' -p "Create directories and install files for completion functions for ${CYAN}Bash${GREEN}, ${CYAN}Zsh${GREEN} or both? [Both/bash/zsh]: " bash_zsh_comp
elif (test -z "$BASH_C" && hash bash &> /dev/null && (! test -f ~/.bashrc || ! test -d ~/.bash_completion.d || ! test -f ~/.bash_completion || ! test -f /etc/bash.bashrc || ! test -d /usr/share/bash-completion/completions/ || ! test -f /usr/share/bash-completion/bash_completion)); then
   readyn -p "Install completion functions for ${CYAN}Bash${GREEN}?" bash_zsh_comp
   [[ "$bash_zsh_comp" == 'y' ]] && bash_zsh_comp='bash' 
elif (test -z "$ZSH_C" && hash zsh &> /dev/null && (! test -f ~/.zshrc || ! test -d ~/.zsh_completion.d/site-functions || ! test -f ~/.zsh_completion || ! test -f /etc/zshrc || ! test -d /usr/share/zsh/site-functions/ || ! test -f /etc/zsh_completion)); then
   readyn -p "Install completion functions for ${CYAN}Zsh${GREEN}?" bash_zsh_comp
   [[ "$bash_zsh_comp" == 'y' ]] && bash_zsh_comp='zsh' 
fi

if [[ "$bash_zsh_comp" == 'both' || "$bash_zsh_comp" == 'bash' ]]; then
    BASH="1" 
    if test -z "$BASH_C_G" && (! test -f /etc/bash.bashrc || ! test -d /usr/share/bash-completion/completions/ || ! test -f /usr/share/bash-completion/bash_completion); then
        readyn -p "Configure ${CYAN}bash${GREEN} completions ${CYAN}systemwide/for all users${GREEN}?" bash_g
        if [[ "$bash_g" == 'y' ]]; then
            BASH_C_G='1'
        fi
    fi
fi
if [[ "$bash_zsh_comp" == 'both' || "$bash_zsh_comp" == 'zsh' ]]; then
    ZSH_C="1" 
    if test -z "$ZSH_C_G" && (! test -f /etc/zshrc || ! test -d /usr/share/bash-completion/completions/ || ! test -f /etc/zsh_completion); then
        readyn -p "Configure ${CYAN}zsh${GREEN} completions ${CYAN}systemwide/for all users${GREEN}?" zsh_g
        if [[ "$zsh_g" == 'y' ]]; then
            ZSH_C_G='1'
        fi
    fi
fi

if (test -n "$BASH_C" && (! test -d ~/.bash_completion.d)) || (test -n "$ZSH_C" && (! test -d ~/.zsh_completion.d/site-functions)); then
    if test -n "$BASH_C" && ! test -d ~/.bash_completion.d/; then
        printf "${YELLOW}$HOME/.bash_completion.d/${yellow} not created${normal}\n" 
        readyn -p "Create ${CYAN}$HOME/.bash_completion.d/${GREEN}?" bcompletions_d
        if [[ "$bcompletions_d" == 'y' ]]; then
            mkdir $HOME/.bash_completion.d 
        fi
    fi
    if test -n "$ZSH_C" && ! test -d ~/.zsh_completion.d/site-functions; then
        printf "${YELLOW}$HOME/.zsh_completion.d/site-functions${yellow} not created${normal}\n" 
        readyn -p "Create ${CYAN}$HOME/.zsh_completion.d/site-functions${GREEN}?" zcompletions_d
        if [[ "$zcompletions_d" == 'y' ]]; then
            mkdir -p $HOME/.zsh_completion.d/site-functions 
        fi
    fi

    
    if test -n "$BASH_C" && (test -d ~/.bash_completion.d) && ! test -f $HOME/.bash_completion; then
        
        if ! test -f ~/.bashrc; then
            touch $HOME/.bashrc 
        fi
        
        printf "${YELLOW}$HOME/.bash_completion${yellow} not installed${normal}\n" 
        bash_comp="$TOP/shell/completions/.bash_completion"    
        if ! test -f $bash_comp; then
            temp=$(mktemp -d) 
            wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/completion/.bash_completion > $temp/.bash_completion 
            bash_comp=$temp/.bash_completion 
        fi
        
        bash_comp(){
            cp $bash_comp $HOME
            # In default Ubuntu bashrc, there's 3 lines:
            # 'if [[ -f ~/.bash_aliases ]]; then
            #   . ~/.bash_aliases
            # fi'
            # ~/.bash_completion should get sourced before this
            if ! grep -q '\[ -f ~/.bash_completion \] && \[ -z ${BASH_COMPLETION_VERSINFO:-} \] && source ~/.bash_completion' ~/.bashrc; then
                if grep -q "[ -f ~/.bash_aliases ] && source ~/.bash_aliases" ~/.bashrc || grep -q '^if \[ -f ~/.bash_aliases \]; then' ~/.bashrc; then
                    if grep -q "[ -f ~/.bash_aliases ] && source ~/.bash_aliases" ~/.bashrc; then
                        sed -i 's|\([ -f ~/.bash_aliases ] \&\& source ~/.bash_aliases\)|[ -f ~/.bash_completion ] \&\& [ -z ${BASH_COMPLETION_VERSINFO:-} ] \&\& source ~/.bash_completion\n\n\1|' ~/.bashrc 
                    else
                        sed -i 's|\(\^if [[ -f ~/.bash_aliases ]]; then\)|[ -f ~/.bash_completion ] \&\& [ -z ${BASH_COMPLETION_VERSINFO:-} ] \&\& source ~/.bash_completion\n\n\1|' ~/.bashrc 
                    fi
                elif grep -q "[ -f ~/.bash_keybinds ] && source ~/.bash_keybinds" ~/.bashrc; then
                    sed -i 's|\([ -f ~/.bash_keybinds ] \&\& source ~/.bash_keybinds\)|[ -f ~/.bash_completion ] \&\& [ -z ${BASH_COMPLETION_VERSINFO:-} ] \&\& source ~/.bash_completion\n\n\1|' ~/.bashrc 
                else
                    printf "\n[ -f ~/.bash_completion ] && [ -z \${BASH_COMPLETION_VERSINFO:-} ] && source ~/.bash_completion\n\n" >> ~/.bashrc
                fi
            fi
        }
        yes-edit-no -f bash_comp -g "$bash_comp" -p "Install $HOME/.bash_completion? (Sources /usr/share/bash-completion/bash_completion and everything under $HOME/.bash_completion.d)?"
    fi
    
    if test -n "$ZSH_C" && (test -d ~/.zsh_completion.d/site-functions) && ! test -f $HOME/.zsh_completion; then
        
        if ! test -f ~/.zshrc; then
            touch $HOME/.zshrc 
        fi

        printf "${YELLOW}$HOME/.zsh_completion${yellow} not installed${normal}\n" 
        zsh_alias="$TOP/shell/completion/.zsh_completion"    
        if ! test -f $zsh_alias; then
            temp=$(mktemp -d) 
            wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/completion/.zsh_completion > $temp/.zsh_completion 
            zsh_comp=$temp/.zsh_completion 
        fi
        
        zsh_comp(){
            cp $zsh_alias $HOME
            if ! grep -q '\[ -f ~/.zsh_completion \] && source ~/.zsh_completion' ~/.zshrc; then
                if grep -q "[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases" ~/.zshrc; then
                    sed -i 's|\([ -f ~/.zsh_aliases ] \&\& source ~/.zsh_aliases\)|[ -f ~/.zsh_completion ] \&\& source ~/.zsh_completion\n\n\1|' ~/.zshrc 
                elif grep -q "[ -f ~/.zsh_keybinds ] && source ~/.zsh_keybinds" ~/.zshrc; then
                    sed -i 's|\([ -f ~/.zsh_keybinds ] \&\& source ~/.zsh_keybinds\)|[ -f ~/.zsh_completion ] \&\& source ~/.zsh_completion\n\n\1|' ~/.zshrc 
                else
                    printf "\n[ -f ~/.zsh_completion ] && source ~/.zsh_completion\n\n" >> ~/.zshrc
                fi
            fi
        }
    yes-edit-no -f zsh_comp -g "$zsh_comp" -p "Install $HOME/.zsh_completion? (Loads all zsh completions (under /usr/share/zsh/site-functions and $HOME/.zsh_completion.d/site-functions) while also settings specific styles for certain zsh completions?"
    fi

    if (test -n "$BASH_C_G" && (! test -d /usr/share/bash-completion/completions)) || (test -n "$ZSH_C_G" && (! test -d /usr/share/zsh/site-functions)); then
        if hash bash &> /dev/null && ! test -d /usr/share/bash-completion/completions/; then
            printf "${YELLOW}/usr/share/bash-completion/completions/${yellow} not created${normal}\n" 
            readyn -p "Create ${CYAN}/usr/share/bash-completion/completions/${GREEN} (Requires ${RED}sudo${GREEN}?" bcomp_dg
            if [[ "$bcomp_dg" == 'y' ]]; then
                sudo mkdir -p /usr/share/bash-completion/completions/ 
            fi
        fi
        if hash zsh &> /dev/null && ! test -d /usr/share/zsh/site-functions/; then
            printf "${YELLOW}/usr/share/zsh/site-functions/${yellow} not created${normal}\n" 
            readyn -p "Create ${CYAN}/usr/share/zsh/site-functions/${GREEN} (Requires ${RED}sudo${GREEN}?" zcomp_d
            if [[ "$zcomp_d" == 'y' ]]; then
                sudo mkdir -p /usr/share/zsh/site-functions/ 
            fi
        fi
        
        if test -n "$BASH_C_G" && (test -d /usr/share/bash-completion/completions) && ! test -f /usr/share/bash-completion/bash_completion; then
            
            if ! test -f /etc/bash.bashrc; then
                sudo touch /etc/bash.bashrc 
            fi
           
            printf "${YELLOW}/usr/share/bash-completion/bash_completion${yellow} not installed${normal}\n" 
            readyn -p "Install ${CYAN}bash-completion${GREEN}?" bash_comp
            if [[ "$bash_comp" == 'y' ]]; then
                eval "$pac_ins_y bash-completion" 
            fi
        fi
       
        if test -f /usr/share/bash-completion/bash_completion && (! grep -q '\[ -f /usr/share/bash-completion/bash_completion \]' /etc/bash.bashrc && ! grep -q 'if \[\[ -r /usr/share/bash-completion/bash_completion \]\]; then' /etc/bash.bashrc); then
            if grep -q '\[ -f /etc/bash_aliasess \]' /etc/bash.bashrc; then
                sudo sed -i 's|\(\[ -f /etc/bash_aliases \] \&\& source /etc/bash_aliases\)|\[ -f /usr/share/bash-completion/bash_completion \] \&\& source /usr/share/bash-completion/bash_completion\n\n\1|g' /etc/bash.bashrc
            else
                echo '[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion' | sudo tee -a /etc/bash.bashrc &> /dev/null
            fi

        fi 

        if test -n "$ZSH_C_G" && (test -d /usr/share/zsh/site-functions/) && ! test -f /etc/zsh_completion; then
            
            if ! test -f /etc/zshrc; then
                sudo touch /etc/zshrc 
            fi

            printf "${YELLOW}/etc/zsh_completion${yellow} not installed${normal}\n" 
            zsh_comp="$TOP/shell/completion/zsh_completion"    
            if ! test -f $zsh_comp; then
                temp=$(mktemp -d) 
                wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/completion/zsh_completion > $temp/zsh_completion 
                zsh_comp=$temp/zsh_completion 
            fi
            
            zsh_comp_g(){
                sudo cp -v $zsh_comp /etc/zsh_completion
                if ! grep -q '\[ -f /etc/zsh_completion \] && source /etc/zsh_completion' /etc/zshrc; then
                    if grep -q '\[ -f /etc/zsh_aliases \]' /etc/zshrc; then
                        sudo sed -i 's|\(\[ -f /etc/zsh_aliases \] \&\& source /etc/zsh_aliases\)|\[ -f /etc/zsh_completion \] \&\& source /etc/zsh_completion\n\n\1|g' /etc/zshrc
                    else
                        echo '[ -f /etc/zsh_completion ] && source /etc/zsh_completion' | sudo tee -a /etc/zshrc &> /dev/null
                    fi

                fi
            }
            yes-edit-no -f zsh_comp_g -g "$zsh_comp" -p "Install /etc/zsh_completion? (Sources everything under  /usr/shar/zsh/site-functions)?"
        fi
         
    fi
fi
