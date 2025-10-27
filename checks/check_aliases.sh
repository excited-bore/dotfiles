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

if (test -z "$BASH_A" && hash bash &> /dev/null && (! test -f ~/.bashrc || ! test -d ~/.aliases.d || ! test -d ~/.bash_aliases.d || ! test -f ~/.bash_aliases || ! test -f /etc/bash.bashrc || ! test -d /etc/aliases.d || ! test -d /etc/bash_aliases.d || ! test -f /etc/bash_aliases)) && (test -z "$ZSH_A" && hash zsh &> /dev/null && (! test -f ~/.zshrc || ! test -d ~/.aliases.d || ! test -d ~/.zsh_aliases.d || ! test -f ~/.zsh_aliases || ! test -f /etc/zshrc || ! test -d /etc/aliases.d || ! test -d /etc/zsh_aliases.d || ! test -f /etc/zsh_aliases)); then
   reade -Q 'GREEN' -i 'both bash zsh' -p "Create directories and install files filled with aliases/functions for ${CYAN}Bash${GREEN}, ${CYAN}Zsh${GREEN} or both? [Both/bash/zsh]: " bash_zsh_alias
elif (test -z "$BASH" && hash bash &> /dev/null && (! test -f ~/.bashrc || ! test -d ~/.aliases.d || ! test -d ~/.bash_aliases.d || ! test -f ~/.bash_aliases || ! test -f /etc/bash.bashrc || ! test -d /etc/aliases.d || ! test -d /etc/bash_aliases.d || ! test -f /etc/bash_aliases)); then
   readyn -p "Install aliases/functions for ${CYAN}Bash${GREEN}?" bash_zsh_alias
   [[ "$bash_zsh_alias" == 'y' ]] && bash_zsh_alias='bash' 
elif (test -z "$ZSH" && hash zsh &> /dev/null && (! test -f ~/.zshrc || ! test -d ~/.aliases.d || ! test -d ~/.zsh_aliases.d || ! test -f ~/.zsh_aliases || ! test -f /etc/zshrc || ! test -d /etc/aliases.d || ! test -d /etc/zsh_aliases.d || ! test -f /etc/zsh_aliases)); then
   readyn -p "Install aliases/functions for ${CYAN}Zsh${GREEN}?" bash_zsh_alias
   [[ "$bash_zsh_alias" == 'y' ]] && bash_zsh_alias='zsh' 
fi

if [[ "$bash_zsh_alias" == 'both' || "$bash_zsh_alias" == 'bash' ]]; then
    BASH_A="1" 
    if test -z "$BASH_A_G" && (! test -f /etc/bash.bashrc || ! test -d /etc/aliases.d || ! test -d /etc/bash_aliases.d || ! test -f /etc/bash_aliases); then
        readyn -p "Install aliases for ${CYAN}bash systemwide/for all users${GREEN}?" bash_g
        if [[ "$bash_g" == 'y' ]]; then
            BASH_A_G='1'
        fi
    fi
fi
if [[ "$bash_zsh_alias" == 'both' || "$bash_zsh_alias" == 'zsh' ]]; then
    ZSH_A="1" 
    if test -z "$ZSH_A_G" && (! test -f /etc/zshrc || ! test -d /etc/aliases.d || ! test -d /etc/zsh_aliases.d || ! test -f /etc/zsh_aliases); then
        readyn -p "Install aliases for ${CYAN}zsh systemwide/for all users${GREEN}?" zsh_g
        if [[ "$zsh_g" == 'y' ]]; then
            ZSH_A_G='1'
        fi
    fi
fi


