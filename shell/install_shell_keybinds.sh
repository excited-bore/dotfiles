SYSTEM_UPDATED="TRUE"

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

if test -z "$BASH_K" && hash bash &> /dev/null && (! test -f ~/.bashrc || ! test -d ~/.bash_keybinds.d || ! test -f ~/.bash_keybinds || ! test -f /etc/bash.bashrc || ! test -d /etc/bash_keybinds.d || ! test -f /etc/bash_keybinds) && test -z "$ZSH_K" && hash zsh &> /dev/null && (! test -f ~/.zshrc || ! test -d ~/.zsh_keyinds.d || ! test -f ~/.zsh_keybinds || ! test -f /etc/zshrc || ! test -d /etc/zsh_keybinds.d || ! test -f /etc/zsh_keybinds); then
   reade -Q 'GREEN' -i 'both bash zsh' -p "Create directories and install files that bind keys to shortcuts in ${CYAN}Bash${GREEN}, ${CYAN}Zsh${GREEN} or both? [Both/bash/zsh]: " bash_zsh_keybind
elif test -z "$BASH_K" && hash bash &> /dev/null && (! test -f ~/.bashrc || ! test -d ~/.bash_keyinds.d || ! test -f ~/.bash_keyinds || ! test -f /etc/bash.bashrc || ! test -d /etc/bash_keyinds.d || ! test -f /etc/bash_keybinds); then
   readyn -p "Create directories and install files that bind keys to shortcuts for ${CYAN}Bash${GREEN}?" bash_zsh_keybind
   [[ "$bash_zsh_keybind" == 'y' ]] && bash_zsh_keybind='bash' 
elif test -z "$ZSH_K" && hash zsh &> /dev/null && (! test -f ~/.zshrc || ! test -d ~/.zsh_keybinds.d || ! test -f ~/.zsh_keybinds || ! test -f /etc/zshrc || ! test -d /etc/keybinds.d || ! test -d /etc/zsh_keybinds.d || ! test -f /etc/zsh_keybinds); then
   readyn -p "Create directories and install files that bind keys to shortcuts for ${CYAN}Zsh${GREEN}?" bash_zsh_keybind
   [[ "$bash_zsh_keybind" == 'y' ]] && bash_zsh_keybind='zsh' 
fi

if [[ "$bash_zsh_keybind" == 'both' || "$bash_zsh_keybind" == 'bash' ]]; then
    BASH_K="1" 
    if ! test -f /etc/bash.bashrc || ! test -d /etc/bash_keybinds.d || ! test -f /etc/bash_keybinds; then
        readyn -p "Create directories and install keybinds for ${CYAN}bash systemwide/for all users${GREEN}?" bash_g
        if [[ "$bash_g" == 'y' ]]; then
            BASH_K_G='1'
        else
            BASH_K_G='0'
        fi
    fi
else
    BASH_K='0' BASH_K_G='0'
fi

if [[ "$bash_zsh_keybind" == 'both' || "$bash_zsh_keybind" == 'zsh' ]]; then
    ZSH_K="1" 
    if ! test -f /etc/zshrc || ! test -d /etc/zsh_keybinds.d || ! test -f /etc/zsh_keybinds; then
        readyn -p "Create directories and install keybinds for ${CYAN}zsh systemwide/for all users${GREEN}?" zsh_g
        if [[ "$zsh_g" == 'y' ]]; then
            ZSH_K_G='1'
        else
            ZSH_K_G='0'
        fi
    fi
else
    ZSH_K='0' ZSH_K_G='0'
fi


if ! [[ -f $TOP/checks/check_defaultTerm_keybind.sh ]]; then
   source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_defaultTerm_keybind.sh)
else
   source $TOP/checks/check_defaultTerm_keybind.sh 
fi


if ! hash pcregrep &> /dev/null; then
    eval "${pac_ins_y} pcregrep" 
fi


# Bash-keybinds

if [[ "$BASH_K" == '1' ]]; then

    if ! test -f ~/.inputrc; then
        
        printf "${YELLOW}$HOME/.inputrc${yellow} not installed${normal}\n" 
        binds=$TOP/shell/keybinds/.inputrc
        if ! test -f $binds; then
            temp=$(mktemp -d) 
            wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/keybinds/.bash_keybinds > $temp/.inputrc 
            binds=$temp/.inputrc 
        fi
   
        # Readline 

        inputrc() {

            if ! [[ -f /etc/inputrc ]]; then
                sed -i 's/^$include \/etc\/inputrc/#$include \/etc\/inputrc/g' $binds
            fi

            sed -i "s|^set show-mode-in-prompt .*|#set show-mode-in-prompt on|g" $binds

            sed -i "s|\([[:space:]+]\)set vi-ins-mode-string|\1#set set-vi-ins-mode-prompt|g" $binds
            sed -i "s|\([[:space:]+]\)set vi-cmd-mode-string|\1#set set-vi-cmd-mode-prompt|g" $binds
            sed -i "s|\([[:space:]+]\)set emacs-mode-string|\1#set set-emacs-mode-prompt|g" $binds

            printf "${GREEN}%s${normal}\n" "The readline options for your prompt are: "
            printf "${green}%s${normal}\n" " - Show a different cursor for emacs and vi-insert mode ('|' instead of '█')"
            printf "${green} - Show a different cursor for emacs/vi-insert mode ${GREEN}and${green}\n   Show a visual indicator for which mode is currently active '(emacs)/(vi)/(cmd)'\n${normal}"
            printf "${green} - Do both of these but with a colored mode indicator (magenta for (emacs), blue for (vi)/(cmd))'\n${normal}"
            
            local vimde vivisual xtrm 

            reade -Q 'GREEN' -i "cursor-mode cursor cursor-colored-mode none" -p "Which do you prefer?: [Cursor-mode/cursor/cursor-colored-mode/none]: " vivisual
            if [[ "$vivisual" == "cursor" ]]; then
                sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
                
                sed -i 's|#\(set vi-ins-mode-string \\1\\e\[?0c.*\)|\1|g' $binds
                sed -i 's|#\(set vi-cmd-mode-string \\1\\e\[?8c.*\)|\1|g' $binds
                sed -i 's|#\(set emacs-mode-string  \\1\\e\[?0c.*\)|\1|g' $binds

                sed -i 's|#\(set vi-ins-mode-string \\1\\e\[5 q.*\)|\1|g' $binds
                sed -i 's|#\(set vi-cmd-mode-string \\1\\e\[2 q.*\)|\1|g' $binds
                sed -i 's|#\(set emacs-mode-string  \\1\\e\[5 q.*\)|\1|g' $binds
            
            elif [[ "$vivisual" == "cursor-mode" ]]; then
                sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
                
                sed -i 's|#\(set vi-ins-mode-string (ins)\\1\\e\[?0c.*\)|\1|g' $binds
                sed -i 's|#\(set vi-cmd-mode-string (cmd)\\1\\e\[?8c.*\)|\1|g' $binds
                sed -i 's|#\(set emacs-mode-string  (emacs)\\1\\e\[?0c.*\)|\1|g' $binds

                sed -i 's|#\(set vi-ins-mode-string (ins)\\1\\e\[5 q.*\)|\1|g' $binds
                sed -i 's|#\(set vi-cmd-mode-string (cmd)\\1\\e\[2 q.*\)|\1|g' $binds
                sed -i 's|#\(set emacs-mode-string  (emacs)\\1\\e\[5 q.*\)|\1|g' $binds
            
            elif [[ "$vivisual" == "cursor-colored-mode" ]]; then
                sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
                
                sed -i 's|#\(set vi-ins-mode-string \\1\\e\[34;1m\\2(ins)\\1\\e\[?0c.*\)|\1|g' $binds
                sed -i 's|#\(set vi-cmd-mode-string \\1\\e\[34;1m\\2(cmd)\\1\\e\[?8c.*\)|\1|g' $binds
                sed -i 's|#\(set emacs-mode-string  \\1\\e\[35;1m\\2(emacs)\\1\\e\[?0c.*\)|\1|g' $binds

                sed -i 's|#\(set vi-ins-mode-string \\1\\e\[34;1m\\2(ins)\\1\\e\[5 q.*\)|\1|g' $binds
                sed -i 's|#\(set vi-cmd-mode-string \\1\\e\[34;1m\\2(cmd)\\1\\e\[2 q.*\)|\1|g' $binds
                sed -i 's|#\(set emacs-mode-string  \\1\\e\[35;1m\\2(emacs)\\1\\e\[5 q.*\)|\1|g' $binds
                 
            fi

            printf "${cyan}You can always switch between vi/emacs mode with ${CYAN}Ctrl-o${normal}\n"

            # We set editing mode later in keybinds.bash
            sed -i "s|^set editing-mode .*|#set editing-mode vi|g" $binds

            sed -i "s|^setxkbmap |#setxkbmap |g" $binds

            if [[ "$XDG_SESSION_TYPE" == 'x11' && $USER != 'root' ]]; then
                readyn -p "Set caps to escape? (Might cause X11 errors with SSH)" xtrm
                if [[ "$xtrm" = "y" ]]; then
                    sed -i "s|#setxkbmap |setxkbmap |g" $binds
                fi
            else
                # X based settings is generally not for root and will throw errors
                if grep -q '^setxkbmap' $binds; then
                    sed -i 's|^setxkbmap|#setxkbmap|g' $binds
                fi
            fi

            cp -t $HOME $binds
            
            if [ -f ~/.environment.env ]; then
                sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' ~/.environment.env
            fi
        }

        yes-edit-no -f inputrc -g "$binds" -p "Install ${CYAN}.inputrc${GREEN} at ${BLUE}$HOME${GREEN}? (Readline configuration)"
    fi     
   
    # Bash-keybinds

    if ! test -d ~/.bash_keybinds.d/; then
        printf "${YELLOW}$HOME/.bash_keybinds.d/${yellow} not created${normal}\n" 
        readyn -p "Create ${CYAN}$HOME/.bash_keybinds.d/${GREEN}?" keybinds_d
        if [[ "$keybinds_d" == 'y' ]]; then
            mkdir $HOME/.bash_keybinds.d 
        fi
    fi
    

    if test -d ~/.bash_keybinds.d && ! test -f $HOME/.bash_keybinds; then
        printf "${YELLOW}$HOME/.bash_keybinds${yellow} not installed${normal}\n" 
        binds0=$TOP/shell/keybinds/.bash_keybinds.d/00-bind-empty.bash
        binds1=$TOP/shell/keybinds/.bash_keybinds.d/01-cdw.bash
        binds2=$TOP/shell/keybinds/.bash_keybinds.d/02-keybinds.bash
        binds3=$TOP/shell/keybinds/.bash_keybinds
        if ! [[ -f $binds ]]; then
            tmp0=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/keybinds/.bash_keybinds.d/00-binds-empty.bash > $tmp0
            tmp1=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/keybinds/.bash_keybinds.d/01-cdw.bash > $tmp1
            tmp2=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/keybinds/.bash_keybinds.d/02-keybinds.bash > $tmp2
            tmp3=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/keybinds/.bash_keybinds > $tmp3
            binds0=$tmp0
            binds1=$tmp1
            binds2=$tmp2
            binds3=$tmp3
        fi
        
        bash-keybinds() {
            
            readyn -n -N "CYAN" -p "Startup in ${MAGENTA}vi-mode${CYAN} instead of ${GREEN}emacs${CYAN} mode? (might cause issues with pasteing)" vimde

            sed -i "s|^bind 'set editing-mode vi'|# bind 'set editing-mode vi'|g" $binds2

            if [[ "$vimde" == "y" ]]; then
                sed -i "s|# bind 'set editing-mode vi'|bind 'set editing-mode vi'|g" $binds2
            fi

            # X based settings is generally not for root and will throw errors
            if [[ "$XDG_SESSION_TYPE" == 'x11' && $USER != 'root' ]] && grep -q '^setxkbmap' $binds2; then
                sed -i 's|^setxkbmap|#setxkbmap|g' $binds2
            fi

            cp -t $HOME $binds3
            cp -t ~/.bash_keybinds.d/ $binds0 $binds1 $binds2
      
            if ! test -f ~/.bashrc; then
                touch ~/.bashrc 
            fi

            # Make sure the ~/.bash_keybinds sources AFTER ~/.bash_aliases to prevent certain keybinds from breaking
            if ! grep -q "source ~/.bash_keybinds" ~/.bashrc; then
                if grep -q "\[ -f ~/.bash_aliases \] && source ~/.bash_aliases" ~/.bashrc || grep -q '^if [[ -f ~/.bash_aliases ]]; then' ~/.bashrc; then
                    if grep -q "\[ -f ~/.bash_aliases \] && source ~/.bash_aliases" ~/.bashrc; then
                        sed -i 's|\(\[ -f ~/.bash_keybinds \] \&\& source ~/.bash_keybinds\)|\1\n\n[ -f ~/.bash_keybinds \] \&\& source ~/.bash_keybinds|' ~/.bashrc 
                    else
                        sed -i -e 's|\(if \[\[ -f \~/.bash_aliases \]\]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.bash_aliases later down ~/.bashrc\n\n#\1|g' -e 's|\(^\s*\. ~/.bash_aliases\)|#\1|' ~/.bashrc
                        local ubbashrcfi="$(awk '/\. ~\/.bash_aliases/{print NR+1};' ~/.bashrc)" 
                        sed -i "$ubbashrcfi s/^fi/#fi/" ~/.bashrc   
                        printf '\n[ -f ~/.bash_aliases ] && source ~/.bash_aliases\n\n' >> ~/.bashrc
                        printf '\n[ -f ~/.bash_keybinds ] && source ~/.bash_keybinds\n\n' >> ~/.bashrc
                    fi
                elif grep -q '\[ -f ~/.bash_completion \] && \[ -z ${BASH_COMPLETION_VERSINFO:-} \] && source ~/.bash_completion' ~/.bashrc; then
                    sed -i 's|\([ -f ~/.bash_completion ] \&\& [ -z ${BASH_COMPLETION_VERSINFO:-} ]\) && source ~/.bash_completion|\1\n\n[ -f ~/.bash_keybinds \] \&\& source ~/.bash_keybinds|' ~/.bashrc 
                else
                    printf "\n[ -f ~/.bash_keybinds ] && source ~/.bash_keybinds\n\n" >> ~/.bashrc
                fi
            fi
    
        }

        yes-edit-no -f bash-keybinds -g "$binds3 $binds0 $binds1 $binds2" -p "Install ${CYAN}.bash_keybinds${GREEN} at ${BLUE}$HOME${GREEN} and ${CYAN}00-bind-empty.bash${GREEN}, ${CYAN}01-cdw.bash${GREEN} and ${CYAN}02-keybinds.bash${GREEN} at ${BLUE}$HOME/.bash_keybinds.d/${GREEN}? (keybinds configuration)"

    fi