if (test -n "$BASH_A" && (! test -d ~/.aliases.d || ! test -d ~/.bash_aliases.d)) || (test -n "$ZSH_A" && (! test -d ~/.aliases.d || ! test -d ~/.zsh_aliases.d)); then
    if ! test -d ~/.aliases.d/; then
        printf "${YELLOW}$HOME/.aliases.d/${yellow} not created${normal}\n" 
        readyn -p "Create ${CYAN}$HOME/.aliases.d/${GREEN}?" aliases_d
        if [[ "$aliases_d" == 'y' ]]; then
            mkdir $HOME/.aliases.d 
        fi
    fi
    if test -n "$BASH_A" && ! test -d ~/.bash_aliases.d/; then
        printf "${YELLOW}$HOME/.bash_aliases.d/${yellow} not created${normal}\n" 
        readyn -p "Create ${CYAN}$HOME/.bash_aliases.d/${GREEN}?" baliases_d
        if [[ "$baliases_d" == 'y' ]]; then
            mkdir $HOME/.bash_aliases.d 
        fi
    fi
    if test -n "$ZSH_A" && ! test -d ~/.zsh_aliases.d/; then
        printf "${YELLOW}$HOME/.zsh_aliases.d/${yellow} not created${normal}\n" 
        readyn -p "Create ${CYAN}$HOME/.zsh_aliases.d/${GREEN}?" zaliases_d
        if [[ "$zaliases_d" == 'y' ]]; then
            mkdir $HOME/.zsh_aliases.d 
        fi
    fi

    if ! test -f ~/.bashrc; then
        touch $HOME/.bashrc 
    fi
    
    if test -n "$BASH_A" && (test -d ~/.aliases.d/ || test -d ~/.bash_aliases.d) && ! test -f $HOME/.bash_aliases; then
        printf "${YELLOW}$HOME/.bash_aliases${yellow} not installed${normal}\n" 
        bash_alias="$TOP/shell/aliases/.bash_aliases"    
        if ! test -f $bash_alias; then
            temp=$(mktemp -d) 
            wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.bash_aliases > $temp/.bash_aliases 
            bash_alias=$temp/.bash_aliases 
        fi
        
        bash_alias(){
            cp $bash_alias $HOME
            if ! grep -q '\[ -f ~/.bash_aliases \] && source ~/.bash_aliases' ~/.bashrc; then
                if grep -q '^if \[ -f ~/.bash_aliases \]; then' ~/.bashrc; then
                    sed -i -e 's|\(if \[ -f \~/.bash_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.bash_aliases later down ~/.bashrc\n\n#\1|g' -e 's|\(^\s*\. ~/.bash_aliases\)|#\1|' ~/.bashrc
                    local ubbashrcfi="$(awk '/\. ~\/.bash_aliases/{print NR+1};' ~/.bashrc)" 
                    sed -i "$ubbashrcfi s/^fi/#fi/" ~/.bashrc   
                elif grep -q '\[ -f ~/.bash_keybinds \]' ~/.bashrc; then
                    sed -i 's|\(\[ -f \~/.bash_keybinds \] \&\& source \~/.bash_keybinds\)|\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\n\n\1|g' ~/.bashrc
                else
                    echo '[ -f ~/.bash_aliases ] && source ~/.bash_aliases' >> ~/.bashrc
                fi

            fi
        }
        yes-edit-no -f bash_alias -g "$bash_alias" -p "Install $HOME/.bash_aliases? (Sources everything under $HOME/.aliases.d and $HOME/.bash_aliases.d)?"
    fi
    
    if test -n "$ZSH_A" && (test -d ~/.aliases.d/ || test -d ~/.bash_aliases.d) && ! test -f $HOME/.zsh_aliases; then
        if ! test -f ~/.zshrc; then
            touch $HOME/.zshrc 
        fi

        printf "${YELLOW}$HOME/.zsh_aliases${yellow} not installed${normal}\n" 
        zsh_alias="$TOP/shell/aliases/.zsh_aliases"    
        if ! test -f $zsh_alias; then
            temp=$(mktemp -d) 
            wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.zsh_aliases > $temp/.zsh_aliases 
            zsh_alias=$temp/.zsh_aliases 
        fi
        
        zsh_alias(){
            cp $zsh_alias $HOME
            if ! grep -q '\[ -f ~/.zsh_aliases \] && source ~/.zsh_aliases' ~/.zshrc; then
                if grep -q '^if \[ -f ~/.zsh_aliases \]; then' ~/.zshrc; then
                    sed -i -e 's|\(if \[ -f \~/.zsh_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.zsh_aliases later down ~/.zshrc\n\n#\1|g' -e 's|\(^\s*\. ~/.zsh_aliases\)|#\1|' ~/.zshrc
                    local ubzshrcfi="$(awk '/\. ~\/.zsh_aliases/{print NR+1};' ~/.zshrc)" 
                    sed -i "$ubzshrcfi s/^fi/#fi/" ~/.zshrc   
                elif grep -q '\[ -f ~/.zsh_keybinds \]' ~/.zshrc; then
                    sed -i 's|\(\[ -f \~/.zsh_keybinds \] \&\& source \~/.zsh_keybinds\)|\[ -f \~/.zsh_aliases \] \&\& source \~/.zsh_aliases\n\n\1|g' ~/.zshrc
                else
                    echo '[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases' >> ~/.zshrc
                fi

            fi
        }
        yes-edit-no -f zsh_alias -g "$zsh_alias" -p "Install $HOME/.zsh_aliases? (Sources everything under $HOME/.aliases.d and $HOME/.zsh_aliases.d)?"
    fi
     

    if (test -n "$BASH_A_G" && (! test -d /etc/aliases.d || ! test -d /etc/bash_aliases.d)) || (test -n "$ZSH_A_G" && (! test -d /etc/aliases.d || ! test -d /etc/zsh_aliases.d)); then
        if ! test -d /etc/.aliases.d/; then
            printf "${YELLOW}/etc/aliases.d/${yellow} not created${normal}\n" 
            readyn -p "Create ${CYAN}/etc/aliases.d/${GREEN}? (Requires ${RED}sudo${GREEN})" aliases_dg
            if [[ "$aliases_dg" == 'y' ]]; then
                sudo mkdir /etc/aliases.d 
            fi
        fi
        if hash bash &> /dev/null && ! test -d /etc/bash_aliases.d/; then
            printf "${YELLOW}/etc/bash_aliases.d/${yellow} not created${normal}\n" 
            readyn -p "Create ${CYAN}/etc/bash_aliases.d/${GREEN} (Requires ${RED}sudo${GREEN}?" baliases_dg
            if [[ "$baliases_dg" == 'y' ]]; then
                sudo mkdir /etc/bash_aliases.d 
            fi
        fi
        if hash zsh &> /dev/null && ! test -d /etc/zsh_aliases.d/; then
            printf "${YELLOW}/etc/zsh_aliases.d/${yellow} not created${normal}\n" 
            readyn -p "Create ${CYAN}/etc/zsh_aliases.d/${GREEN} (Requires ${RED}sudo${GREEN}?" zaliases_d
            if [[ "$zaliases_d" == 'y' ]]; then
                sudo mkdir /etc/zsh_aliases.d 
            fi
        fi
        
        if test -n "$BASH_A_G" && (test -d /etc/.aliases.d/ || test -d /etc/bash_aliases.d) && ! test -f /etc/bash_aliases; then
            
            if ! test -f /etc/bash.bashrc; then
                sudo touch /etc/bash.bashrc 
            fi
           
            printf "${YELLOW}/etc/bash_aliases${yellow} not installed${normal}\n" 
            bash_alias="$TOP/shell/aliases/.bash_aliases"    
            if ! test -f $bash_alias; then
                temp=$(mktemp -d) 
                wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.bash_aliases > $temp/.bash_aliases 
                bash_alias=$temp/.bash_aliases 
            fi
            
            bash_alias_g(){
                sudo cp -v $bash_alias /etc/bash_aliases
                if ! grep -q '\[ -f /etc/bash_aliases \] && source /etc/bash_aliases' /etc/bash.bashrc; then
                    if grep -q '\[ -f /etc/bash_keybinds \]' /etc/bash.bashrc; then
                        sudo sed -i 's|\(\[ -f \/etc/bash_keybinds \] \&\& source \/etc/bash_keybinds\)|\[ -f \/etc/bash_aliases \] \&\& source /etc/bash_aliases\n\n\1|g' /etc/bash.bashrc
                    else
                        echo '[ -f /etc/bash_aliases ] && source /etc/bash_aliases' | sudo tee -a /etc/bash.bashrc &> /dev/null
                    fi

                fi
            }
            yes-edit-no -f bash_alias_g -g "$bash_alias" -p "Install /etc/bash_aliases? (Sources everything under /etc/aliases.d and /etc/bash_aliases.d)?"
        fi
        
        if test -n "$ZSH_A_G" && (test -d /etc/.aliases.d/ || test -d /etc/zsh_aliases.d) && ! test -f /etc/zsh_aliases; then
            
            if ! test -f /etc/zshrc; then
                sudo touch /etc/zshrc 
            fi

            printf "${YELLOW}/etc/zsh_aliases${yellow} not installed${normal}\n" 
            zsh_alias="$TOP/shell/aliases/.zsh_aliases"    
            if ! test -f $zsh_alias; then
                temp=$(mktemp -d) 
                wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/aliases/.zsh_aliases > $temp/zsh_aliases 
                zsh_alias=$temp/zsh_aliases 
            fi
            
            zsh_alias_g(){
                sudo cp -v $zsh_alias /etc/zsh_aliases
                if ! grep -q '\[ -f /etc/zsh_aliases \] && source /etc/zsh_aliases' /etc/zshrc; then
                    if grep -q '\[ -f /etc/zsh_keybinds \]' /etc/zshrc; then
                        sed -i 's|\(\[ -f /etc/zsh_keybinds \] \&\& source /etc/zsh_keybinds\)|\[ -f /etc/zsh_aliases \] \&\& source /etc/zsh_aliases\n\n\1|g' /etc/zshrc
                    else
                        echo '[ -f /etc/zsh_aliases ] && source /etc/zsh_aliases' | sudo tee -a /etc/zshrc &> /dev/null
                    fi

                fi
            }
            yes-edit-no -f zsh_alias_g -g "$zsh_alias" -p "Install /etc/zsh_aliases? (Sources everything under /etc/aliases.d and /etc/zsh_aliases.d)?"
        fi
         
    fi
fi