fi

if [[ $ZSH_K == '1' ]]; then

    if ! test -d ~/.zsh_keybinds.d/; then
        printf "${YELLOW}$HOME/.zsh_keybinds.d/${yellow} not created${normal}\n" 
        readyn -p "Create ${CYAN}$HOME/.zsh_keybinds.d/${GREEN}?" keybinds_d
        if [[ "$keybinds_d" == 'y' ]]; then
            mkdir $HOME/.zsh_keybinds.d 
        fi
    fi

    if test -d ~/.zsh_keybinds.d && ! test -f $HOME/.zsh_keybinds; then
        printf "${YELLOW}$HOME/.zsh_keybinds${yellow} not installed${normal}\n" 
        binds=$TOP/shell/keybinds/.zsh_keybinds.d/00-bind-empty.zsh
        binds0=$TOP/shell/keybinds/.zsh_keybinds.d/01-keybinds.zsh
        binds1=$TOP/shell/keybinds/.zsh_keybinds
        if ! [[ -f $binds ]]; then
            tmp=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/keybinds/.zsh_keybinds.d/00-binds-empty.zsh > $tmp
            tmp0=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/keybinds/.zsh_keybinds.d/01-keybinds.zsh > $tmp0
            tmp1=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/shell/keybinds/.zsh_keybinds > $tmp1
            binds=$tmp
            binds0=$tmp0
            binds1=$tmp1
        fi
        
        zsh-keybinds() {

            cp -t ~/.zsh_keybinds.d/ $binds $binds0
            cp -t $HOME $binds1 
           
            if ! test -f ~/.zshrc; then
                touch ~/.zshrc 
            fi
    
            # Keybinds sourced after aliases and completions 

            if ! grep -q "source ~/.zsh_keybinds" ~/.zshrc; then
                if grep -q "\[ -f ~/.zsh_aliases \] && source ~/.zsh_aliases" ~/.zshrc; then
                    if grep -q "\[ -f ~/.zsh_aliases \] && source ~/.zsh_aliases" ~/.zshrc; then
                        sed -i 's|\(\[ -f \~/.zsh_aliases \] \&\& source \~/.zsh_aliases\)|\1\n\n\[ -f \~/.zsh_keybinds \] \&\& source \~/.zsh_keybinds\n|g' ~/.zshrc
                    elif grep -q "\[ -f ~/.zsh_completion \] && source ~/.zsh_completion" ~/.zshrc; then
                        sed -i 's|\(\[ -f \~/.zsh_completion \] \&\& source \~/.zsh_completion\)|\1\n\n\[ -f \~/.zsh_keybinds \] \&\& source \~/.zsh_keybinds\n|g' ~/.zshrc
                    fi
                else
                    printf "\n[ -f ~/.zsh_keybinds ] && source ~/.zsh_keybinds\n\n" >> ~/.zshrc
                fi
            fi
    
        }

        yes-edit-no -f zsh-keybinds -g "$binds1 $binds0 $binds" -p "Install ${CYAN}.zsh_keybinds${GREEN} at ${BLUE}$HOME${GREEN} and ${CYAN}00-bind-empty.zsh${GREEN} and ${CYAN}01-keybinds.zsh${GREEN} at ${BLUE}$HOME/.zsh_keybinds.d/${GREEN}? (Zsh keybinds configuration)"

    fi
fi

if [[ "$DESKTOP_SESSION" == 'xfce' ]]; then
    if ! test -f $XDG_CONFIG_HOME/xfce4/helpers.rc; then
         touch $XDG_CONFIG_HOME/xfce4/helpers.rc 
    fi
    if ! grep -q "TerminalEmulator" $XDG_CONFIG_HOME/xfce4/helpers.rc; then
        readyn -p "Set default terminal emulator for ${CYAN}xfce4${GREEN}?" deftermemyn
        if [[ $deftermemyn == 'y' ]]; then
            termems="xfce4-terminal" 
            if hash kitty &> /dev/null; then
                termems="kitty $termems" 
            fi
             
            reade -Q 'GREEN' -i "$termems" -p 'Which emulator?: ' emulatr
            if [[ -n "$emulatr" ]]; then
                echo "TerminalEmulator=$emulatr" >> $XDG_CONFIG_HOME/xfce4/helpers.rc 
            fi
        fi
    fi

   
    nobind=0
    while read -r i; do
        if [[ "$i" == 'xfce4-terminal' ]] || [[ "$i" == 'exo-open --launch TerminalEmulator' ]] || (hash kitty &> /dev/null && [[ "$i" == 'kitty' ]]); then
            unset nobind 
        fi
    done <<< "$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{$1=""; print}' | sed 's/^ //g')" 
    
    if [[ $nobind ]]; then 
        value='exo-open --launch TerminalEmulator' 
        if grep -q "TerminalEmulator" $XDG_CONFIG_HOME/xfce4/helpers.rc; then
            emulatr=$(grep --color=never 'TerminalEmulator' $XDG_CONFIG_HOME/xfce4/helpers.rc | cut -d= -f2)
            readyn -p "Set keybind for the default terminal emulator set for xfce4 - ${CYAN}$emulatr${GREEN}?" setermemkeybind
        else
            if [[ -n "$emulatr" ]]; then
                value="$emulatr"
            else
                termems="xfce4-terminal" 
                if hash kitty &> /dev/null; then
                    termems="kitty $termems" 
                fi
                 
                reade -Q 'GREEN' -i "$termems" -p 'Which emulator?: ' emulatr
                value="$emulatr" 
            fi
            readyn -p "Set keybind for ${CYAN}$emulatr${GREEN}?" setermemkeybind
        fi
        
        if [[ "y" == "$setermemkeybind" ]]; then
            
            printf "Format: ${CYAN}[Control/Shift/Alt/Windowkey]-[Control/Shift/Alt/Windowkey]-[Control/Shift/Alt/Windowkey]${GREEN}-Key\n${normal}"

            list-binds-xfce4
            
            reade -Q 'GREEN' -i 'Control-Alt-t Windowkey-t' -p 'What keybind?: ' keyb
                
            while [[ -n "$keyb" ]]; do 
                usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{print $1;}' | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
                
                for i in ${usedkeys[@]}; do
                    if [[ $i == $keyb ]]; then
                        xfce-check-binds "$keyb" "$value"
                        if [[ $? == 1 ]]; then 
                            xfce-keybinds-handle-error 1
                        elif [[ $? == 2 ]]; then 
                            xfce-keybinds-handle-error 2
                        elif [[ $? == 3 ]]; then
                            binds='Control-Alt-t Windowkey-t'
                            if [[ $keyb == 'Control-Alt-t' ]]; then
                               binds="Windowkey-t" 
                            elif [[ $keyb == 'Windowkey-t' ]]; then 
                               binds='Control-Alt-t'
                            fi
                            reade -Q 'GREEN' -i "$binds" -p 'What keybind?: ' keyb
                            unset binds

                            list-binds-xfce4
                            usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{print $1;}' | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
                            for j in ${usedkeys[@]}; do
                                if [[ $j == $keyb ]]; then
                                    xfce-check-binds "$keyb" "$value"
                                    if [[ $? == 3 ]]; then
                                       xfce-keybinds-handle-error 1
                                       xfce-keybinds-handle-error 2
                                    fi
                                fi
                            done

                            #usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | awk '{print $1;}' | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
                            #for j in ${usedkeys[@]}; do
                            #    if [[ $j == $keyb ]]; then
                            #        xfce-check-binds "$keyb" "$value"
                            #        if [[ $? == 3 ]]; then
                            #           xfce-keybinds-handle-error 1
                            #           xfce-keybinds-handle-error 2
                            #        fi
                            #    fi
                            #done
                        fi
                    fi
                done
                
                #usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | awk '{print $1;}' | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )

                #for i in ${usedkeys[@]}; do
                #    if [[ $i == $keyb ]]; then
                #        xfce-check-binds "$keyb" "$value"
                #        if [[ $? == 1 ]]; then 
                #            xfce-keybinds-handle-error 1
                #        elif [[ $? == 2 ]]; then 
                #            xfce-keybinds-handle-error 2
                #        elif [[ $? == 3 ]]; then
                #            binds='Control-Alt-t Windowkey-t'
                #            if [[ $keyb == 'Control-Alt-t' ]]; then
                #               binds="Windowkey-t" 
                #            elif [[ $keyb == 'Windowkey-t' ]]; then 
                #               binds='Control-Alt-t'
                #            fi
                #            reade -Q 'GREEN' -i "$binds" -p 'What keybind?: ' keyb
                #            unset binds

                #            list-binds-xfce4 
                #            usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{print $1;}' | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g;' )
                #            for j in ${usedkeys[@]}; do
                #                if [[ $j == $keyb ]]; then
                #                    xfce-check-binds "$keyb" "$value"
                #                    if [[ $res1 == 3 ]]; then
                #                       xfce-keybinds-handle-error 1
                #                       xfce-keybinds-handle-error 2
                #                    fi
                #                fi
                #            done

                #            usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{print $1;}' | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;')
                #            for j in ${usedkeys[@]}; do
                #                if [[ $j == $keyb ]]; then
                #                    xfce-check-binds "$keyb" "$value"
                #                    if [[ $? == 3 ]]; then
                #                       xfce-keybinds-handle-error 1
                #                       xfce-keybinds-handle-error 2
                #                    fi
                #                fi
                #            done
                #        fi
                #    fi
                #done 
                keyb=$(echo "$keyb" | sed 's|-||g; s|Control|<Primary>|g; s|Shift|<Shift>|g; s|Alt|<Alt>|g; s|Windowkey|<Super>|g;' )
            
                xfconf-query -c xfce4-keyboard-shortcuts -n -p /commands/custom/$keyb -t string -s "$value" 
                #xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/$keyb -l -v 
                unset keyb 
            done
        fi
        unset keyb nobind kittn usedkeys i j
    fi
fi